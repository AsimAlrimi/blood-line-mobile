
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class  CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final Size size;
  final EdgeInsets padding;


  const  CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppTheme.red,
    this.textColor = AppTheme.white,
    this.fontSize = 20.0,
    this.size = const Size(185.0, 50.0),
    this.padding = const EdgeInsets.all(10.0),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: size,
        padding: padding,
        backgroundColor: backgroundColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
        ),
      ),
    );
  }
}
