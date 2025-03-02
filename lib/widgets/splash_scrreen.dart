import 'package:blood_line_mobile/pages/logo_page.dart';
import 'package:blood_line_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds, then navigate to the LoginPage
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.welcomePage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const LogoPage();
  }
}
