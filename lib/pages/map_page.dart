import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:blood_line_mobile/widgets/couston_map_card.dart';
import 'package:blood_line_mobile/services/get_blood_banks.dart';
import 'package:blood_line_mobile/services/book_appointment_service.dart';

const LatLng currentLocation = LatLng(31.9539, 35.9106);

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String mapTheme = '';
  BitmapDescriptor cMarkerIcon = BitmapDescriptor.defaultMarker;
  String? selectedMarkerId; // Holds the selected marker ID
  final Set<Marker> _markers = {};
  List<Map<String, dynamic>> bloodBankData = []; // Dynamic blood bank data
  Map<String, dynamic>? pendingAppointment;

@override
void initState() {
  super.initState();
  loadCustomMarkerIcon();
  DefaultAssetBundle.of(context)
      .loadString("assets/maptheme/standard_theme.json")
      .then((value) {
    if (mounted) {
      setState(() {
        mapTheme = value;
      });
    }
  });
  fetchBloodBanksData();
  checkForPendingAppointment();
}

Future<void> checkForPendingAppointment() async {
  final appointment = await BookAppointmentService.checkPendingAppointment(context);
  if (mounted) {
    setState(() {
      pendingAppointment = appointment;
    });
  }
}

Future<void> loadCustomMarkerIcon() async {
  final icon = await BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(size: Size(40, 40)),
    'assets/images/Mappin2.png',
  );

  if (mounted) {
    setState(() {
      cMarkerIcon = icon;
    });
  }
}

Future<void> fetchBloodBanksData() async {
  final bloodBanks = await BloodBankService.fetchBloodBanks(context);
  if (bloodBanks != null && mounted) {
    setState(() {
      bloodBankData = bloodBanks;
    });
    _loadMarkers();
  }
}

Future<void> cancleApp() async {
  await BookAppointmentService.cancelAppointment(context);
}


  void _loadMarkers() {
    _markers.clear(); // Clear existing markers

    for (var bank in bloodBankData) {
      final markerId = MarkerId(bank['blood_bank_id'].toString());
      final latitude = double.parse(bank['latitude'].toString());
      final longitude = double.parse(bank['longitude'].toString());

      _markers.add(
        Marker(
          markerId: markerId,
          position: LatLng(latitude, longitude),
          icon: cMarkerIcon,
          onTap: () => onMarkerTap(bank['blood_bank_id'].toString()),
          infoWindow: InfoWindow(title: bank['name']),
        ),
      );
    }
    setState(() {}); // Refresh markers on the map
  }

  void onMapTap() {
    setState(() {
      selectedMarkerId = null; // Close the card on tapping elsewhere
    });
  }

  void onMarkerTap(String markerId) {
    setState(() {
      selectedMarkerId = markerId; // Open the card with specific marker info
    });
  }

  @override
  Widget build(BuildContext context) {
    // If there's a pending appointment, show its details
    if (pendingAppointment != null) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
        ),
        body: Stack(
          children: [
            // Google Map as the background (slightly faded)
            Opacity(
              opacity: 0.5,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: currentLocation,
                  zoom: 11,
                ),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(mapTheme);
                },
                markers: _markers,
                onTap: (LatLng position) => onMapTap(),
              ),
            ),
            
            // Appointment Card Centered
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 8,
                  color: AppTheme.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appointment',
                          style: AppTheme.h3(),
                        ),
                        const SizedBox(height: 10),
                        Text('Date: ${pendingAppointment!['appointment_date']}'),
                        const SizedBox(height: 5),
                        Text('Time: ${pendingAppointment!['appointment_time']}'),
                        const SizedBox(height: 5),
                        Text('Blood Bank: ${pendingAppointment!['blood_bank']}'),
                        const SizedBox(height: 5),
                        Text('Donation Type: ${pendingAppointment!['donation_type']}'),
                        const SizedBox(height: 10),
                        Center(
                          child: CustomButton(text: "Cancel", onPressed: (){
                            cancleApp();
                          }, size: Size(100, 20), fontSize: 15,),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Default map interaction if no pending appointment
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(10),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: Stack(
        children: [
          // Google Map as the background
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: currentLocation,
              zoom: 11,
            ),
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(mapTheme);
            },
            markers: _markers,
            onTap: (LatLng position) => onMapTap(),
          ),
          
          // Conditional rendering of the card
          if (selectedMarkerId != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: CoustonMapCard(
                bloodBank: bloodBankData.firstWhere(
                  (bank) => bank['blood_bank_id'].toString() == selectedMarkerId,
                  orElse: () => {},
                ),
              ),
            ),
        ],
      ),
    );
  }
}