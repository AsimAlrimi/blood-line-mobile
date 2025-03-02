import 'dart:convert';
import 'package:blood_line_mobile/main.dart';
import 'package:blood_line_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfileService {
  static final _storage = const FlutterSecureStorage();
  static const String _baseUrl = 'http://10.0.2.2:5000';

  /// Fetch User Profile
  static Future<Map<String, dynamic>?> fetchUserProfile(BuildContext context) async {
    try {
      // Retrieve access token from secure storage
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        await setData('AutoLogin', 'false');
        Navigator.pushReplacementNamed(context, AppRoutes.welcomePage);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please log in again.')),
          );
        }
        return null;
      }

      // Make GET request
      final response = await http.get(
        Uri.parse('$_baseUrl/user/profile'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Attach JWT token
        },
      );

      // Handle response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['profile'] as Map<String, dynamic>;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch profile: ${response.statusCode}')),
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
  /// Update User Profile
  static Future<bool> updateUserProfile(
      BuildContext context, Map<String, dynamic> updatedData) async {
    try {
      // Retrieve access token from secure storage
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please log in again.')),
          );
        }
        return false;
      }

      // Make PUT request
      final response = await http.put(
        Uri.parse('$_baseUrl/update_donor_profile'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Attach JWT token
        },
        body: jsonEncode(updatedData),
      );

      // Handle response
      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully.')),
          );
        }
        return true;
      }else if (response.statusCode == 401) {
        await setData('AutoLogin', 'false');
        Navigator.pushReplacementNamed(context, AppRoutes.welcomePage); // Adjust with your actual route
        return false;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: ${response.statusCode}')),
          );
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      return false;
    }
  }

}
