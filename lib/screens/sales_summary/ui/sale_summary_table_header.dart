import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../reusable_widgets/language_textbox.dart';

class SaleSummaryTableHeader extends StatelessWidget {
  final bool sharpTopLeft;

  const SaleSummaryTableHeader({
    Key? key,
    this.sharpTopLeft = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp), topLeft: sharpTopLeft==true?  Radius.circular(0.sp) : Radius.circular(5.sp)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, primaryBlue],
        ),
        color: Colors.grey[100],
      ),
      child: DefaultTextStyle(
        style: TextStyle(fontSize: standardFontSize, color: Colors.white, fontWeight: FontWeight.bold),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: LangText(
                  'SKU',
                  style: TextStyle(color: Colors.white, fontSize: smallFontSize),
                ),
              ),
              Expanded(
                child: Center(
                  child: LangText(
                    'Memo',
                    style: TextStyle(color: Colors.white, fontSize: smallFontSize),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: LangText(
                    'BCP',
                    style: TextStyle(color: Colors.white, fontSize: smallFontSize),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: LangText(
                    'Quantity',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: smallFontSize),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: LangText(
                  'Price',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white, fontSize: smallFontSize),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
