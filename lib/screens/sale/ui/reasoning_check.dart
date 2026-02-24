import 'package:flutter/material.dart';

import '../../../reusable_widgets/language_textbox.dart';

// class ReasoningCheckUI extends StatelessWidget {
//   const ReasoningCheckUI({Key? key, required this.onManualOverrideDone}) : super(key: key);
//   final Function onManualOverrideDone;
//   @override
//   Widget build(BuildContext context) {
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
//
//           Icon(Icons.warning_amber_rounded, size: 56, color: yellow,),
//           8.verticalSpacing,
//           Center(
//             child: LangText(
//               "Select Reason for force sales. You have to capture outlet's image for force sell.",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: primaryRed,
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
//             button1Label: "Internet problem",
//             button2Label: "Change of location",
//             button2Color: red3.withValues(alpha: .9),
//             button1Color: red3,
//             onButton1Pressed:(){
//               onManualOverrideDone(1);
//             },
//             onButton2Pressed: (){
//               onManualOverrideDone(2);
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

class ReasoningCheckUI extends StatelessWidget {
  const ReasoningCheckUI({Key? key, required this.onManualOverrideDone})
      : super(key: key);
  final Function onManualOverrideDone;

  @override
  Widget build(BuildContext context) {
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
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              size: 40,
              color: Colors.orange[700],
            ),
          ),
          const SizedBox(height: 16),
          LangText(
            "Select Reason for force sales. You have to capture outlet's image for force sell.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w700,
              fontSize: 15,
              fontFamily: 'NotoSansBengali',
            ),
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            label: "Internet problem",
            onTap: () {
              onManualOverrideDone(1);
            },
            icon: Icons.signal_wifi_connected_no_internet_4_rounded,
            color: Colors.red[600]!,
            bgColor: Colors.red.withOpacity(0.08),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            label: "Change of location",
            onTap: () {
              onManualOverrideDone(2);
            },
            icon: Icons.location_disabled_rounded,
            color: Colors.red[600]!,
            bgColor: Colors.red.withOpacity(0.08),
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
            border: Border.all(color: color.withOpacity(0.2)),
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