import 'package:flutter/material.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;



  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions, required String viewType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.red,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: AppBar(
        elevation: 0,
        title: const Text(""),
        leading: leading ?? _buildDefaultLeading(context), // Use custom back arrow if leading is null
        actions: actions,
        backgroundColor: AppTheme.red,
      ),
    );
  }
  // leading:
  // Container(),
  // shape: const RoundedRectangleBorder(
  // borderRadius:BorderRadius.vertical(
  // bottom: Radius.circular(25),
  // ),),

  Widget _buildDefaultLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        StatefulBuilder(builder: (context1, setState1){ return Container();},);
        Navigator.of(context).pop();
      },
      // child: Container(
      //   width: 16, // Reduced the width of the container
      //   height: 16, // Reduced the height of the container
      //   decoration: BoxDecoration(
      //     color: const Color(0xFFFFFFFF), // White container color
      //     // borderRadius: BorderRadius.circular(2), // Adjusted to match container size
      //   ),

        child: const Icon(
          Icons.arrow_back,
          color: Color(0xFF000000), // Black arrow color
          size: 30, // Smaller icon size
        ),
      );
    // )
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 24);
}
