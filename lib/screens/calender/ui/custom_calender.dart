import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/constant_variables.dart';
import '../../../reusable_widgets/language_textbox.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime currentDate;
  final Function(DateTime) dateColorLogic;

  final _borderColor = secondaryBlue;
  final _tileRadius = 4.00;

  CustomCalendar({required this.currentDate, required this.dateColorLogic});

  @override
  Widget build(BuildContext context) {
    // Days of the week starting with Sunday
    List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    // Get the first and last day of the month
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    DateTime lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

    // Calculate the starting day of the week for the calendar (Sunday)
    int startingWeekday = firstDayOfMonth.weekday % 7;

    // Calculate the number of days in the current month
    int daysInMonth = lastDayOfMonth.day;

    // Calculate the number of days to show from the previous month
    DateTime previousMonth = DateTime(currentDate.year, currentDate.month - 1, 1);
    int previousMonthDays = startingWeekday;

    // Calculate the number of days to show from the next month
    int endingWeekday = lastDayOfMonth.weekday % 7;
    int nextMonthDays = 6 - endingWeekday;

    // Create a list of day widgets
    List<Widget> dayTiles = [];

    // Add tiles for the previous month's days
    for (int i = previousMonthDays - 1; i >= 0; i--) {
      DateTime date = DateTime(previousMonth.year, previousMonth.month,
          DateTime(previousMonth.year, previousMonth.month + 1, 0).day - i);
      dayTiles.add(
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey[300], // Disabled color
            borderRadius: BorderRadius.circular(_tileRadius),
            border: Border(
              top: BorderSide(color: _borderColor),
              left: BorderSide(color: _borderColor),
              right: (i + 1) % 7 == 0 ? BorderSide(color: _borderColor) : BorderSide.none,
              bottom: i < 7 ? BorderSide(color: _borderColor) : BorderSide.none,
            ),
          ),
          child: LangText(
            date.day.toString(),
            style: const TextStyle(color: Colors.grey), // Disabled text color
          ),
        ),
      );
    }

    // Add day tiles for each day of the current month
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(currentDate.year, currentDate.month, day);
      Color tileColor = dateColorLogic(date);
      dayTiles.add(
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(_tileRadius),
            border: Border(
              top: BorderSide(color: _borderColor),
              left: BorderSide(color: _borderColor),
              right: day % 7 == 0 ? BorderSide(color: _borderColor) : BorderSide.none,
              bottom: day > daysInMonth - 7 ? BorderSide(color: _borderColor) : BorderSide.none,
            ),
          ),
          child: LangText(
            day.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // Add tiles for the next month's days
    for (int i = 1; i <= nextMonthDays; i++) {
      DateTime date = DateTime(currentDate.year, currentDate.month + 1, i);
      dayTiles.add(
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey[300], // Disabled color
            borderRadius: BorderRadius.circular(_tileRadius),
            border: Border(
              top: BorderSide(color: _borderColor),
              left: BorderSide(color: _borderColor),
              right: (previousMonthDays + daysInMonth + i) % 7 == 0 ? BorderSide(color: _borderColor) : BorderSide.none,
              bottom: i > nextMonthDays - 7 ? BorderSide(color: _borderColor) : BorderSide.none,
            ),
          ),
          child: LangText(
            date.day.toString(),
            style: const TextStyle(color: Colors.grey), // Disabled text color
          ),
        ),
      );
    }

    return Column(
      children: [
        // Weekday headers
        Row(
          children: weekDays.map((day) {
            int index = weekDays.indexOf(day);
            return Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_tileRadius),
                  border: Border(
                    top: BorderSide(color: _borderColor),
                    left: BorderSide(color: _borderColor),
                    right: index == 6 ? BorderSide(color: _borderColor) : BorderSide.none, // Right border for the last day (Saturday)
                    bottom: BorderSide(color: _borderColor), // Bottom border for all headers
                  ),
                  color: primaryBlue,
                ),
                child: LangText(
                  day,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ),

        // Calendar grid
        GridView.count(
          crossAxisCount: 7, // 7 days in a week
          shrinkWrap: true,
          children: dayTiles,
        ),
      ],
    );
  }
}
