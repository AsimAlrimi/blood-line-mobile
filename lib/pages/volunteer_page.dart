import 'package:blood_line_mobile/services/volunteering_services.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/CustomAppBarRed.dart';
import 'package:blood_line_mobile/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class VolunteerPage extends StatefulWidget {
  const VolunteerPage({super.key});

  @override
  State<VolunteerPage> createState() => _VolunteerPageState();
}

class _VolunteerPageState extends State<VolunteerPage> {
  bool isRegistered = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVolunteeringStatus();
  }

  Future<void> _fetchVolunteeringStatus() async {
    final status = await VolunteeringService.getVolunteeringStatus(context);
    setState(() {
      isRegistered = status;
      isLoading = false;
    });
  }

  Future<void> handleVolunteeringToggle() async {
    setState(() {
      isLoading = true;
    });

    try {
      final message = await VolunteeringService.toggleVolunteering(context);
      
      if (message != null) {
        setState(() {
          isRegistered = !isRegistered;
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            viewType: 'oneLine',
            Content: 'Volunteering',
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/Team work-cuate.png",
                    width: 230,
                  ),
                  Text(
                    "Encourage your friends and family to become regular blood donors. Volunteer with the blood service to reach out to members of your community, provide care to donors, and help manage blood donation sessions/drives. Find out your blood type and register as a blood donor. Participate in local World Blood Donor Day events.",
                    style: AppTheme.instructionBlack_18,
                  ),
                  const SizedBox(height: 20),
                  if (isLoading)
                    const CircularProgressIndicator()
                  else
                    CustomButton(
                      size: Size(170, 50),
                      text: isRegistered ? "Team Member" : "Join Team",
                      backgroundColor: isRegistered ? AppTheme.grey : AppTheme.red,
                      onPressed: handleVolunteeringToggle,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}