import 'dart:convert';
import 'package:blood_line_mobile/main.dart';
import 'package:blood_line_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FAQService {
  static final _storage = const FlutterSecureStorage();
  static const String _baseUrl = 'http://10.0.2.2:5000';

  /// Fetch FAQs
  static Future<List<Map<String, dynamic>>?> fetchFAQs(BuildContext context) async {
    try {
      // Retrieve access token from secure storage
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        await setData('AutoLogin', 'false');
        Navigator.pushReplacementNamed(context, AppRoutes.welcomePage); // Adjust with your actual route
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please log in again.')),
          );
        }
        return null;
      }

      // Make GET request
      final response = await http.get(
        Uri.parse('$_baseUrl/donor/faqs'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Attach JWT token
        },
      );

      // Handle response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final faqs = data['faqs'] as List<dynamic>;
        return faqs.map((e) => Map<String, dynamic>.from(e)).toList();
      }else if (response.statusCode == 401) {
        await setData('AutoLogin', 'false');
        Navigator.pushReplacementNamed(context, AppRoutes.welcomePage); // Adjust with your actual route
        return null;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch FAQs: ${response.statusCode}')),
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
