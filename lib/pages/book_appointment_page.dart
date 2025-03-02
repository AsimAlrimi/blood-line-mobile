import 'package:blood_line_mobile/pages/main_screen.dart';
import 'package:blood_line_mobile/services/book_appointment_service.dart';
import 'package:blood_line_mobile/widgets/CustomAppBarRed.dart';
import 'package:flutter/material.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/calendar_widget.dart';
import 'package:blood_line_mobile/widgets/custom_button.dart';
import 'package:blood_line_mobile/widgets/donor_card_dialog.dart';

class BookAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> bloodBank; // Accept dynamic values

  const BookAppointmentPage({Key? key, required this.bloodBank}) : super(key: key);

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

  class _BookAppointmentPageState extends State<BookAppointmentPage> {
    String _selectedDateText = DateTime.now().toString().split(' ')[0]; 
    String _donorCardText = "Incomplete";
    String? _selectedTime;
    String? _selectedDonationType;

    void _bookAppointment(BuildContext context) async {
      if (_selectedDateText == "None Selected" || _selectedTime == null || _selectedDonationType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields before booking.")),
        );
        return;
      }

      final success = await BookAppointmentService.bookAppointment(
        context: context,
        bloodBankId: widget.bloodBank["blood_bank_id"],
        appointmentDate: _selectedDateText,
        appointmentTime: _selectedTime!,
        donationType: _selectedDonationType!,
        diseases: _donorCardText == "None selected" ? [] : _donorCardText.split(", "),
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(initialIndex: 1), // Navigate to Map Page with index 1
          ),
        );
      }

    }


    List<String> _generateTimeSlots() {
      final startTimeParts = widget.bloodBank["start_hour"]!.split(":");
      final endTimeParts = widget.bloodBank["close_hour"]!.split(":");
      
      final startHour = int.parse(startTimeParts[0]);
      final startMinute = int.parse(startTimeParts[1]);
      final endHour = int.parse(endTimeParts[0]);
      final endMinute = int.parse(endTimeParts[1]);
      
      final startTime = TimeOfDay(hour: startHour, minute: startMinute);
      final endTime = TimeOfDay(hour: endHour, minute: endMinute);
      
      // Current time to compare
      final now = TimeOfDay.now();
      
      // Parse the selected date
      final selectedDate = DateTime.parse(_selectedDateText);
      final today = DateTime.now();
      
      // Generate time slots
      final timeSlots = <String>[];
      TimeOfDay currentTime = startTime;
      
      while (currentTime.hour < endTime.hour ||
            (currentTime.hour == endTime.hour && currentTime.minute < endTime.minute)) {
        // Check if the selected date is today
        if (isSameDay(selectedDate, today)) {
          // Convert TimeOfDay to minutes for comparison
          final currentMinutes = currentTime.hour * 60 + currentTime.minute;
          final nowMinutes = now.hour * 60 + now.minute;
          
          // Only add time slots that are in the future for today
          if (currentMinutes >= nowMinutes) {
            timeSlots.add("${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')}");
          }
        } else {
          // For future dates, add all available time slots
          timeSlots.add("${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')}");
        }
        
        final nextMinutes = currentTime.minute + 30;
        currentTime = TimeOfDay(
          hour: currentTime.hour + (nextMinutes ~/ 60),
          minute: nextMinutes % 60,
        );
      }
      
      return timeSlots;
    }

    // Helper method to check if two dates are on the same day
    bool isSameDay(DateTime date1, DateTime date2) {
      return date1.year == date2.year &&
            date1.month == date2.month &&
            date1.day == date2.day;
    }

    void _showCalendarDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: CalendarWidget(
              onDateSelected: (selectedDate) {
                setState(() {
                  // Assuming CalendarWidget returns a DateTime or a formatted date string
                  _selectedDateText = selectedDate.toString().split(' ')[0]; // Convert to 'YYYY-MM-DD' format
                });
                Navigator.of(context).pop();
              },
            ),
          );
        },
      );
    }

  void _showDonorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DonorCardDialog(
          onComplete: (List<String> selectedConditions) {
            setState(() {
              if (selectedConditions.isEmpty) {
                _donorCardText = "None selected";
              } else {
                _donorCardText = selectedConditions.join(", "); // Display selected conditions
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          CustomAppBar(
              Content: "${widget.bloodBank['name']}",
              SecondLine: "Operation hours: ${widget.bloodBank['start_hour']} - ${widget.bloodBank['close_hour']}",
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  // Pick Date Section
                  Row(
                    children: [
                      const Text(
                        "Pick Date",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: _showCalendarDialog,
                        child: const Icon(
                          Icons.date_range_outlined,
                          size: 25,
                          color: AppTheme.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(_selectedDateText),
            
                  const SizedBox(height: 20.0),
            
                  // Pick Time Section
                  const Text(
                    "Pick Time",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    height: 40, // Height of the time slots row
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _generateTimeSlots().length,
                      itemBuilder: (context, index) {
                        final timeSlot = _generateTimeSlots()[index];
                        final isSelected = _selectedTime == timeSlot;
            
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTime = timeSlot;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.red : AppTheme.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                timeSlot,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            
            
            
                  const SizedBox(height: 20.0),
            
                  // Donation Type Selection
                  const Text(
                    "Donation Type",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 10.0,
                    children: ["Whole Blood"].map((type) {
                      final isSelected = _selectedDonationType == type;
                      return ChoiceChip(
                        label: Text(
                          type,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black, // Text color
                          ),
                        ),
                        backgroundColor: AppTheme.white, // Background color when not selected
                        selectedColor: AppTheme.red, // Background color when selected
                        
                        onSelected: (selected) {
                          setState(() {
                            _selectedDonationType = selected ? type : null;
                          });
                        },
                        selected: isSelected,
                      );
                    }).toList(),
                  ),
            
            
                  const SizedBox(height: 20.0),
                  //Donor Card
                  Row(
                    children: [
                      const Text(
                        "Donor Card",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: _showDonorDialog,
                        child: const Icon(
                          Icons.app_registration,
                          size: 25,
                          color: AppTheme.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    _donorCardText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: _donorCardText == "None selected" ? Colors.black : AppTheme.black,
                    ),
                  ),
            
            
                  const SizedBox(height: 40.0),
            
                  // Final Booking Button
                  Center(
                    child: CustomButton(
                      text: "Book Appointment",
                      size: const Size(250, 55),
                      onPressed: () {
                        _bookAppointment(context);
                      },
                    ),
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
