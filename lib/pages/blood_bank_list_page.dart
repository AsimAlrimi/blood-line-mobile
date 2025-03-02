import 'package:blood_line_mobile/services/get_blood_banks.dart';
import 'package:blood_line_mobile/services/follow_blood_bank_service.dart'; // Import the follow service
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/CustomAppBarRed.dart';
import 'package:flutter/material.dart';

/// BloodBank model
class BloodBank {
  final String id; // Add id to the model
  final String name;
  final String operationHours;
  final String contact;
  bool isFollowed; // Change from isFavorite to isFollowed

  BloodBank({
    required this.id,
    required this.name,
    required this.operationHours,
    required this.contact,
    this.isFollowed = false,
  });

  /// Factory constructor to create BloodBank from JSON
  factory BloodBank.fromJson(Map<String, dynamic> json) {
    return BloodBank(
      id: (json['blood_bank_id'] ?? '').toString(),
      name: json['name'] ?? 'Unknown',
      operationHours: "${json['start_hour']} - ${json['close_hour']}",
      contact: json['phone_number'] ?? 'N/A',
    );
  }
}

/// BloodBankListPage widget
class BloodBankListPage extends StatefulWidget {
  const BloodBankListPage({super.key});

  @override
  State<BloodBankListPage> createState() => _BloodBankListPageState();
}

class _BloodBankListPageState extends State<BloodBankListPage> {
  final List<BloodBank> bloodBanks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBloodBanksAndFollowedStatus();
  }

  /// Fetch blood banks and their followed status
  Future<void> _fetchBloodBanksAndFollowedStatus() async {
    try {
      // Fetch all blood banks
      final bloodBankResults = await BloodBankService.fetchBloodBanks(context);
      if (bloodBankResults == null) {
        print("Failed to fetch blood banks");
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }

      // Fetch followed blood banks
      final followedBanks = await followBloodBankService.getFollowedBloodBanks(context);

      if (mounted) {
        setState(() {
          // Convert blood bank results to BloodBank objects
          bloodBanks.addAll(bloodBankResults.map((e) {
            BloodBank bloodBank = BloodBank.fromJson(e);

            // Check if this blood bank is in the followed list
            if (followedBanks != null) {
              bloodBank.isFollowed = followedBanks.any((followedBank) =>
                  followedBank['id'].toString() == bloodBank.id);
            }

            return bloodBank;
          }).toList());

          isLoading = false;
        });
      }
    } catch (e) {
      print("An error occurred: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// Toggle follow status
  Future<void> _toggleFollow(int index) async {
    final bloodBank = bloodBanks[index];

    try {
      bool success;
      if (bloodBank.isFollowed) {
        // Unfollow the blood bank
        success = await followBloodBankService.unfollowBloodBank(context, bloodBank.id);
      } else {
        // Follow the blood bank
        success = await followBloodBankService.followBloodBank(context, bloodBank.id);
      }

      if (success && mounted) {
        setState(() {
          bloodBanks[index].isFollowed = !bloodBank.isFollowed;
        });
      }
    } catch (e) {
      print("An error occurred while toggling follow: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 195),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CustomAppBar(
            Content: "Blood Banks",
            SecondLine:
                "By following a blood bank, you will receive notifications about blood donation events and blood needs.",
            NavBar: true,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bloodBanks.length,
              itemBuilder: (context, index) {
                final bloodBank = bloodBanks[index];
                return Card(
                  color: AppTheme.lightgrey,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      bloodBank.name,
                      style: AppTheme.instructionBlack_18
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Operation Hours: ${bloodBank.operationHours}"),
                        Text("Contact: ${bloodBank.contact}"),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(
                        bloodBank.isFollowed ? Icons.favorite : Icons.favorite_border,
                        color: bloodBank.isFollowed ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => _toggleFollow(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
