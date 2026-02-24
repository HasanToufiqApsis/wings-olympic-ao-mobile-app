import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../controller/sale_controller.dart';

// class SaleYesNoUI extends ConsumerWidget {
//   const SaleYesNoUI({Key? key, required this.onCallStart}) : super(key: key);
//   final VoidCallback onCallStart;
//   @override
//   Widget build(BuildContext context,WidgetRef ref) {
//     return Padding(
//       padding: EdgeInsets.only(top: 3.h, left: 7.5.w, right: 7.5.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//
//           // Padding(
//           //   padding: EdgeInsets.only(left: 40.w, bottom: 1.h),
//           //   child: SizedBox(
//           //     height: 30.sp,
//           //     width: 30.sp,
//           //     child: Image.asset(
//           //       'assets/sell_out_of_selected_outlet_icon.png',
//           //     ),
//           //   ),
//           // ),
//           Icon(Icons.warning_amber_rounded, size: 56, color: yellow,),
//           8.verticalSpacing,
//           Center(
//             child: LangText(
//               'Are you willing to start selling?',
//               style: TextStyle(
//                 color: primary,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 13,
//                 fontFamily: 'NotoSansBengali',
//               ),
//             ),
//           ),
//           SizedBox(height: 5.h),
//           SubmitButtonGroup(
//             twoButtons: true,
//             layout: ButtonLayout.vertical,
//             button1Label: "Yes",
//             button2Label: "No",
//             button2Color: primaryRed,
//             onButton1Pressed:onCallStart,
//             onButton2Pressed: (){
//               // navigatorKey.currentState?.pop();
//               SaleController(context: context,ref:ref).onNoButtonPressedUnsoldRetailer();
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

class SaleYesNoUI extends ConsumerWidget {
  const SaleYesNoUI({super.key, required this.onCallStart});
  final VoidCallback onCallStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              size: 40,
              color: Colors.lightBlueAccent.shade700,
            ),
          ),
          const SizedBox(height: 16),
          LangText(
            'Are you willing to start selling?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w700,
              fontSize: 16,
              fontFamily: 'NotoSansBengali',
            ),
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            label: "Yes",
            onTap: onCallStart,
            icon: Icons.check_circle_outline_rounded,
            color: Colors.white,
            bgColor: Colors.green[600]!,
            isPrimary: true,
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            label: "No",
            onTap: () {
              SaleController(context: context, ref: ref)
                  .onNoButtonPressedUnsoldRetailer();
            },
            icon: Icons.cancel_outlined,
            color: Colors.red[600]!,
            bgColor: Colors.red.withOpacity(0.08),
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required bool isPrimary,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border:
            isPrimary ? null : Border.all(color: color.withOpacity(0.2)),
            boxShadow: isPrimary
                ? [
              BoxShadow(
                color: bgColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              LangText(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}