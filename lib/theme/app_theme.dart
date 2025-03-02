import 'package:flutter/material.dart';

class AppTheme{

    static const Color red = Color(0xFFBC1F34);
    static const Color black = Color.fromRGBO(0, 0, 0, 1);
    static const Color white = Colors.white;
    static const Color lightwhite = Color.fromARGB(209, 255, 255, 255);
    static const Color grey = Color(0xFF757575);
    static const Color lightgrey = Color(0xFFF6F6F6);


  // h1 TextStyle with an optional color parameter
  static TextStyle h1({Color color = Colors.black}) {
    return TextStyle(
      color: color,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
  }


  // h2 TextStyle with an optional color parameter
  static TextStyle h2({Color color = Colors.black}) {
    return TextStyle(
      color: color,
      fontSize: 28,
      fontWeight: FontWeight.w600,
    );
  }

  // h3 TextStyle with an optional color parameter
  static TextStyle h3({Color color = Colors.black}) {
    return TextStyle(
      color: color,
      fontSize: 26,
      fontWeight: FontWeight.w500,
    );
  }

  // h4 TextStyle with an optional color parameter
  static TextStyle h4({Color color = Colors.black}) {
    return TextStyle(
      color: color,
      fontSize: 24,
      fontWeight: FontWeight.normal,
    );
  }

    static TextStyle instruction_24({Color color = Colors.grey}) {
      return TextStyle(
        color: color,
        fontSize: 24,
        fontWeight: FontWeight.normal,
      );
    }
  // Instruction TextStyle with an optional color parameter
  static TextStyle instruction({Color color = Colors.grey}) {
    return TextStyle(
      color: color,
      fontSize: 20,
      fontWeight: FontWeight.normal,
    );
  }
    static TextStyle instruction_14({Color color = Colors.grey}) {
      return TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );
    }
    static const TextStyle instructionRed = TextStyle(
      color: red,
      fontSize: 20, 
      fontWeight: FontWeight.normal, 
    );


    static const TextStyle instructionRed_18 = TextStyle(
      color: red,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    );
    static const TextStyle instructionBlack_18 = TextStyle(
      color:black,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    );

    static const TextStyle instructionGray_18 = TextStyle(
      color:grey,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    );
    static ThemeData get app_bar => ThemeData(

    );
    static ThemeData lightTheme = ThemeData(
    
    scaffoldBackgroundColor: Colors.white,

    textSelectionTheme: TextSelectionThemeData(
      selectionColor: const Color.fromARGB(255, 187, 187, 187).withOpacity(0.5), // Highlight color when text is selected
      cursorColor: Colors.black,
      selectionHandleColor: const Color.fromARGB(255, 187, 187, 187).withOpacity(0.5), // Color of the selection handles
    ),

  );

}