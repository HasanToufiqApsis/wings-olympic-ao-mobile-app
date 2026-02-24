import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constant_variables.dart';
import '../language_textbox.dart';

class CustomSingleDropdown<T> extends StatelessWidget {
  CustomSingleDropdown({
    Key? key,
    required this.items,
    this.value,
    this.labelText,
    this.hintText,
    required this.onChanged,
    this.error = false,
  }) : super(key: key);
  final List<DropdownMenuItem<T>> items;
  T? value;
  final String? labelText;
  final String? hintText;
  final Function(T?) onChanged;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            LangText(
              labelText!,
              style: TextStyle(
                  color: primaryBlack,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold),
            ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 9.sp),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(verificationRadius),
              color: Colors.white,
              border: Border.all(width: 1, color: error ? primaryRed : Colors.transparent)
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                hint: LangText(
                  hintText ?? " ",
                  style: TextStyle(color: Colors.grey, fontSize: 9.sp),
                  overflow: TextOverflow.ellipsis,
                ),
                isExpanded: true,
                value: value,
                onChanged: onChanged,
                items: items,
                style: TextStyle(color: Colors.black, fontSize: 11.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
