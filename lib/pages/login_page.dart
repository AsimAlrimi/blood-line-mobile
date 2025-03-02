import 'package:blood_line_mobile/main.dart';
import 'package:blood_line_mobile/pages/forgot_password.dart';
import 'package:blood_line_mobile/services/login_logic.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/custom_app_bar_login_page.dart';
import 'package:blood_line_mobile/widgets/custom_button.dart';
import 'package:blood_line_mobile/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String password = _passwordController.text;

      bool success = await LoginLogic.login(context, email, password);

      if (!success) {
        print("Login failed");
      } else {
        print("Login successful");
      }
    } else {
      print("Form is invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarLoginPage(title: "",),
      body: SingleChildScrollView(
        // child: WillPopScope(
        //   onWillPop: ()async=> await false,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,  // Wrap content in a Form widget
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      "assets/images/Blooddonation.png",
                      width: 250,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "Log in to Blood Line",
                    style: AppTheme.h1(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Email",
                    style: AppTheme.instruction(color: AppTheme.black),
                  ),
                  const SizedBox(height: 7),
                  // Email Text Field with Controller and Validator
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Ex: Maguire@gmail.com",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Password",
                    style: AppTheme.instruction(color: AppTheme.black),
                  ),
                  const SizedBox(height: 7),
                  // Password Text Field with Controller and Validator
                  CustomTextField(
                    controller: _passwordController,
                    hintText: "Enter Password",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),


                  // Bayan Add Text forgot password
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style:AppTheme.instructionRed_18,
                      ),
                    ),
                  ),
                  // ****


                  const SizedBox(height: 30),
                  // Login Button with Form Validation
                  CustomButton(
                    text: "Login",
                    onPressed: () {
                      // Bayan Add
                      setData('AutoLogin', 'true');  //todo to add after valid credentials.
                      _login();
                        // ****
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );*/
                      },
                    size: const Size(double.maxFinite, 50),
                  ),
                ],
              ),
            ),
          ),
        ),
      // ),
    );
  }
}
