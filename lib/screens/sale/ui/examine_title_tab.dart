import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/module.dart';
import '../../../reusable_widgets/language_textbox.dart';

class ExamineTitleTab extends StatelessWidget {
  final Module? module;
  final String? title;

  const ExamineTitleTab({
    super.key,
    this.module,
    this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD32F2F),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: LangText(
        title ?? module?.name ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
    // return Container(
    //   height: 4.h,
    //   padding: EdgeInsets.symmetric(horizontal: 3.w),
    //   decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //         colors: [
    //           // module == null ? primaryBlue : moduleColor[module!.id]![0],
    //           // module == null ? primaryGreen : moduleColor[module!.id]![1],
    //           module == null ? primaryBlue : moduleColor[1]![0],
    //           module == null ? primary : moduleColor[1]![1],
    //         ],
    //         begin: Alignment.topCenter,
    //         end: Alignment.bottomCenter,
    //       ),
    //       borderRadius: BorderRadius.only(topLeft: Radius.circular(5.sp), topRight: Radius.circular(5.sp))),
    //   child: Tab(
    //     child: LangText(
    //       title ?? module?.name ?? '',
    //       style: const TextStyle(
    //         color: Colors.white,
    //         // fontSize: normalFontSize,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //   ),
    // );
  }
}
