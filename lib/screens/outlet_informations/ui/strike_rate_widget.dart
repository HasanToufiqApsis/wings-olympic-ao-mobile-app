import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/outlet_services.dart';
import '../../../utils/icons/target_icons.dart';

// class StrikeRateWidget extends StatelessWidget {
//   final SaleType saleType;
//
//   const StrikeRateWidget({super.key, required this.saleType});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.all(Radius.circular(8)),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.2),
//             spreadRadius: 1,
//             blurRadius: 2,
//             offset: const Offset(0, 2), // changes position of shadow
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       margin: const EdgeInsets.only(bottom: 20),
//       child: Consumer(
//         builder: (BuildContext context, WidgetRef ref, Widget? child) {
//           final retailerList = ref.watch(outletListProviderWithoutDropdown);
//
//           return retailerList.when(
//             data: (outlet) {
//               int coolerNumber = 0;
//
//               for (var val in outlet) {
//                 if (OutletServices.showCoolerIcon(val)) coolerNumber++;
//               }
//               return Consumer(
//                 builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                   final asyncOrderedOutletList = ref.watch(orderedOutletListProvider(saleType));
//                   return asyncOrderedOutletList.when(
//                     data: (orderedOutlets) {
//                       int orderOnCoolerOutlet = 0;
//                       int successfulCall = 0;
//                       List<int> outletIds = [];
//                       for (var element in orderedOutlets) {
//                         outletIds.add(element.id ?? 0);
//                         successfulCall++;
//                       }
//                       for (var val in outlet) {
//                         if (outletIds.contains(val.id)) {
//                           if (OutletServices.showCoolerIcon(val)) orderOnCoolerOutlet++;
//                         }
//                       }
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Spacer(),
//                               DropdownButton<SaleType>(
//                                 value: saleType,
//                                 items: [SaleType.preorder, SaleType.spotSale].map((e) {
//                                   String title = '';
//                                   switch (e) {
//                                     case SaleType.preorder:
//                                       title = 'Pre-order';
//                                     case SaleType.delivery:
//                                       title = 'Delivery';
//                                     case SaleType.spotSale:
//                                       title = 'Sale';
//                                   }
//                                   return DropdownMenuItem<SaleType>(
//                                     value: e,
//                                     child: LangText(
//                                       title,
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (value) {
//                                   if (value == null) return;
//                                   ref.read(dashBoardSaleTypeProvider.notifier).state = value;
//                                 },
//                               ),
//                             ],
//                           ),
//                           strikeRateTile(
//                             totalOutlet: outlet,
//                             preorderOutlet: orderedOutlets,
//                           ),
//                           outletTile(
//                             title: 'Target Outlets',
//                             number: outlet.length,
//                             icons: Target.material_symbols_target,
//                           ),
//                           // outletTile(title: 'Non Bill Outlet number', number: 9),
//                           outletTile(
//                             title: 'Successful Call',
//                             number: successfulCall,
//                             icons: Target.mingcute_target_line,
//                           ),
//                           outletTile(
//                             title: 'Total cooler outlet',
//                             number: coolerNumber,
//                             icons: Icons.kitchen_rounded,
//                           ),
//                           outletTile(
//                             title: 'Cooler outlet order',
//                             number: orderOnCoolerOutlet,
//                             bottomPadding: false,
//                             icons: Icons.kitchen_rounded,
//                           ),
//                         ],
//                       );
//                     },
//                     error: (e, s) => LangText('$e'),
//                     loading: () => const CircularProgressIndicator(),
//                   );
//                 },
//               );
//             },
//             error: (e, s) => LangText('$e'),
//             loading: () => const CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget strikeRateTile({
//     required List<OutletModel> totalOutlet,
//     required List<OutletModel> preorderOutlet,
//   }) {
//     num count = ((preorderOutlet.length * 100) / totalOutlet.length);
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//
//                   Expanded(
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.star_rounded,
//                           color: primary,
//                         ),
//                         5.horizontalSpacing,
//                         LangText('Strike Rate'),
//                       ],
//                     ),
//                   ),
//                   LangText(
//                     (count.isNaN ? 0 : count).toStringAsFixed(1),
//                     isNumber: true,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: bigMediumFontSize + 2,
//                     ),
//                   ),
//                   Text(
//                     '%',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: bigMediumFontSize + 2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         // const SizedBox(height: 4),
//         // Row(
//         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //   children: [
//         //     LangText(
//         //       'Till Date STT:',
//         //       style: TextStyle(color: primary),
//         //     ),
//         //     Row(
//         //       children: [
//         //         LangText(
//         //           (100 - ((preorderOutlet.length * 100) / totalOutlet.length)).toStringAsFixed(1),
//         //           isNumber: true,
//         //           style: TextStyle(color: primary),
//         //         ),
//         //         LangText(
//         //           "%",
//         //           style: TextStyle(color: primary),
//         //         ),
//         //       ],
//         //     ),
//         //   ],
//         // ),
//         4.verticalSpacing,
//       ],
//     );
//   }
//
//   Widget outletTile({
//     required String title,
//     required num number,
//     IconData? icons,
//     bool bottomPadding = true,
//   }) {
//     return Column(
//       children: [
//         Divider(
//           color: const Color(0xffA9ABB0).withValues(alpha: 0.2),
//           height: 1,
//         ),
//         10.verticalSpacing,
//         Row(
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   Icon(
//                     icons ?? Target.outlet,
//                     color: primary,
//                     size: 20,
//                   ),
//                   10.horizontalSpacing,
//                   Expanded(
//                     child: LangText(
//                       title,
//                       style: TextStyle(
//                         fontSize: normalFontSize,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             LangText(
//               '$number',
//               isNumber: true,
//               style: TextStyle(
//                 color: primary,
//                 fontSize: mediumFontSize,
//               ),
//             ),
//           ],
//         ),
//         if (bottomPadding) 10.verticalSpacing,
//       ],
//     );
//   }
// }


class StrikeRateWidget extends StatelessWidget {
  final SaleType saleType;

  const StrikeRateWidget({super.key, required this.saleType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final retailerList = ref.watch(outletListProviderWithoutDropdown);

          return retailerList.when(
            data: (outlet) {
              int coolerNumber = 0;
              for (var val in outlet) {
                if (OutletServices.showCoolerIcon(val)) coolerNumber++;
              }

              return Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final asyncOrderedOutletList =
                  ref.watch(orderedOutletListProvider(saleType));
                  return asyncOrderedOutletList.when(
                    data: (orderedOutlets) {
                      int orderOnCoolerOutlet = 0;
                      int successfulCall = 0;
                      List<int> outletIds = [];
                      for (var element in orderedOutlets) {
                        outletIds.add(element.id ?? 0);
                        successfulCall++;
                      }
                      for (var val in outlet) {
                        if (outletIds.contains(val.id)) {
                          if (OutletServices.showCoolerIcon(val)) {
                            orderOnCoolerOutlet++;
                          }
                        }
                      }

                      // Calculate Strike Rate
                      num strikeRate =
                      ((orderedOutlets.length * 100) / outlet.length);

                      return Column(
                        children: [
                          // -------------------------------
                          // HEADER SECTION (Primary Color)
                          // -------------------------------
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              gradient: primaryGradient,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Title & Dropdown Row
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.analytics_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        LangText(
                                          'Performance',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Custom Dropdown Button
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color:
                                            Colors.white.withOpacity(0.3)),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<SaleType>(
                                          value: saleType,
                                          dropdownColor: primary,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: Colors.white,
                                              size: 18),
                                          isDense: true,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                          items: [
                                            SaleType.preorder,
                                            SaleType.spotSale
                                          ].map((e) {
                                            String title = '';
                                            switch (e) {
                                              case SaleType.preorder:
                                                title = 'Pre-order';
                                              case SaleType.delivery:
                                                title = 'Delivery';
                                              case SaleType.spotSale:
                                                title = 'Sale';
                                            }
                                            return DropdownMenuItem<SaleType>(
                                              value: e,
                                              child: LangText(title),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            if (value == null) return;
                                            ref
                                                .read(dashBoardSaleTypeProvider
                                                .notifier)
                                                .state = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Big Strike Rate Display
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    LangText(
                                      (strikeRate.isNaN ? 0 : strikeRate)
                                          .toStringAsFixed(1),
                                      isNumber: true,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 6, left: 4),
                                      child: Text(
                                        '%',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 6),
                                      child: LangText(
                                        'Strike Rate',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // -------------------------------
                          // BODY SECTION (Details)
                          // -------------------------------
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  icon: Target.material_symbols_target,
                                  title: 'Target Outlets',
                                  value: outlet.length.toString(),
                                  iconColor: Colors.blue,
                                ),
                                _buildDivider(),
                                _buildDetailRow(
                                  icon: Target.mingcute_target_line,
                                  title: 'Successful Call',
                                  value: successfulCall.toString(),
                                  iconColor: Colors.green,
                                ),
                                _buildDivider(),
                                _buildDetailRow(
                                  icon: Icons.kitchen_rounded,
                                  title: 'Total Cooler Outlet',
                                  value: coolerNumber.toString(),
                                  iconColor: Colors.orange,
                                ),
                                _buildDivider(),
                                _buildDetailRow(
                                  icon: Icons.shopping_cart_outlined,
                                  title: 'Cooler Outlet Order',
                                  value: orderOnCoolerOutlet.toString(),
                                  iconColor: Colors.purple,
                                  isLast: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    error: (e, s) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: LangText('$e')),
                    loading: () => _nullData(),
                  );
                },
              );
            },
            error: (e, s) => Padding(
                padding: const EdgeInsets.all(16), child: LangText('$e')),
            loading: () => _nullData(),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LangText(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          LangText(
            value,
            isNumber: true,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withOpacity(0.1),
      indent: 56, // Align with text start
      endIndent: 16,
    );
  }

  Widget _nullData() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: primaryGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              // Title & Dropdown Row
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.analytics_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      LangText(
                        'Performance',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  // Custom Dropdown Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color:
                          Colors.white.withOpacity(0.3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: IgnorePointer(
                        ignoring: true,
                        child: DropdownButton<SaleType>(
                          value: saleType,
                          dropdownColor: primary,
                          icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white,
                              size: 18),
                          isDense: true,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          items: [
                            SaleType.preorder,
                            SaleType.spotSale
                          ].map((e) {
                            String title = '';
                            switch (e) {
                              case SaleType.preorder:
                                title = 'Pre-order';
                              case SaleType.delivery:
                                title = 'Delivery';
                              case SaleType.spotSale:
                                title = 'Sale';
                            }
                            return DropdownMenuItem<SaleType>(
                              value: e,
                              child: Text(title),
                            );
                          }).toList(),
                          onChanged: (value) {

                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Big Strike Rate Display
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  LangText(
                    (0)
                        .toStringAsFixed(1),
                    isNumber: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        bottom: 6, left: 4),
                    child: Text(
                      '%',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding:
                    const EdgeInsets.only(bottom: 6),
                    child: LangText(
                      'Strike Rate',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              _buildDetailRow(
                icon: Target.material_symbols_target,
                title: 'Target Outlets',
                value: "0",
                iconColor: Colors.blue,
              ),
              _buildDivider(),
              _buildDetailRow(
                icon: Target.mingcute_target_line,
                title: 'Successful Call',
                value: "0",
                iconColor: Colors.green,
              ),
              _buildDivider(),
              _buildDetailRow(
                icon: Icons.kitchen_rounded,
                title: 'Total Cooler Outlet',
                value: "0",
                iconColor: Colors.orange,
              ),
              _buildDivider(),
              _buildDetailRow(
                icon: Icons.shopping_cart_outlined,
                title: 'Cooler Outlet Order',
                value: "0",
                iconColor: Colors.purple,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}