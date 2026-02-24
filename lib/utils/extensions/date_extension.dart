import 'package:intl/intl.dart';

extension DateExtension on String {
  String get hourlyDateFormat => DateFormat('hh:mm a').format(
    DateTime.parse(this),
  );

  String get dayMonthYear => DateFormat('dd MMM yyyy').format(
    DateTime.parse(this),
  );
}