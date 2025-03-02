import 'dart:convert';
import 'package:blood_line_mobile/main.dart';
import 'package:blood_line_mobile/pages/main_screen.dart';
import 'package:blood_line_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookAppointmentService {
  static final _storage = const FlutterSecureStorage();
  static const String _baseUrl = 'http://10.0.2.2:5000';

  /// Book an appointment
  static Future<bool> bookAppointment({
    required BuildContext context,
    required int bloodBankId,
    required String appointmentDate,
    required String appointmentTime,
    required String donationType,
    List<String>? diseases,
  }) async {
    try {
      // Retrieve access token from secure storage
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        if (context.mounted) {
          await setData('AutoLogin', 'false');
          Navigator.pushReplacementNamed(context, AppRoutes.welcomePage); 
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please log in again.')),
          );
        }
        return false;
      }

      // Prepare the request payload
      final Map<String, dynamic> payload = {
        'blood_bank_id': bloodBankId,
        'appointment_date': appointmentDate,
        'appointment_time': appointmentTime,
        'donation_type': donationType,
        'diseases': diseases ?? [], // Provide an empty list if no diseases
      };

      // Make POST request
      final response = await http.post(
        Uri.parse('$_baseUrl/book_appointment'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Attach JWT token
        },
        body: jsonEncode(payload),
      );

      // Handle response
      if (response.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment booked successfully.')),
          );
        }
        return true;
      }else if (response.statusCode == 401) {
        await setData('AutoLogin', 'false');
        Navigator.pushReplacementNamed(context, AppRoutes.welcomePage); // Adjust with your actual route
        return false;
      }
       else if (response.statusCode == 400) {
        final errorResponse = jsonDecode(response.body);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to book appointment: ${errorResponse['error']}')),
          );
        }
        return false;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.statusCode}')),
          );
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
      return false;
    }
  }

  static Future<Map<String, dynamic>?> checkPendingAppointment(BuildContext context) async {
    try {
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        setData('AutoLogin', 'flase');
        Navigator.pushReplacementNamed(context, AppRoutes.welcomePage);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please log in again.')),
          );
        }
        return null;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/check_pending_appointment'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 200) {
        return null;
      } else if (response.statusCode == 401){
        setData('AutoLogin', 'flase');
        Navigator.pushReplacementNamed(context, AppRoutes.welcomePage);
        return null;
      }
      else {
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

  static Future<void> cancelAppointment(BuildContext context) async {
    try{
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please log in again.')),
          );
        }
        return null;
      }

      final responce  = await http.delete(
        Uri.parse('$_baseUrl/delete_appointment'),
        headers: <String, String>{
          'Authorization' : 'Bearer $accessToken'
        }
      );

      if (responce.statusCode == 200){
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Appointment canceled successfully")),
          );
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(initialIndex: 1),
          ),
        );
      }else if (responce.statusCode == 404){
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No pending appointment found to delete")),
          );
        }
      }else if (responce.statusCode == 500){
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred while deleting the appointment")),
          );
        }
      }else{
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Errro")),
          );
        }
      }

    }catch(e){
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
      return;
    }

  }


}


