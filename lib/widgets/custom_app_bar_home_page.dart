import 'package:blood_line_mobile/main.dart';
import 'package:blood_line_mobile/pages/notification_page.dart';
import 'package:blood_line_mobile/services/login_logic.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomAppBarHomePage extends StatelessWidget implements PreferredSizeWidget {
  
  const CustomAppBarHomePage({
    super.key,
  }
  );
  

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor:AppTheme.white,
      title: const Text(""),
      leading:
      Padding(padding:EdgeInsets.only(top: 15),
      child: Transform.rotate(
          angle: -180 * 3.1415926535897932 / 180,
          child: IconButton(
             icon: const Icon(
              size: 32,
              color: Colors.black,
              shadows: [BoxShadow(color:Colors.black, spreadRadius: 2, blurRadius: 1.5)],
              Icons.logout,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Center(child: Text('Are You Sure?')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Do you want to log out?"),
                        const SizedBox(height: 20),
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.check_circle_outlined, color: Colors.black),
                              label: const Text('Yes,Log out ', style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                _handleLogout(context);
                              },
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.cancel_outlined, color: Colors.black),
                              label: const Text('No ', style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      actions: [
        IconButton(
          padding: const EdgeInsets.only(top: 15),
          icon: const Icon(
            size: 35,
            Icons.notifications_outlined,
            color: Colors.black,
            shadows: [BoxShadow(color:Colors.black, spreadRadius: 2, blurRadius: 1.5)],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  NotificationPage(),
              ),
            );
          },
        ),
      ],
    );
  }
      @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

void _handleLogout(BuildContext context) async {
  await LoginLogic.logout(context);
  // Update AutoLogin state in local storage
  await setData('AutoLogin', 'false');
}
