import 'dart:convert';
import 'package:blood_line_mobile/routes/app_routes.dart';
import 'package:blood_line_mobile/theme/app_theme.dart' show AppTheme;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:shared_preferences/shared_preferences.dart';

late double screenWidth;
late double screenHeight ;
late SharedPreferences sp;

// void main(){
//   runApp(const MyApp());
//
// }

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sp = await SharedPreferences.getInstance();
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

}

clearAll() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}

getData(String name) {
  WidgetsFlutterBinding.ensureInitialized();
  var result = json.decode(sp.getString(name).toString());
  return result;
}

setData(String name, value) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(name, json.encode(value));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(

          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routes: AppRoutes.routes,
          // home: const SplashScreen(),

          initialRoute: getData('AutoLogin')=='true'? AppRoutes.mainScreen : AppRoutes.welcomePage,
          // initialRoute : AppRoutes.mainScreen,

          builder: (context, child) {
            SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
            ));
            return child!;
          },
        );
      }
  }


