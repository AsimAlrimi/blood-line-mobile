import 'package:flutter/material.dart';

class LogoPage extends StatelessWidget {
  const LogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right:0,
              child: Image(
                image: AssetImage("assets/images/rightUp.png"),
                width: 140, // Control the size of the image
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Image(
                image: AssetImage("assets/images/centerRight.png"),
                width: 80, // Control the size of the image
              ),
            ),
            Positioned(
              left: 0,
              bottom: 40,
              child: Image(
                image: AssetImage("assets/images/leftCenter.png"),
                width: 50, // Control the size of the image
              ),
            ),
            // Center the logo image
            Center(
              child: Image(
                image: AssetImage("assets/images/Logo.png"),
                width: 240, // Control the size of the logo
              ),
            ),
          ],
        ),
      ),
    );
  }
}