import 'package:flutter/material.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/custom_button.dart';
import 'package:blood_line_mobile/pages/book_appointment_page.dart';

class CoustonMapCard extends StatelessWidget {
  final Map<String, dynamic> bloodBank; // Accept dynamic values

  const CoustonMapCard({super.key, required this.bloodBank});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              bloodBank["name"]?.toString() ?? "Unknown Blood Bank",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Operation Hours: ${bloodBank["start_hour"]?.toString() ?? "N/A"} - ${bloodBank['close_hour']?.toString() ?? "N/A"}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: "Book",
              size: const Size(90, 40),
              fontSize: 14,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookAppointmentPage(
                      bloodBank: bloodBank,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
