import 'dart:convert';
import 'package:blood_line_mobile/services/login_logic.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateAccount {
  static Future<bool> register(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String password,
    String idNumber,
    String weight,
    String bloodType,
    String dateOfBirth, // Parameter for date of birth (barth)
    String gender, // Parameter for gender
  ) async {
    final String username = '$firstName $lastName'; // Combine first and last name for username

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/create_donor'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'id_number': idNumber,
          'weight': weight,
          'blood_group': bloodType,
          'barth': dateOfBirth, // Include date_of_birth (barth) in the request body
          'gender': gender, // Include gender in the request body
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );

        // Await the login to ensure it's completed
        bool loginSuccess = await LoginLogic.login(context, email, password);
        if (loginSuccess) {
          return true;
        } else {
          // Handle login failure if needed
          return false;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      return false;
    }
  }
}
