import 'package:blood_line_mobile/routes/app_routes.dart';
import 'package:blood_line_mobile/services/create_account.dart';
import 'package:blood_line_mobile/services/login_logic.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/blood_type_drop_down.dart';
import 'package:blood_line_mobile/widgets/custom_app_bar_login_page.dart';
import 'package:blood_line_mobile/widgets/custom_button.dart';
import 'package:blood_line_mobile/widgets/custom_dot_stepper.dart';
import 'package:blood_line_mobile/widgets/custom_textfield.dart';
import 'package:blood_line_mobile/widgets/custom_textfield_code.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordfianlKey = GlobalKey<FormState>();
  
  int activeIndex = 0;
  int totalIndex = 4;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
       

  late List<TextEditingController> controllers;

    @override
  void initState() {
    super.initState();
    // Initialize the controllers list with 5 TextEditingController instances
    controllers = List.generate(5, (_) => TextEditingController());
  }

    @override
  void dispose() {
    // Dispose all controllers to avoid memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idNumberController.dispose();
    _weightController.dispose();
    _bloodTypeController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
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
    
    bool? isEmailUsed = await LoginLogic.sendVerificationCode(context, email, true);

     if (!mounted) return;
    Navigator.of(context).pop(); 
      if (isEmailUsed == null) {
        // Handle server error or no response
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An error occurred. Please try again.')),
          );
        }
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


  void _createAccount() async {
    
      final String firstName = _firstNameController.text;
      final String lastName = _lastNameController.text;
      final String idNumber = _idNumberController.text;
      final String weight = _weightController.text;
      final String bloodType = _bloodTypeController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String dateOfBirth = _dateOfBirthController.text;
      final String gender = _genderController.text;

      bool success = await CreateAccount.register(context,
       firstName,
       lastName,
       email,
       password,
       idNumber,
       weight,
       bloodType,
       dateOfBirth,
       gender,
       );
      
      if (!success){
        print("Sign Up failed");
      }
   
  }

@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false, // Disable default pop behavior
    onPopInvoked: (didPop) async {
      if (activeIndex > 0) {
        setState(() {
          activeIndex--;
        });
      } else {
        Future.delayed(const Duration(milliseconds: 0), () {
          Navigator.popAndPushNamed(context, AppRoutes.welcomePage);
        });
      }
    },
    child: Scaffold(
      appBar: const CustomAppBarLoginPage(title: ""),
      body: bodyBuilder(),
    ),
  );
}



  Widget bodyBuilder(){
    switch (activeIndex) {
      case 0:
        return basicDetails();
      case 1:
        return email();
      case 2:
        return confimEmail();
      case 3:
        return passwordfianl();
      default:
        return basicDetails();
    }
  }

  Widget basicDetails  (){
    return Form(
      key: basicFormKey,
      child: ListView(
        padding:  const EdgeInsets.all(12.0),
        children:  [
          const SizedBox(height: 10.0,),
          Center(
            child: CustomDotStepper(activeStep: activeIndex, totalSteps: totalIndex)
          ),
          const SizedBox(height: 20.0,),
          Center(child: Text("Step ${activeIndex + 1} of $totalIndex" ,style: AppTheme.instruction(color: AppTheme.black),)),
          const SizedBox(height: 15.0,),

          Center(
            child: Image.asset(
              "assets/images/Signup.png",
               width: 230,
              ),
          ),
          const SizedBox(height: 10.0,),

          Row(
            children: [
            Expanded(
              child: CustomTextField(hintText: "First Name", controller: _firstNameController, 
              validator: (value){
                if (value == null || value.isEmpty){
                return 'First Name is required';
              }
              return null;
              },)
              ),
            const SizedBox(width: 20), // Add some spacing between the text fields if needed
            Expanded(
              child: CustomTextField(hintText: "Last Name", controller: _lastNameController,
              validator: (value){
                if (value == null || value.isEmpty){
                return 'First Name is required';               
                }
                return null;
              },
              ),
              ),
            ],
          ),
          const SizedBox(height: 10.0,),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: "ID",
                  controller: _idNumberController,
                  validator: (value){
                    if (value == null || value.isEmpty){
                      return 'ID is required';
                    }
                    return null;
                  },
                  ),
              ),
              const SizedBox(width: 20), // Add some spacing between the text fields if needed
              Expanded(
                child: CustomGenderDropdown(
                  hintText: "Gender",
                  controller: _genderController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Gender is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _genderController.text = value ?? '';
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0,),
          Expanded(
            child: BloodTypeDropdown(
              validator: (value){
                if (value == null || value.isEmpty){
                  return 'Blood Type is required';
                }
                return null;
              },
              hintText: "Blood Type",
               onChanged: (value) { setState(() {
              _bloodTypeController.text = value!; 
              });}
            ),
          ),         
          const SizedBox(height: 10.0,),
          CustomDatePicker(
            hintText: "Date of Birth",
            controller: _dateOfBirthController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Date of Birth is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 10.0,),

          CustomTextField(
            hintText: "Weight",
            controller: _weightController,
            keyboardType: TextInputType.number, // Use numeric keyboard
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Weight is required';
              }
              final num? parsedValue = num.tryParse(value);
              if (parsedValue == null) {
                return 'Enter a valid number';
              }
              return null;
            },
          ),

          const SizedBox(height: 20.0,),
          CustomButton(text: "Next", onPressed: (){
          if (basicFormKey.currentState?.validate() ?? false) {
          // If the form is valid, move to the next step
          setState(() {
            activeIndex++;
          });
          } 
          })
        ],
      ),
    );
  }

  Widget email() {
  return Form(
    key: emailKey, // Attach the form key for validation
    child: ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        const SizedBox(height: 10.0),
        Center(
          child: CustomDotStepper(activeStep: activeIndex, totalSteps: totalIndex),
        ),
        const SizedBox(height: 20.0),
        Center(
          child: Text(
            "Step ${activeIndex + 1} of $totalIndex",
            style: AppTheme.instruction(color: AppTheme.black),
          ),
        ),
        const SizedBox(height: 30.0),
        Center(
          child: Image.asset(
            "assets/images/Emails.png",
            width: 230,
          ),
        ),
        const SizedBox(height: 15.0),
        
        // Updated CustomTextField with controller and validator
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
        
        const SizedBox(height: 20.0),

        CustomButton(
          text: "Next",
          onPressed: () {
            if (emailKey.currentState?.validate() ?? false) {
              // If the form is valid, move to the next step
                _checkEmail();
            } else {
            
            }
          },
        ),
        ],
      ),
    );
  }


Widget confimEmail() {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  return ListView(
    padding: const EdgeInsets.all(12.0),
    children: [
      const SizedBox(height: 10.0),
      Center(
          child: CustomDotStepper(
              activeStep: activeIndex, totalSteps: totalIndex)),
      const SizedBox(height: 20.0),
      Center(
          child: Text(
        "Step ${activeIndex + 1} of $totalIndex",
        style: AppTheme.instruction(color: AppTheme.black),
      )),
      const SizedBox(height: 30.0),
      Text(
        "Enter Code",
        style: AppTheme.h2(),
      ),
      const SizedBox(height: 8.0),
      Text(
        "We’ve sent a message with an activation code to your Email masf@gmail.com",
        style: AppTheme.instruction(),
      ),
      const SizedBox(height: 20.0),

      // Form to handle validation
      Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            controllers.length,
            (index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
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
              ),
            ),
          ),
        ),
      ),

      const SizedBox(height: 20.0),
      CustomButton(
          text: "Next",
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              // Combine all controllers' values into a single string
              String verificationCode =
                  controllers.map((controller) => controller.text).join();
              debugPrint("Entered Code: $verificationCode");

              // Proceed to the next step
              _verifyEmailCode();

              // Add your verification logic here, e.g., calling an API
            } else {
              // Handle invalid inputs
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please fill all fields correctly.")),
              );
            }
          })
    ],
  );
}



  Widget passwordfianl() {
  return Form(
    key: passwordfianlKey, // Attach the form key for validation
    child: ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        const SizedBox(height: 10.0),
        Center(
          child: CustomDotStepper(activeStep: activeIndex, totalSteps: totalIndex),
        ),
        const SizedBox(height: 20.0),
        Center(
          child: Text(
            "Step ${activeIndex + 1} of $totalIndex",
            style: AppTheme.instruction(color: AppTheme.black),
          ),
        ),
        const SizedBox(height: 20.0),

        Center(
          child: Image.asset(
            "assets/images/password.png",
            width: 250,
          ),
        ),
        const SizedBox(height: 20.0),

        // Updated CustomTextField for Password with controller and validation
        CustomTextField(
          hintText: "Password",
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

        // Confirm Password Field with validation
        CustomTextField(
          hintText: "Confirm Password",
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            } else if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 20.0),

        CustomButton(
          text: "Confirm",
          onPressed: () {
            if (passwordfianlKey.currentState?.validate() ?? false) {
             
              _createAccount();
            } else {
             
            }
          },
        ),
      ],
    ),
  );
}


   Future<bool> someFunction() async {
    if (activeIndex != 0) {
      setState(() {
        activeIndex--;
      });
      return false;
    }
    return true;
    }
    
}

class CustomDatePicker extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomDatePicker({
    Key? key,
    required this.hintText,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  // Calculate minimum allowed date (16 years ago)
  DateTime get _minimumAgeDate {
    final now = DateTime.now();
    return DateTime(now.year - 16, now.month, now.day);
  }

  // Calculate maximum allowed date (90 years ago)
  DateTime get _maximumAgeDate {
    final now = DateTime.now();
    return DateTime(now.year - 90, now.month, now.day);
  }

  // Check if the age is within valid range (16-90 years)
  bool _isAgeValid(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final age = difference.inDays / 365.25; // Using 365.25 to account for leap years
    return age >= 16 && age <= 90;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(DateTime.now().year - 16),
          firstDate: _maximumAgeDate,  // 90 years ago
          lastDate: _minimumAgeDate,   // 16 years ago
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppTheme.red,
                  onPrimary: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          // Format date as YYYY-MM-DD
          String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          setState(() {
            widget.controller.text = formattedDate;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Date of Birth is required';
        }

        // Parse the date and validate age
        try {
          final date = DateTime.parse(value);
          if (!_isAgeValid(date)) {
            return 'Age must be between 16 and 90 years';
          }
        } catch (e) {
          return 'Invalid date format';
        }

        // Call the custom validator if provided
        if (widget.validator != null) {
          return widget.validator!(value);
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: "${widget.hintText} (YYYY-MM-DD)",
        suffixIcon: const Icon(Icons.calendar_today, color: AppTheme.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppTheme.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppTheme.red, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}


// Custom Gender Dropdown Widget
class CustomGenderDropdown extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String?) onChanged;

  const CustomGenderDropdown({
    Key? key,
    required this.hintText,
    required this.controller,
    this.validator,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      dropdownColor: AppTheme.white,
      value: controller.text.isEmpty ? null : controller.text,
      items: ['Male', 'Female']
          .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          })
          .toList(),
      onChanged: (String? newValue) {
        controller.text = newValue ?? '';
        onChanged(newValue);
      },
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppTheme.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppTheme.red, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}