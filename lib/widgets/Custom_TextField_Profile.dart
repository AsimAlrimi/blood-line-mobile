import 'package:flutter/material.dart';

class CustomTextfieldProfile extends StatelessWidget {
  final bool EditModeOn;
  final String title;
  final String text;
  final Function(String) onChanged;

  const CustomTextfieldProfile({
    super.key,
    required this.EditModeOn,
    required this.title,
    required this.text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 10,
            child: Text("$title :"),
          ),
          Flexible(
            flex: 20,
            child: SizedBox(
              child: TextFormField(
                initialValue: text,
                readOnly: !EditModeOn,
                onChanged: onChanged,  // Added this line to handle text changes
                decoration: InputDecoration(
                  border: EditModeOn 
                      ? const UnderlineInputBorder() 
                      : InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}