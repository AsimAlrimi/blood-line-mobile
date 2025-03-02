import 'dart:convert';
import 'package:blood_line_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blood_line_mobile/routes/app_routes.dart';

class LoginLogic {
  static final _storage = const FlutterSecureStorage();

  static Future<bool> login(BuildContext context, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/login'),
        headers: <String, String>{ 'Content-Type': 'application/json' },
        body: jsonEncode(<String, String>{ 'email': email, 'password': password }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data.containsKey('user_type') || !data.containsKey('access_token')) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid server response')),
            );
          }
          return false;
        }

        final String userType = data['user_type'];
        final String userName = data['user_name'];
        final String accessToken = data['access_token'];
        await _storage.write(key: 'access_token', value: accessToken);

        switch (userType) {
          case 'Donor':
            Navigator.pushNamed(context, AppRoutes.mainScreen, arguments: {'userType': userType, 'userName': userName},);
            break;
          default:
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Unknown user type')),
              );
            }
            return false;
        }

        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid username or password')),
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

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<void> logout(BuildContext context) async {
    try {
      final accessToken = await getAccessToken();
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        await _storage.delete(key: 'access_token');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully logged out')),
          );
        }
        Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.welcomePage, (route) => false,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logout failed. Please try again.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during logout')),
        );
      }
    }
  }

static Future<bool?> sendVerificationCode(BuildContext context, String email, bool newAccount) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000//send-verification-code'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"email": email, "newAccount": newAccount}),
      );

      if (response.statusCode == 200) {
        // Email is valid and not in use and the code send
        return false;
      } else if (response.statusCode == 409) {
        // Email is already in use
        return true;
        
      } else if (response.statusCode == 404)
      {
          if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User not found")),
          );
        } 
        return null; // Return null in case of an error
      }
      else if (response.statusCode == 500) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to send email")),
          );
        } 
        return null; // Return null in case of an error

      } else {
        // Unexpected error
         if (context.mounted) {
            throw Exception("Unexpected status code: ${response.statusCode}");
         };
      }
    } catch (e) {
      // Handle errors, e.g., show a Snackbar or alert dialog
      debugPrint("Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to check email: $e")),
        );
      }
      return null; // Return null in case of an error
    }
    return null;
  }


  static Future<bool> verifyCode(BuildContext context, String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000//verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "code": code}),
      );

      if (response.statusCode == 200) {
        // Verification successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email verified successfully!")),
        );
        return true;
      } else {
        // Handle invalid code response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid code. Please try again.")),
        );
        return false;
      }
    } catch (e) {
      // Handle unexpected errors (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: ${e.toString()}")),
      );
      return false;
    }
  }

  static Future<bool> updatePassword(BuildContext context, String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/update-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "newPassword": newPassword}),
      );

      if (response.statusCode == 200) {
        // Verification successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated successfully!")),
        );
        return true;
      } else {
        // Handle invalid code response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update password")),
        );
        return false;
      }
    } catch (e) {
      // Handle unexpected errors (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: ${e.toString()}")),
      );
      return false;
    }
  }

  static Future<String?> getDonorName(BuildContext context) async {
  try {
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        await setData('AutoLogin', 'flase');
        Navigator.pushReplacementNamed(context, AppRoutes.welcomePage);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please log in again.')),
          );
        }
        return null;
      }
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/get_donor_name'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken' 
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final donorName = data['donor_name'];
      return donorName;
    }else if (response.statusCode == 401){
      await setData('AutoLogin', 'flase');
      Navigator.pushReplacementNamed(context, AppRoutes.welcomePage);
      return null;
    }
    else if (response.statusCode == 403) {
      if (context.mounted) {
      // Unauthorized access
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unauthorized access. Please log in.")),
      );
      }
      return null;
    } else {
      if (context.mounted) {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch donor name.")),
      );
      }
      return null;
    }
  } catch (e) {
    if (context.mounted) {
    // Handle unexpected errors (e.g., network issues)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An error occurred: ${e.toString()}")),
    );
    }
    return null;
  }
}


}
