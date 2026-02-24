import 'package:flutter/material.dart';

extension WidgetExtension on num {
  Widget get horizontalSpacing => SizedBox(width: toDouble());

  Widget get verticalSpacing => SizedBox(height: toDouble());

  BorderRadius get circularRadius => BorderRadius.circular(toDouble());
}

extension TextExtension on String {
  String get nonZeroText => _makeNumber(this);
}

String _makeNumber(String number) {
  String value = double.parse(number).toStringAsFixed(2).toString();
  if (value.contains('.')) {
    List<String> a = value.split('.');

    if (a[1] == '00' || a[1] == '0' || a[1].startsWith("00")) {
      return a[0];
    }
  }

  return value;
}