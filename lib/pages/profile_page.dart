import 'package:blood_line_mobile/main.dart';
import 'package:blood_line_mobile/services/user_profile_services.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/CustomAppBarRed.dart';
import 'package:blood_line_mobile/widgets/Custom_TextField_Profile.dart';
import 'package:blood_line_mobile/widgets/custom_button.dart';
import 'package:blood_line_mobile/widgets/users_change_pass.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool EditModeOn = false;
  Map<String, dynamic>? userProfile;
  Map<String, dynamic> changedFields = {};  // Track changed fields
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final profile = await UserProfileService.fetchUserProfile(context);
      setState(() {
        userProfile = profile;
        changedFields.clear();  // Clear changed fields when fetching new data
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (EditModeOn && changedFields.isNotEmpty) {
      // Only send changed fields to the server
      bool success = await UserProfileService.updateUserProfile(context, changedFields);

      if (success) {
        await _fetchUserProfile();
        setState(() {
          EditModeOn = false;
          changedFields.clear();
        });
      }
    }
  }

  void _handleFieldChange(String field, String value) {
    if (userProfile?[field] != value) {
      setState(() {
        userProfile?[field] = value;
        changedFields[field] = value;
      });
    } else {
      // If the value is the same as original, remove it from changed fields
      setState(() {
        changedFields.remove(field);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(screenWidth, 250),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CustomAppBar(
              Content: "",
              viewType: "image",
              NavBar: true,
            ),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userProfile == null) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(screenWidth, 250),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CustomAppBar(
              Content: "",
              viewType: "image",
              NavBar: true,
            ),
          ),
        ),
        body: Center(
          child: Text(
            'Failed to load user profile',
            style: AppTheme.instructionBlack_18,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenWidth, 250),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CustomAppBar(
            Content: "",
            viewType: "image",
            NavBar: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            EditModeOn
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        size: Size(170, 50),
                        text: "Save",
                        onPressed: _saveProfile,
                      ),
                      CustomButton(
                        size: Size(170, 50),
                        backgroundColor: Colors.transparent,
                        text: "Cancel",
                        onPressed: () {
                          setState(() {
                            EditModeOn = false;
                            changedFields.clear();  // Clear changed fields on cancel
                            _fetchUserProfile();    // Reload original data
                          });
                        },
                      ),
                    ],
                  )
                : CustomButton(
                    size: Size(170, 50),
                    text: "Edit",
                    onPressed: () {
                      setState(() {
                        EditModeOn = true;
                      });
                    },
                  ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(5),
              width: screenWidth,
              height: 30,
              color: AppTheme.lightgrey,
              child: Text(
                "Content",
                style: AppTheme.instructionBlack_18
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            CustomTextfieldProfile(
              EditModeOn: EditModeOn,
              title: "User Name",
              text: userProfile?['username'] ?? 'N/A',
              onChanged: (value) => _handleFieldChange('username', value),
            ),
            CustomTextfieldProfile(
              EditModeOn: EditModeOn,
              title: "Email",
              text: userProfile?['email'] ?? 'N/A',
              onChanged: (value) => _handleFieldChange('email', value),
            ),
            CustomTextfieldProfile(
              EditModeOn: EditModeOn,
              title: "Phone Number",
              text: userProfile?['phone_number'] ?? 'N/A',
              onChanged: (value) => _handleFieldChange('phone_number', value),
            ),
            CustomTextfieldProfile(
              EditModeOn: false,
              title: "Blood Type",
              text: userProfile?['blood_group'] ?? 'N/A',
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return UsersChangePass();
                    },
                  );
                },
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    color: AppTheme.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}