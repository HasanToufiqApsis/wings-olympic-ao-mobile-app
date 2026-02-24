import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';

import '../language_textbox.dart';

class AlphabetLoaderWidget extends StatelessWidget {
  const AlphabetLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List alphaList = ["All", "aa", "bb", "cc"];

    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(vertical: 0.0.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.sp), color: Colors.grey),
      child: DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(
              alphaList.length,
                  (index) => FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(2.sp),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
                    decoration: ('All' == alphaList[index])
                        ? BoxDecoration(
                      borderRadius: BorderRadius.circular(5.sp),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [primary, darkGreen],
                      ),
                    )
                        : null,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: Text(
                          alphaList[index].toString(),
                          style: const TextStyle(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
