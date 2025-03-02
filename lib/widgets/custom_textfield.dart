import 'package:flutter/material.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final double? width; // Optional width for custom sizing
  final TextEditingController? controller; // Optional controller parameter
  final TextInputType? keyboardType; // Optional keyboard type

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.validator,
    this.width,
    this.controller,
    this.keyboardType, // Added keyboardType parameter
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: widget.width ?? screenWidth,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false, // Adjust based on isPassword
        style: const TextStyle(fontSize: 16.0),
        validator: widget.validator,
        keyboardType: widget.keyboardType, // Pass the keyboardType to TextFormField
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppTheme.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppTheme.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppTheme.red, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
