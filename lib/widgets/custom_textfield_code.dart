import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldCode extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final bool isPassword;

  const CustomTextFieldCode({
    super.key,
    this.controller,
    this.validator,
    this.hintText,
    this.isPassword = false,
  });

  @override
  _CustomTextFieldCodeState createState() => _CustomTextFieldCodeState();
}

class _CustomTextFieldCodeState extends State<CustomTextFieldCode> {
  final FocusNode _focusNode = FocusNode();
  Color borderColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        borderColor = _focusNode.hasFocus ? AppTheme.red : Colors.grey;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 65,
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        focusNode: _focusNode,
        obscureText: widget.isPassword, // If isPassword is true, obscure the text
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          hintText: widget.hintText, // Set the hintText if provided
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppTheme.red),
          ),
        ),
        onFieldSubmitted: (value) {
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
