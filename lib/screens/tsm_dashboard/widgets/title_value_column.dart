import 'package:flutter/material.dart';

import '../../../reusable_widgets/language_textbox.dart';

class TitleValueColumn extends StatelessWidget {
  final String title;
  final String value;
  final bool isNumericValue;

  const TitleValueColumn({
    super.key,
    required this.title,
    required this.value,
    this.isNumericValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LangText(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 0),
        LangText(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color:Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          isNumber: isNumericValue,
          isNum: isNumericValue,
        ),
      ],
    );
  }
}
