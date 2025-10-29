import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyCalendarDataSource extends CalendarDataSource {
  MyCalendarDataSource() {
    appointments = <Appointment>[
      Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 2)),
        subject: 'Team Meeting',
        color: Colors.blue,
      ),
    ];
  }
}
