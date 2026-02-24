import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/module.dart';
import '../../../reusable_widgets/language_textbox.dart';

class MemoTitleTab extends StatelessWidget {
  final Module? module;
  final String? title;
  final Color? bgc;

  const MemoTitleTab({
    super.key,
    this.module,
    this.title,
    this.bgc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: bgc ?? primary,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      child: Tab(
        child: LangText(
          title ?? module?.name ?? '',
          style: const TextStyle(
            color: Colors.white,
            // fontSize: normalFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
