import 'package:flutter/material.dart';

import '../../../constants/constant_variables.dart';
import '../../../main.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../ui/mandatory_focussed_summary_screen.dart';

class MandatoryAndFocussedWidget extends StatelessWidget {
  final double cardHeight;

  const MandatoryAndFocussedWidget({
    super.key,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: cardHeight,
      // width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: primary,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LangText(
            'Mandatory & Focussed SKU Summary',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Expanded(
              //   child: InkWell(
              //     onTap: () {
              //
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 10,
              //         vertical: 10,
              //       ),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(6),
              //         color: Colors.white.withOpacity(.6),
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           LangText(
              //             'Mandatory',
              //             style: const TextStyle(
              //               color: Colors.black,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           const Icon(
              //             Icons.arrow_forward,
              //             color: Colors.black,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () {
                    navigatorKey.currentState?.pushNamed(MandatoryFocussedSummaryScreen.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white.withOpacity(.6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: LangText(
                              'View Details',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
