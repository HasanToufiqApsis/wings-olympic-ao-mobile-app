import 'package:flutter/material.dart';
import 'package:wings_olympic_sr/reusable_widgets/language_textbox.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color? textColor;

  const TitleText({
    super.key,
    required this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return LangText(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }
}
