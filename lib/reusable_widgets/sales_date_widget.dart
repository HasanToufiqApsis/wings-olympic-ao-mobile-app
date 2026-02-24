import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../constants/constant_variables.dart';
import '../models/outlet_model.dart';
import '../provider/global_provider.dart';
import 'language_textbox.dart';

// class SalesDateWidget extends ConsumerStatefulWidget {
//   final bool removeExtraPadding;
//   final OutletModel? retailer;
//
//   const SalesDateWidget({
//     Key? key,
//     this.removeExtraPadding = false,
//     this.retailer,
//   }) : super(key: key);
//
//   @override
//   ConsumerState createState() => _SalesDateWidgetState();
// }
//
// class _SalesDateWidgetState extends ConsumerState<SalesDateWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       margin:
//           EdgeInsets.symmetric(horizontal: widget.removeExtraPadding ? 0 : 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12, left: 12),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 // const SizedBox(width: 12),
//                 Icon(
//                   Icons.date_range,
//                   color: primary,
//                 ),
//                 const SizedBox(width: 8),
//                 LangText('Date:', style: const TextStyle(fontSize: 14)),
//                 SizedBox(width: 1.5.w),
//                 Consumer(
//                   builder: (context, ref, _) {
//                     final asyncSalesDate = ref.watch(saleDateProvider);
//                     return asyncSalesDate.when(
//                       data: (salesDate) {
//                         return LangText(
//                           salesDate,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         );
//                       },
//                       error: (error, _) => LangText("N/A"),
//                       loading: () => Container(),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Consumer(
//             builder: (context, ref, _) {
//               OutletModel? retailer = widget.retailer ?? ref.watch(selectedRetailerProvider);
//               if (retailer == null) {
//                 return const SizedBox();
//               }
//               return Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.only(
//                       right: 12,
//                       left: 12,
//                       top: 12,
//                       bottom: 0,
//                     ),
//                     decoration: BoxDecoration(
//                       // color: backgroundColor,
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                       ),
//                       border: const Border(
//                         bottom: BorderSide(
//                           color: Colors.transparent,
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _titleValue(title: 'Retailer', value: retailer.owner),
//                         const SizedBox(height: 4),
//                         _titleValue(title: 'Store Name', value: retailer.name),
//                         const SizedBox(height: 4),
//                         _titleValue(
//                             title: 'Code', value: retailer.outletCode ?? "--"),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _titleValue({
//     required String title,
//     required String value,
//     Color valueColor = Colors.black,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//           flex: 1,
//           child: LangText(
//             title,
//             style: const TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         LangText(
//           ' : ',
//           style: const TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(
//           width: 10,
//         ),
//         Expanded(
//           flex: 2,
//           child: LangText(
//             value.isEmpty ? "* * * * * * *" : value,
//             style: TextStyle(
//               color: valueColor,
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//               // fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//


class SalesDateWidget extends ConsumerStatefulWidget {
  final bool removeExtraPadding;
  final OutletModel? retailer;

  const SalesDateWidget({
    Key? key,
    this.removeExtraPadding = false,
    this.retailer,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SalesDateWidgetState();
}

class _SalesDateWidgetState extends ConsumerState<SalesDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.removeExtraPadding ? 0 : 4,
        vertical: 4,
      ),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.withOpacity(0.1)),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.blue[700],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LangText(
                      'Sales Date',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Consumer(
                      builder: (context, ref, _) {
                        final asyncSalesDate = ref.watch(saleDateProvider);
                        return asyncSalesDate.when(
                          data: (salesDate) {
                            return LangText(
                              salesDate,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            );
                          },
                          error: (error, _) => LangText(
                            "N/A",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          loading: () => SizedBox(
                            height: 16,
                            width: 100,
                            child: LinearProgressIndicator(
                              color: Colors.blue.withOpacity(0.2),
                              backgroundColor: Colors.grey[100],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              OutletModel? retailer =
                  widget.retailer ?? ref.watch(selectedRetailerProvider);

              if (retailer == null) {
                return const SizedBox();
              }

              return Column(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                    thickness: 1,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.02),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Store Name (Prominent)
                        Row(
                          children: [
                            Icon(Icons.store_mall_directory_rounded,
                                size: 20, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LangText(
                                retailer.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        _buildSimpleInfo(
                          icon: Icons.person_outline_rounded,
                          text: retailer.owner.isEmpty
                              ? "Unknown"
                              : retailer.owner,
                          color: Colors.grey[600]!,
                        ),
                        const SizedBox(height: 4),
                        _buildSimpleInfo(
                          icon: Icons.qr_code_rounded,
                          text: retailer.outletCode ?? "--",
                          color: Colors.grey[600]!,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  // New Minimal Text Style Widget
  Widget _buildSimpleInfo({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 20, child: Icon(icon, size: 14, color: color)),
        const SizedBox(width: 8),
        LangText(
          text,
          maxLine: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}