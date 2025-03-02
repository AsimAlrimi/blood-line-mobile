import 'package:blood_line_mobile/pages/event_details.dart';
import 'package:blood_line_mobile/pages/main_screen.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BloodRequestEventCard extends StatelessWidget {
  final String? bloodTypes;
  final double? units;
  final String? gender;
  final int? age;
  final String? name;
  final String location;
  final String? hospital;
  final String timeLimit;
  final String? nameEvent;
  final String? description;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final VoidCallback? onCall;
  final bool isEventCard;

  const BloodRequestEventCard({
    super.key,
    this.bloodTypes,
    this.units,
    this.gender,
    this.age,
    this.name,
    required this.location,
    this.hospital,
    required this.timeLimit,
    this.nameEvent,
    this.description,
    this.onAccept,
    this.onCancel,
    this.onCall,
    required this.isEventCard,
  });



  @override
  Widget build(BuildContext context) {
    
    return Card(
      elevation: 2,
      color: AppTheme.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color.fromARGB(255, 210, 210, 210), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTypeContainer(),
                const SizedBox(width: 12),
                Expanded(child: _buildDetailsSection()),
              ],
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildTypeContainer() {
    return Container(
      height: 100,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -4,
            right: -4,
            child: Icon(
              Icons.bloodtype,
              size: 32,
              color: AppTheme.red,
            ),
          ),
          Center(
            child: isEventCard
                ? Text(
                    "Event",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.red,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bloodTypes ?? '',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${units?.toStringAsFixed(0) ?? 0} units',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                isEventCard ? '$nameEvent' : '$gender',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.phone, color: AppTheme.red),
              onPressed: onCall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.location_on, location),
        if (hospital != null) ...[
          const SizedBox(height: 8),
          _buildInfoRow(Icons.local_hospital, hospital!),
        ],
        if (!isEventCard) ...[
        const SizedBox(height: 8),
        _buildInfoRow(Icons.schedule, "Ends: $timeLimit"),
        ],
        if (isEventCard)...[
        const SizedBox(height: 8),
        _buildInfoRow(Icons.schedule, timeLimit),
        ],
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

 Widget _buildActionButtons(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.grey.shade200),
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextButton.icon(
            icon: Icon(
              isEventCard ? Icons.arrow_forward : Icons.check,
              color: Colors.grey.shade600,
            ),
            label: Text(
              isEventCard ? 'Read More' : 'Accept',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => isEventCard 
                    ? EventDetails(
                        eventTitle: name ?? 'Unknown title',
                        description: description ?? 'No description',
                        date: timeLimit,
                        location: location,
                        type: hospital ?? 'Location not specified',
                      ) 
                    : MainScreen(initialIndex: 1),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        )
      ],
    ),
  );
}
}