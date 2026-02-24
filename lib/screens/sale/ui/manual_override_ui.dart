import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';

// class ManualOverrideUI extends StatelessWidget {
//   const ManualOverrideUI({
//     super.key,
//     required this.onGeoFencingRefresh,
//     required this.onManualOverride,
//   });
//
//   final VoidCallback onGeoFencingRefresh;
//   final VoidCallback onManualOverride;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 3.h, left: 7.5.w, right: 7.5.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Icon(
//             size: 56,
//             Icons.warning_amber_rounded,
//             color: yellow,
//           ),
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: LangText(
//               'You are out of the selected outlet range!',
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
//             button1Label: "Force Sell",
//             button2Label: "Refresh",
//             button2Color: greenOlive,
//             onButton1Pressed: onManualOverride,
//             onButton2Pressed: onGeoFencingRefresh,
//           )
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class ManualOverrideUI extends StatelessWidget {
  const ManualOverrideUI({
    super.key,
    required this.onGeoFencingRefresh,
    required this.onManualOverride,
  });

  final VoidCallback onGeoFencingRefresh;
  final VoidCallback onManualOverride;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "background",
      child: Container(
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
              'You are out of the selected outlet range!',
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
              label: "Force Sell",
              onTap: onManualOverride,
              icon: Icons.gavel_rounded,
              color: Colors.red[600]!,
              bgColor: Colors.red.withOpacity(0.08),
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              label: "Refresh",
              onTap: onGeoFencingRefresh,
              icon: Icons.refresh_rounded,
              color: Colors.green[700]!,
              bgColor: Colors.green.withOpacity(0.08),
            ),
          ],
        ),
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