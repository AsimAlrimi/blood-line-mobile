import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/CustomAppBarRed.dart';
import 'package:flutter/material.dart';


class EventDetails extends StatelessWidget {
  final String eventTitle;
  final String description;
  final String date;
  final String location;
  final String type;

  const EventDetails({
    super.key,
    required this.eventTitle,
    required this.description,
    required this.date,
    required this.location,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            Content: "Event Details",
            SecondLine: "",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Event Title:", style: AppTheme.h2().copyWith(fontWeight: FontWeight.bold)),
                Text(eventTitle, style: AppTheme.instruction()), // Display the event title
                SizedBox(height: 10),
                Text("Description:", style: AppTheme.instructionBlack_18.copyWith(fontWeight: FontWeight.bold)),
                Text(description, style: AppTheme.instruction()), // Display the description
                SizedBox(height: 10),
                Text("Date:", style: AppTheme.instructionBlack_18.copyWith(fontWeight: FontWeight.bold)),
                Text(date, style: AppTheme.instruction()), // Display the date
                SizedBox(height: 10),
                Text("Location:", style: AppTheme.instructionBlack_18.copyWith(fontWeight: FontWeight.bold)),
                Text(location, style: AppTheme.instruction()), // Display the location
                SizedBox(height: 10),
                Text("Type:", style: AppTheme.instructionBlack_18.copyWith(fontWeight: FontWeight.bold)),
                Text(type, style: AppTheme.instruction()), // Display the type
              ],
            ),
          ),
        ],
      ),
    );
  }
}

