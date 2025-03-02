import 'package:blood_line_mobile/pages/home_page.dart';
import 'package:blood_line_mobile/pages/map_page.dart';
import 'package:blood_line_mobile/pages/profile_page.dart';
import 'package:blood_line_mobile/pages/blood_bank_list_page.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
    final int initialIndex;
  const MainScreen({super.key,  required this.initialIndex} );

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Use the initialIndex passed from the constructor
    _selectedIndex = widget.initialIndex;
  } 

  // List of pages
  final List<Widget> _pages = [
    const HomePage(),
    const MapPage(),
     BloodBankListPage(),
    const ProfilePage(),
  ];

  // Handle bottom nav item tap
  @override
  Widget build(BuildContext context) {
    // Bayan Add
    //  no back
    return WillPopScope(
      onWillPop: ()async{
        return await false;
      },
      // ****
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: SalomonBottomBar(
      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.home_outlined, size: 30,),
          title: const Text("Home"),
          selectedColor: AppTheme.red,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.location_on_outlined, size: 30,),
          title: const Text("Map"),
          selectedColor: AppTheme.red,
        ),
        SalomonBottomBarItem(
          icon: const  Icon(Icons.water_drop_rounded, size: 25,),
          title: const Text("Blood Banks"),
          selectedColor: AppTheme.red,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.person_outline, size: 30,),
          title: const Text("Profile"),
          selectedColor: AppTheme.red,
        ),

      ],
        ),
      ),
    );
  }
}
