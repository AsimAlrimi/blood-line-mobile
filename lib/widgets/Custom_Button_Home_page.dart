import 'package:blood_line_mobile/main.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomButtonHomePage extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final String image;

  const CustomButtonHomePage({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor = AppTheme.white,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap:onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          width: screenWidth*0.45 /*180*/,
          height: 230,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color:const Color.fromARGB(255, 214, 213, 213), spreadRadius: 1, blurRadius: 1.5)],
              borderRadius: BorderRadius.circular(10), color: AppTheme.white
            ),
          child:Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text, style: AppTheme.instructionBlack_18.copyWith(fontWeight: FontWeight.bold)),
              Image.asset(
                image,
                width: 146,
                height: 140,
              ),

              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.arrow_forward_ios, color: Colors.black, size: 22,),
                ],
              )
            ],
          )
       ),
    );
  }
}
