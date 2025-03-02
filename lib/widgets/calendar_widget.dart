import 'package:flutter/material.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final Function(String) onDateSelected;

  const CalendarWidget({super.key, required this.onDateSelected});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensures the dialog size is compact
        children: [
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _selectedDate,
            headerStyle: HeaderStyle(formatButtonVisible: false),
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (selectedDay.isAfter(DateTime.now()) || isSameDay(selectedDay, DateTime.now())) {
                setState(() {
                  _selectedDate = selectedDay;
                });
                widget.onDateSelected(_selectedDate.toLocal().toString().split(' ')[0]);
              }
            },
            enabledDayPredicate: (day) {
              // Disable days before the current day
              return day.isAfter(DateTime.now().subtract(const Duration(days: 1)));
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppTheme.red,
                shape: BoxShape.circle,
              ),
              disabledDecoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              disabledTextStyle: TextStyle(color: Colors.black38),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Selected Date: ${_selectedDate.toLocal()}".split(' ')[0],
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
