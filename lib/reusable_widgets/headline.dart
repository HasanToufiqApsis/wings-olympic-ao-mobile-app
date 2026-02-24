import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import 'language_textbox.dart';

Widget heading(String label, [double? fontSize, Alignment? alignment]) {
  return Align(
    alignment: alignment ?? Alignment.centerLeft,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      child: LangText(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize ?? 11.sp),
      ),
    ),
  );
}