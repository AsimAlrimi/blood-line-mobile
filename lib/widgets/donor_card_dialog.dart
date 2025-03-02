import 'package:flutter/material.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';

class DonorCardDialog extends StatefulWidget {
  final Function(List<String>) onComplete;

  const DonorCardDialog({Key? key, required this.onComplete}) : super(key: key);

  @override
  _DonorCardDialogState createState() => _DonorCardDialogState();
}

class _DonorCardDialogState extends State<DonorCardDialog> {
  final List<String> conditions = [
    "Diabetes",
    "Allergies",
    "Kidney disease",
    "Liver inflammation",
    "Pregnancy (for females only)",
    "Tuberculosis (TB)",
    "Skin diseases",
    "Chronic kidney disease",
    "Malignant tumors (cancer)",
    "Blood diseases",
    "Heart or vascular diseases",
    "Epilepsy or fainting spells",
    "Heart or arterial infections",
    "Syphilis (a sexually transmitted infection)",
    "Asthma or respiratory diseases",
    "Malaria",
    "Chronic diseases",
    "Chronic inflammatory diseases",
    "Mental illnesses or psychiatric disorders",
    "Bleeding disorders or anemia",
  ];

  late List<bool> selectedConditions; // Keeps track of selected conditions

  @override
  void initState() {
    super.initState();
    selectedConditions = List<bool>.filled(conditions.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.white,
      title: const Text(
        "Donor Card",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(child: const Text("Do you suffer from any of the following conditions?")),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: conditions.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(conditions[index]),
                    value: selectedConditions[index],
                    onChanged: (bool? value) {
                      setState(() {
                        selectedConditions[index] = value ?? false;
                      });
                    },
                    checkColor: AppTheme.white,
                    activeColor: AppTheme.red,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close without saving
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: AppTheme.red),
          ),
        ),
        TextButton(
          onPressed: () {
            // Get the selected conditions and pass it back to the parent
            List<String> selected = [];
            for (int i = 0; i < selectedConditions.length; i++) {
              if (selectedConditions[i]) {
                selected.add(conditions[i]);
              }
            }
            widget.onComplete(selected); // Pass selected conditions to the parent
            Navigator.pop(context);
          },
          child: Text(
            "Complete",
            style: TextStyle(color: AppTheme.red),
          ),
        ),
      ],
    );
  }
}
