import 'package:blood_line_mobile/widgets/CustomAppBarRed.dart';
import 'package:flutter/material.dart';

class DonationDetails extends StatelessWidget {
  const DonationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (arguments == null) {
      return Scaffold(
        body: Center(child: Text('No donation details available')),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            viewType: 'oneLine',
            Content: 'Donation Details',
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    arguments['date'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  DetailRow(
                    icon: Icons.confirmation_number,
                    label: 'Donation ID',
                    value: arguments['donationId'].toString(),
                  ),
                  DetailRow(
                    icon: Icons.location_on,
                    label: 'Donation Type',
                    value: arguments['type'],
                  ),
                  DetailRow(
                    icon: Icons.local_hospital,
                    label: 'Hospital Name',
                    value: arguments['hospital'],
                  ),
                  DetailRow(
                    icon: Icons.water_drop,
                    label: 'Donation Volume',
                    value: arguments['volume'],
                  ),
                  DetailRow(
                    icon: Icons.favorite,
                    label: 'Blood Pressure',
                    value: arguments['bloodPressure'],
                  ),
                  DetailRow(
                    icon: Icons.timeline,
                    label: 'Blood Pulse',
                    value: '${arguments['bloodPulse']} bpm',
                  ),
                  DetailRow(
                    icon: Icons.thermostat,
                    label: 'Temperature',
                    value: '${arguments['temperature']}°F',
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

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}