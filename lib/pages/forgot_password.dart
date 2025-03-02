import 'package:blood_line_mobile/services/login_logic.dart';
import 'package:flutter/material.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/custom_app_bar_login_page.dart';
import 'package:blood_line_mobile/widgets/custom_button.dart';
import 'package:blood_line_mobile/widgets/custom_dot_stepper.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_textfield_code.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  late List<TextEditingController> controllers;

  int activeIndex = 0;
  final int totalIndex = 4; // Updated for four steps

    void _checkEmail() async {

    final String email = _emailController.text;
    
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: AppTheme.red),
        );
      },
    );

    bool? isEmailUsed = await LoginLogic.sendVerificationCode(context, email, false);

     if (!mounted) return;

    Navigator.of(context).pop(); 

      if (isEmailUsed == null) {
        
        
      } else if (isEmailUsed) {
        // Email already in use
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email already in use. Please try another.')),
          );
        }
      } else {
        // Email is valid, proceed to the next step
        setState(() {
          activeIndex++;
        });
      }
  }

    void _verifyEmailCode() async {
  
    // Combine all the controllers' text to get the entered verification code
    final String verificationCode =
        controllers.map((controller) => controller.text).join();
    final String email = _emailController.text; // Ensure this is available

    // Check if the email and code are valid
    if (verificationCode.isEmpty || verificationCode.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email and code.")),
      );
      return;
    }

    // Call the verifyCode method
    bool success = await LoginLogic.verifyCode(context, email, verificationCode);

    if (success) {
      // Proceed to the next step or screen 
      setState(() {
        activeIndex++;
      });
      print("Verification successful!");
    } else {
      // Display a failure message
      print("Verification failed.");
    }
  }

   void _updatPass() async {
    final String email = _emailController.text;
    final String newPassword = _passwordController.text;
    bool success = await LoginLogic.updatePassword(context, email, newPassword);
    if (success){
      setState(() {
        activeIndex++;
      });
    }else{
      print("faild to update the password");
    }
  }

  //late keyword definition for variable without value
  late List<Widget> viewsList;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers list with 5 TextEditingController instances
    controllers = List.generate(5, (_) => TextEditingController());

    viewsList = [
      // "Forgot your password?"
      CustomButton(
        text: "Send",
        onPressed: () {
          if (_emailKey.currentState?.validate() ?? false) {
              _checkEmail();  
          }
        },
      ),
      // "Confirm Email"
      CustomButton(
        text: "Next",
        onPressed: () {
          _verifyEmailCode();
        },
      ),
      // "Create New Password"
      CustomButton(
        text: "Reset Password",
        onPressed: () {
          if (_passwordKey.currentState?.validate() ?? false) {
            _updatPass();
          }
        },
      ),
      // "Password changed!"
      CustomButton(
        text: "Back to Login",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget emailForm() {
      return Form(
        key: _emailKey,
        child: SingleChildScrollView(
          // padding: EdgeInsets.zero,
          child: Column(
            children: [
              Center(child: Image.asset("assets/images/Emails.png", width: 230)),
              const SizedBox(height: 15.0),
              CustomTextField(
                hintText: "Email",
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
            ],
          ),

        ),
      );
    }

    Widget passwordForm() {
      return Form(
        key: _passwordKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Image.asset("assets/images/Reset password-cuate.png", width: 230)),
              const SizedBox(height: 15.0),
              const Text(
                "Your new password must be unique from those previously used.",
                style: AppTheme.instructionGray_18,
                // textAlign: TextAlign.left,
              ),
              const SizedBox(height: 15.0),

              CustomTextField(
                hintText: "New Password",
                isPassword: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'New password is required';
                  }
                  if (value.length < 7) {
                    return 'Password must be at least 7 characters long';
                  }
                  if (!value.contains(RegExp(r'[A-Z]'))) {
                    return 'Must contain an uppercase letter';
                  }
                  if (!value.contains(RegExp(r'[a-z]'))) {
                    return 'Must contain a lowercase letter';
                  }
                  if (!value.contains(RegExp(r'[0-9]'))) {
                    return 'Must contain a number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                hintText: "Confirm New Password",
                isPassword: true,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );
    }
    Widget passwordChangedForm() {
      return Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/Security On-cuate.png",
                  width: 230,
                ),
              ),
              const SizedBox(height: 15.0),
              const Center(
                child: Text(
                  "Your password has been changed successfully.",
                  style: AppTheme.instructionBlack_18,

                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget confirmEmail() {
      int numberOfFields = 5;

      return Form(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/Enter OTP-amico.png",
                  width: 230,
                ),
              ),
              const SizedBox(height: 15.0),
              Center(
                child: Column(
                  children: [
                    Text("Enter Code", style: AppTheme.h2()),
                    const SizedBox(height: 8.0),
                    const Text(
                      "We’ve sent a message with an activation code to your Email.",
                      style: AppTheme.instructionGray_18,
                      // textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        numberOfFields,
                            (index) => Padding(padding: EdgeInsets.symmetric(horizontal: 2), 
                            child: CustomTextFieldCode(
                              controller: controllers[index],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Required";
                                }
                                if (!RegExp(r'^\d$').hasMatch(value)) {
                                  return "Invalid";
                                }
                                return null;
                              },
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }


    return WillPopScope(
      onWillPop: () async {
        if (activeIndex > 0) {
          setState(() {
            activeIndex--;
          });
          return false; // Prevent default back action
        }
        return true; // Allow default back action if at the first step
      },
      child: Scaffold(
        appBar: const CustomAppBarLoginPage(title: ""),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  activeIndex == 0
                      ? "Forgot your password?"
                      : (activeIndex == 1
                      ? "Confirm Email"
                      : (activeIndex == 2
                      ? "Create New Password"
                      : "Password changed!")),
                  style: AppTheme.h2(color: AppTheme.red),
                ),
              ),
              const SizedBox(height: 20.0),
              CustomDotStepper(activeStep: activeIndex, totalSteps: totalIndex),
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  "Step ${activeIndex + 1} of $totalIndex",
                  style: AppTheme.instruction(color: AppTheme.black),
                ),
              ),
              Expanded(
                child: activeIndex == 0
                    ? emailForm()
                    : (activeIndex == 1
                    ? confirmEmail()
                    : (activeIndex == 2
                    ? passwordForm()
                    : passwordChangedForm())),
              ),
              const SizedBox(height: 15.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity, // or a fixed width

                  // width: MediaQuery.of(context).size.width * 0.8,
                  child: viewsList[activeIndex],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

