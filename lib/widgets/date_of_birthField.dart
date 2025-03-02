import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class DateOfBirthField extends StatefulWidget {
  const DateOfBirthField({super.key});

  @override
  _DateOfBirthFieldState createState() => _DateOfBirthFieldState();
}

class _DateOfBirthFieldState extends State<DateOfBirthField> {
  final TextEditingController _dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900), // Minimum date
          lastDate: DateTime.now(), // Maximum date is today
        );
        if (pickedDate != null) {
          setState(() {
            _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _dobController,
          decoration: InputDecoration(
            hintText: "Date of Birth",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppTheme.red, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
