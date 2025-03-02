import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomDotStepper extends StatelessWidget {
  final int activeStep;
  final int totalSteps;
  final double dotRadius;
  final double spacing;
  final Color activeColor;   // Color for the active and previous steps
  final Color inactiveColor; // Color for the future steps

  const CustomDotStepper({
    super.key,
    required this.activeStep,
    required this.totalSteps,
    this.dotRadius = 12.0,
    this.spacing = 10.0,
    this.activeColor = AppTheme.red,   // Set default active color to red
    this.inactiveColor = const Color.fromARGB(255, 208, 207, 207), // Set default inactive color to grey
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: dotRadius * 3.5,
          height: dotRadius * 0.3,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: index <= activeStep ? activeColor : inactiveColor, // Color the current and previous steps with activeColor
          ),
        );
      }),
    );
  }
}
