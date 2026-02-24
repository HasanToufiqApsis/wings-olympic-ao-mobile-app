import 'package:flutter/material.dart';

import '../../../constants/constant_variables.dart';
import '../../../reusable_widgets/language_textbox.dart';

final Map<String, Color> acronymColors = {
  'P': primary, // Primary green
  'L': Colors.indigo,
  'M': Colors.pinkAccent,
  'O': Colors.grey,
  'A': Colors.red,
};

class LeaveIndicator {
  final String acronym;
  final String abbreviation;

  LeaveIndicator({required this.acronym, required this.abbreviation});
}

class IndicationList extends StatelessWidget {
  final List<LeaveIndicator> indicatorList;

  const IndicationList({super.key, required this.indicatorList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: indicatorList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _IndicationTile(indicator: indicatorList[index]);
      },
    );
  }
}

class _IndicationTile extends StatelessWidget {
  final LeaveIndicator indicator;

  const _IndicationTile({super.key, required this.indicator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              color: acronymColors[indicator.acronym] ?? Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          LangText(indicator.acronym),
          const SizedBox(width: 6),
          LangText('('),
          LangText(
            indicator.abbreviation,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          LangText(')'),
        ],
      ),
    );
  }
}
