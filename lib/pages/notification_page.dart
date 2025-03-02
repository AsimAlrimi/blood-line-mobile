import 'package:blood_line_mobile/main.dart';
import 'package:blood_line_mobile/services/blood_bank_events_services.dart';
import 'package:blood_line_mobile/services/blood_bank_need_ervice.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/BloodRequest_EventRequestCard.dart';
import 'package:blood_line_mobile/widgets/CustomAppBarRed.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> bloodNeeds = [];
  List<Map<String, dynamic>> events = [];
  bool isLoadingNeeds = true;
  bool isLoadingEvents = true;
  String? errorNeeds;
  String? errorEvents;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchBloodNeeds();
    _fetchEvents();
  }

  Future<void> _fetchBloodNeeds() async {
    try {
      setState(() {
        isLoadingNeeds = true;
        errorNeeds = null;
      });

      final fetchedNeeds = await BloodBankNeedService.getBloodBankNeeds(context);
      
      if (fetchedNeeds != null) {
        setState(() {
          bloodNeeds = fetchedNeeds;
          isLoadingNeeds = false;
        });
      } else {
        if (context.mounted) {
        setState(() {
          errorNeeds = 'Failed to fetch blood needs';
          isLoadingNeeds = false;
        });
        }
      }
    } catch (e) {
      if (context.mounted) {
      setState(() {
        errorNeeds = 'An error occurred while fetching blood needs: $e';
        isLoadingNeeds = false;
      });
      }
    }
  }

  Future<void> _fetchEvents() async {
    try {
      setState(() {
        isLoadingEvents = true;
        errorEvents = null;
      });

      final fetchedEvents = await BloodBankEventService.getBloodBankEvents(context);
      
      if (fetchedEvents != null) {
        setState(() {
          events = fetchedEvents;
          isLoadingEvents = false;
        });
      } else {
        setState(() {
          errorEvents = 'Failed to fetch events';
          isLoadingEvents = false;
        });
      }
    } catch (e) {
      setState(() {
        errorEvents = 'An error occurred while fetching events: $e';
        isLoadingEvents = false;
      });
    }
  }

  String formatDateTime(String date, String time) {
    return "$date at $time";
  }

  Widget _buildLoadingError(String error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error),
          ElevatedButton(
            onPressed: onRetry,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodRequestsList() {
    if (isLoadingNeeds) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorNeeds != null) {
      return _buildLoadingError(errorNeeds!, _fetchBloodNeeds);
    }

    if (bloodNeeds.isEmpty) {
      return Center(child: Text('No blood requests available'));
    }

    return ListView.builder(
      itemCount: bloodNeeds.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        final need = bloodNeeds[index];
        final String timeLimit = formatDateTime(
          need['expire_date'] ?? 'Date not specified',
          need['expire_time'] ?? 'Time not specified'
        );
        
        return BloodRequestEventCard(
          bloodTypes: need['blood_type'],
          units: need['units']?.toDouble(),
          gender: "Blood Need", // API doesn't provide gender
          age: null, // API doesn't provide age
          name: need['blood_bank_name'] ?? 'Unknown blood bank',
          location: need['location'] ?? 'Location not specified',
          hospital: need['hospital'] ?? 'Hospital not specified',
          timeLimit: timeLimit,
          nameEvent: '',
           isEventCard: false,
        );
      },
    );
  }

  Widget _buildEventsList() {
    if (isLoadingEvents) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorEvents != null) {
      return _buildLoadingError(errorEvents!, _fetchEvents);
    }

    if (events.isEmpty) {
      return Center(child: Text('No events available'));
    }

    return ListView.builder(
      itemCount: events.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        final event = events[index];
        final String timeLimit = formatDateTime(
          event['event_date'] ?? 'Date not specified',
          event['event_time'] ?? 'Time not specified'
        );
        
        return BloodRequestEventCard(
          bloodTypes: null,
          units: null,
          gender: null,
          age: null,
          name: event['title'] ?? 'Unknown title',
          location: event['location'] ?? 'Location not specified',
          hospital: event['blood_bank_name'] ?? 'Location not specified',
          timeLimit: timeLimit,
          nameEvent: event['title'] ?? 'Unnamed Event',
          description: event['description'] ?? "no description",
           isEventCard: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAppBar(
            Content: "Notification",
            SecondLine: "See received blood requests and request status",
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: AppTheme.red,
            labelColor: AppTheme.red,
            unselectedLabelColor: AppTheme.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "Blood Requests"),
              Tab(text: "Events"),
            ],
          ),
          SizedBox(
            width: screenWidth,
            height: screenHeight * 0.699,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBloodRequestsList(),
                _buildEventsList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchBloodNeeds();
          _fetchEvents();
        },
        child: Icon(Icons.refresh, color: AppTheme.white),
        backgroundColor: AppTheme.red,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}