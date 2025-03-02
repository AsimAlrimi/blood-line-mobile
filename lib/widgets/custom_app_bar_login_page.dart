import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomAppBarLoginPage extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBarLoginPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      elevation: 0,
      backgroundColor: AppTheme.white,
      title: Text(title, style: AppTheme.h4(),),
    );
  }
    @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

