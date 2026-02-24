import 'package:flutter/material.dart';
import 'package:wings_olympic_sr/reusable_widgets/language_textbox.dart';

class TabWidget extends StatelessWidget {
  final String text;

  const TabWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        // color: const Color(0xFFEBF5FF), // background color of selected tab
        borderRadius: BorderRadius.circular(10),
        // for pill shape
        border: Border.all(
          width: 1,
          color: Colors.grey.shade200,
        ),
      ),
      child: LangText(
        text,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
