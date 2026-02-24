import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../constants/constant_variables.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../models/mandatory_focussed.dart';

class SkuSummaryPage extends StatefulWidget {
  final List<MandatoryFocussed> summaryList;

  const SkuSummaryPage({super.key, required this.summaryList});

  @override
  State<SkuSummaryPage> createState() => _SkuSummaryPageState();
}

class _SkuSummaryPageState extends State<SkuSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: const BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LangText(
                'Material Code',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              LangText(
                'Volume',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.summaryList.length,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              bottom: 32,
              left: 16,
              right: 16,
            ),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: index % 2 == 0 ? Colors.white : Colors.white70,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LangText(
                      widget.summaryList[index].materialCode ?? 'N/A',
                    ),
                    LangText(
                      widget.summaryList[index].volume?.toStringAsFixed(2) ?? '0',
                      isNumber: true,
                      isNum: true,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
