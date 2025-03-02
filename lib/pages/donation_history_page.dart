import 'package:blood_line_mobile/routes/app_routes.dart';
import 'package:blood_line_mobile/services/donation_history_services.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/CustomAppBarRed.dart';
import 'package:flutter/material.dart';

class DonationHistoryPage extends StatefulWidget {
  const DonationHistoryPage({super.key});

  @override
  State<DonationHistoryPage> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage> {
  List<Map<String, dynamic>> donations = [];
  String nextEligibleDate = '';
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchDonationHistory();
  }

  Future<void> _fetchDonationHistory() async {
    try {
      final data = await DonationHistoryService.getDonationHistory(context);
      print(data);
      if (data != null) {
        final donationHistory = List<Map<String, dynamic>>.from(data['donation_history']);
        if (donationHistory.isEmpty) {
          setState(() {
            error = 'No donation history available';
            isLoading = false;
          });
        } else {
          setState(() {
            donations = donationHistory;
            nextEligibleDate = data['next_eligible_donation_date'];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'No donation history available';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'An error occurred while fetching data';
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
            Content: 'Donation History',
          ),
          if (nextEligibleDate.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: AppTheme.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Color(0xFFBC1F34)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Next eligible donation date: $nextEligibleDate',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(child: Text(error!))
                    : donations.isEmpty
                        ? Center(child: Text('No donation history found'))
                        : ListView.builder(
                            padding: EdgeInsets.all(16.0),
                            itemCount: donations.length,
                            itemBuilder: (context, index) {
                              final donation = donations[index];
                              return DonationCard(
                                date: donation['donation_date'],
                                type: donation['donation_type'],
                                hospital: donation['blood_bank_name'],
                                volume: '${donation['quantity_donated']} units',
                                donationId: donation['donation_id'],
                                bloodPressure: donation['blood_pressure'],
                                bloodPulse: donation['donor_blood_pulse'].toString(),
                                temperature: donation['donor_temperature'].toString(),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class DonationCard extends StatelessWidget {
  final String date;
  final String type;
  final String hospital;
  final String volume;
  final int donationId;
  final String bloodPressure;
  final String bloodPulse;
  final String temperature;

  DonationCard({
    required this.date,
    required this.type,
    required this.hospital,
    required this.volume,
    required this.donationId,
    required this.bloodPressure,
    required this.bloodPulse,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: AppTheme.white,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.location_on, size: 20),
                  SizedBox(width: 8.0),
                  Text(type),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.local_hospital, size: 20),
                  SizedBox(width: 8.0),
                  Text(hospital),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.water_drop, size: 20),
                  SizedBox(width: 8.0),
                  Text(volume),
                ],
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFBC1F34),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context, 
                      AppRoutes.donationDetails,
                      arguments: {
                        'donationId': donationId,
                        'date': date,
                        'type': type,
                        'hospital': hospital,
                        'volume': volume,
                        'bloodPressure': bloodPressure,
                        'bloodPulse': bloodPulse,
                        'temperature': temperature,
                      },
                    );
                  },
                  child: Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}