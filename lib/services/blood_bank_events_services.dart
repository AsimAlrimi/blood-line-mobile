import 'dart:convert';
import 'package:blood_line_mobile/main.dart';
import 'package:blood_line_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BloodBankEventService {
  static final _storage = const FlutterSecureStorage();
  static const String _baseUrl = 'http://10.0.2.2:5000';

  /// Fetch blood bank events for the current donor
  static Future<List<Map<String, dynamic>>?> getBloodBankEvents(BuildContext context) async {
    try {
      // Retrieve access token from secure storage
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        if (context.mounted) {
          await setData('AutoLogin', 'false');
          Navigator.pushReplacementNamed(context, AppRoutes.welcomePage); // Adjust with your actual route
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please log in again.')),
          );
        }
        return null;
      }

      // Make GET request to retrieve blood bank events
      final response = await http.get(
        Uri.parse('$_baseUrl/blood_bank_events'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['events']);
      } else if (response.statusCode == 403) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unauthorized access. Only donors can retrieve events.')),
          );
        }
        return null;
      } else if (response.statusCode == 401) {
        await setData('AutoLogin', 'false');
        Navigator.pushReplacementNamed(context, AppRoutes.welcomePage); // Adjust with your actual route
        return null;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.statusCode}')),
          );
        }
        return null;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
      return null;
    }
  }
}
