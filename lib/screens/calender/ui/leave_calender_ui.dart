import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constants/constant_variables.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../models/calender_event.dart';
import 'custom_calender.dart';
import 'indication_list.dart';

class LeaveCalenderUi extends StatefulWidget {
  static const routeName = 'LeaveCalenderUi';

  const LeaveCalenderUi({super.key});

  @override
  State<LeaveCalenderUi> createState() => _LeaveCalenderUiState();
}

class _LeaveCalenderUiState extends State<LeaveCalenderUi> {
  String _formatDate(DateTime date) {
    // Define a list of month names
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    // Get the month name from the list using the month index (1-based)
    String monthName = months[date.month - 1];

    // Get the year from the date
    String year = date.year.toString();

    // Return the formatted string
    return '$monthName, $year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Leave Calendar",
        onLeadingIconPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer(
            builder: (context, ref, _) {
              final selectedDate = ref.watch(attendanceDateTimeProvider);
              final focussedDayProvider = ref.watch(focusedDayProvider);

              return Column(
                children: [
                  GlobalWidgets()
                      .showInfo(message: 'You can select your preferred month and year'),
                  const SizedBox(height: 10),

                  /// date picker button
                  InkWell(
                    onTap: () async {
                      showMonthPicker(
                        context,
                        onSelected: (month, year) {
                          ref.read(attendanceDateTimeProvider.notifier).state =
                              DateTime(year, month);
                        },
                        initialSelectedMonth: selectedDate.month,
                        initialSelectedYear: selectedDate.year,
                        firstEnabledMonth: 3,
                        lastEnabledMonth: 10,
                        firstYear: 2000,
                        lastYear: DateTime.now().year + 5,
                        selectButtonText: 'OK',
                        cancelButtonText: 'Cancel',
                        // highlightColor: Colors.purple,
                        textColor: Colors.black,
                        contentBackgroundColor: Colors.white,
                        dialogBackgroundColor: Colors.grey[200],
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 9.sp),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(verificationRadius),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: LangText(
                              _formatDate(selectedDate),
                            ),
                          ),
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Consumer(builder: (context, ref, _) {
                    final asyncCalenderData = ref.watch(
                        leaveCalenderDataProvider('${selectedDate.month}_${selectedDate.year}'));

                    return asyncCalenderData.when(
                      data: (calenderData) {
                        return CustomCalendar(
                          currentDate: selectedDate,
                          dateColorLogic: (date) {
                            // // Example custom logic: Color weekends red
                            // if (date.weekday == DateTime.friday || date.weekday == DateTime.saturday) {
                            //   return Colors.red;
                            // }
                            // // Example custom logic: Color other days green
                            // return Colors.green;

                            final dayString = date.day < 10 ? '0${date.day}' : date.day.toString();
                            final monthString = date.month < 10 ? '0${date.month}' : date.month.toString();

                            final dateKey = '${date.year}-$monthString-$dayString';

                            CalenderEvent event = CalenderEvent();
                            if (calenderData.containsKey(dateKey)) {
                              if (calenderData[dateKey]?.isNotEmpty ?? false) {
                                event = CalenderEvent.fromJson(calenderData[dateKey]?.first);
                              }
                            }

                            return acronymColors[event.name ?? ''] ?? Colors.white;

                          },
                        );
                      },
                      error: (error, stck) {
                        return const SizedBox();
                      },
                      loading: () => Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  /// indicator list
                  IndicationList(
                    indicatorList: [
                      LeaveIndicator(acronym: 'P', abbreviation: 'Present'),
                      LeaveIndicator(acronym: 'L', abbreviation: 'Leave'),
                      LeaveIndicator(acronym: 'M', abbreviation: 'Movement'),
                      LeaveIndicator(acronym: 'O', abbreviation: 'Off Day'),
                      LeaveIndicator(acronym: 'A', abbreviation: 'Absent'),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

final focusedDayProvider = StateProvider.autoDispose((ref) => DateTime.now());
