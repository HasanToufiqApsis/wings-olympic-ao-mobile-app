import 'package:flutter/material.dart';

import '../../constants/constant_variables.dart';
import '../../screens/sale/ui/sku_case_piece_show_widget.dart';
import '../../utils/case_piece_type_utils.dart';
import '../language_textbox.dart';

// class ExamineTotalRow extends StatelessWidget {
//   final int totalVolume;
//   final String price;
//   final Map<CasePieceType, dynamic>? unitWiseTotalQty;
//
//   const ExamineTotalRow({
//     super.key,
//     required this.totalVolume,
//     required this.price,
//     this.unitWiseTotalQty,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.red.withOpacity(0.04),
//         border: Border(top: BorderSide(color: Colors.red.withOpacity(0.1))),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: LangText(
//               "Total",
//               style: TextStyle(color: Colors.red[800], fontSize: 13, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: unitWiseTotalQty == null
//                     ? [
//                         UnitWiseCountWidget(
//                           unitName: "Pcs",
//                           count: totalVolume,
//                           qtyTextStyle: TextStyle(
//                             color: Colors.red[800],
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           unitTextStyle: TextStyle(
//                             color: Colors.red[800],
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ]
//                     : unitWiseTotalQty!.entries
//                           .map(
//                             (e) => UnitWiseCountWidget(
//                               unitName: CasePieceTypeUtils.toStr(e.key),
//                               count: totalVolume,
//                               qtyTextStyle: TextStyle(
//                                 color: Colors.red[800],
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               unitTextStyle: TextStyle(
//                                 color: Colors.red[800],
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           )
//                           .toList(),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: LangText(
//                 price,
//                 style: TextStyle(color: Colors.red[800], fontSize: 13, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


class ExamineTotalRow extends StatelessWidget {
  final String title;
  final String price;
  final int totalVolume;
  final Map<dynamic, dynamic>? unitWiseTotalQty;

  const ExamineTotalRow({
    Key? key,
    this.title = "Total",
    required this.price,
    this.totalVolume = 0,
    this.unitWiseTotalQty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      color: Colors.red[800],
      fontSize: 13,
      fontWeight: FontWeight.bold,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.07),
        border: Border(top: BorderSide(color: Colors.red.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: LangText(
              title,
              style: textStyle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: unitWiseTotalQty == null
                    ? [
                  UnitWiseCountWidget(
                    unitName: "Pcs",
                    count: totalVolume,
                    qtyTextStyle: textStyle,
                    unitTextStyle: textStyle,
                  ),
                ]
                    : unitWiseTotalQty!.entries
                    .map(
                      (e) => UnitWiseCountWidget(
                    unitName: CasePieceTypeUtils.toStr(e.key),
                    count: totalVolume,
                    qtyTextStyle: textStyle,
                    unitTextStyle: textStyle,
                  ),
                )
                    .toList(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: LangText(
                price,
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}