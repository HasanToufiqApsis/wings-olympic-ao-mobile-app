import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';

import '../models/trade_promotions/promotion_model.dart';
import 'language_textbox.dart';

class OfferDateWidget extends StatelessWidget {
  final PromotionModel promotion;
  const OfferDateWidget({super.key, required this.promotion});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.date_range, size: 16, color: primary),
            const SizedBox(width: 4),
            // SizedBox(
            //   width: 8.w,
            //   child: Text(
            //     'Start:',
            //     style: TextStyle(color: wingsPrimaryGreen, fontSize: 11),
            //   ),
            // ),
            LangText(
              formatDateString(promotion.startDate),
              style: TextStyle(color: primary, fontSize: 11),
            ),
          ],
        ),
        Icon(Icons.arrow_forward, color: greenPaste,size: 15.sp,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.date_range, size: 16, color: Colors.red),
            const SizedBox(width: 4),
            LangText(
              formatDateString(promotion.endDate),
              style: TextStyle(color: Colors.red, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
  String formatDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "N/A"; // Return empty string for invalid or empty input
    }

    try {
      DateTime dateTime = DateTime.parse(dateString);
      String formattedDate = DateFormat("MMM d, y").format(dateTime);
      return formattedDate;
    } catch (e) {
      return "N/A"; // Return empty string for invalid date format
    }
  }
}
