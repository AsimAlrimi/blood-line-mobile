import 'package:blood_line_mobile/routes/app_routes.dart';
import 'package:blood_line_mobile/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // return Form(
    //     child: Column(
    //       children: [
    //         SingleChildScrollView(
    //
    //         ),
    //       ],
    //     )
    // );


    //
      return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          const Positioned(
            top: 0,
            right: 0,
            child: Image(
              image: AssetImage("assets/images/rightUp.png"),
              width: 140, // Control the size of the image
            ),
          ),
          const Positioned(
              left: 0,
              bottom: 40,
              child: Image(
                image: AssetImage("assets/images/leftCenter.png"),
                width: 50, // Control the size of the image
              ),
            ),
          // Logo positioned slightly above the center
          Positioned(
            top: MediaQuery.of(context).size.height * 0.26,  // Adjust this value to move the logo up/down
            left: 0,
            right: 0,
            child: const Center(
              child: Image(
                image: AssetImage("assets/images/Logo.png"),
                width: 230,
              ),
            ),
          ),
          // Column for buttons positioned below the logo

          Positioned(
            top: MediaQuery.of(context).size.height * 0.6,  // Adjust this value to position the buttons correctly
            left: 0,
            right: 0,
            child: Column(

              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                CustomButton(text: "Login", onPressed: (){
                  Navigator.pushNamed(context, AppRoutes.loginPage);
                }),
                const SizedBox(height: 16), // Space between buttons
                CustomButton(text: "Sign Up", onPressed: (){
                  Navigator.pushNamed(context, AppRoutes.signUpPage);
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
