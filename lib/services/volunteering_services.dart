import 'dart:convert';
import 'package:blood_line_mobile/main.dart';
import 'package:blood_line_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VolunteeringService {
  static final _storage = const FlutterSecureStorage();
  static const String _baseUrl = 'http://10.0.2.2:5000';

  /// Get current volunteering status
  static Future<bool> getVolunteeringStatus(BuildContext context) async {
    try {
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        await setData('AutoLogin', 'false');
        Navigator.pushReplacementNamed(context, AppRoutes.welcomePage);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please log in again.')),
          );
        }
        return false;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/volunteering_status'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['is_volunteer'] as bool;
      }else if (response.statusCode == 401) {
        await setData('AutoLogin', 'false');
        Navigator.pushReplacementNamed(context, AppRoutes.welcomePage); // Adjust with your actual route
        return false;
      }  else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch volunteering status: ${response.statusCode}')),
          );
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch volunteering status')),
        );
      }
      return false;
    }
  }

  /// Toggle volunteering status
  static Future<String?> toggleVolunteering(BuildContext context) async {
    try {
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please log in again.')),
          );
        }
        return null;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/toggle_volunteering'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['message'] as String;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to toggle volunteering: ${response.statusCode}')),
          );
        }
        return null;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      return null;
    }
  }
}