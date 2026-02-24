import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/general_id_slug_model.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../utils/icons/target_icons.dart';
import '../../../utils/sales_type_utils.dart';

// class StatisticsWidget extends StatelessWidget {
//   final SaleType saleType;
//
//   const StatisticsWidget({super.key, required this.saleType});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (BuildContext context, WidgetRef ref, Widget? child) {
//         final retailerList = ref.watch(outletListProviderWithoutDropdown);
//         return retailerList.when(
//           data: (outlet) {
//             return Consumer(
//               builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                 final preorderRetailerList = ref.watch(orderedOutletListProvider(saleType));
//                 return preorderRetailerList.when(
//                   data: (orderedOutlets) {
//                     return Column(
//                       children: [
//                         Row(
//                           children: [
//                             statisticsTile(title: 'Total Outlet', number: outlet.length),
//                             16.horizontalSpacing,
//                             statisticsTile(
//                               title: 'Non Visited Outlet',
//                               number: outlet.length - orderedOutlets.length,
//                               icon: Icons.hourglass_top_rounded,
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Consumer(
//                               builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                                 AsyncValue<List> zeroSell = ref.watch(unsoldOutlets);
//                                 List<int> zeroSoledOutletIds = [];
//
//                                 return zeroSell.when(
//                                   data: (zeroS) {
//                                     for (var val in zeroS) {
//                                       if (!zeroSoledOutletIds.contains(val['outlet_id'])) {
//                                         zeroSoledOutletIds.add(val['outlet_id']);
//                                       }
//                                     }
//                                     return statisticsTile(
//                                       title: 'No Order Outlet',
//                                       number: zeroSoledOutletIds.length,
//                                       icon: Icons.error_outline_rounded,
//                                     );
//                                   },
//                                   error: (e, s) => LangText('$e'),
//                                   loading: () => const CircularProgressIndicator(),
//                                 );
//                               },
//                             ),
//                             16.horizontalSpacing,
//                             Consumer(
//                               builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                                 final inside25m = ref.watch(allOutletLastGeoProvider(true));
//
//                                 return inside25m.when(
//                                   data: (inside) {
//                                     return statisticsTile(
//                                       title: 'Within 25m Outlet',
//                                       number: inside,
//                                       icon: Icons.location_searching_rounded,
//                                     );
//                                   },
//                                   error: (e, s) => LangText('$e'),
//                                   loading: () => const CircularProgressIndicator(),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Consumer(
//                               builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                                 AsyncValue<int> inside25m =
//                                     ref.watch(allOutletLastGeoProvider(false));
//
//                                 return inside25m.when(
//                                   data: (inside) {
//                                     return statisticsTile(
//                                       title: 'Out of 25m outlet',
//                                       number: inside,
//                                       icon: Icons.location_disabled_rounded,
//                                     );
//                                   },
//                                   error: (e, s) => LangText('$e'),
//                                   loading: () => const CircularProgressIndicator(),
//                                 );
//                               },
//                             ),
//                             16.horizontalSpacing,
//                             const Expanded(child: SizedBox())
//                           ],
//                         ),
//                       ],
//                     );
//                   },
//                   error: (e, s) => LangText('$e'),
//                   loading: () => const CircularProgressIndicator(),
//                 );
//               },
//             );
//           },
//           error: (e, s) => LangText('$e'),
//           loading: () => const CircularProgressIndicator(),
//         );
//       },
//     );
//   }
//
//   Widget statisticsTile({required String title, required num number, IconData? icon}) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: const BorderRadius.all(Radius.circular(8)),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withValues(alpha: 0.2),
//               spreadRadius: 1,
//               blurRadius: 2,
//               offset: const Offset(0, 2), // changes position of shadow
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//         margin: const EdgeInsets.only(bottom: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   icon ?? Target.outlet,
//                   color: primary,
//                   size: 20,
//                 ),
//                 10.horizontalSpacing,
//                 Expanded(
//                   child: Stack(
//                     alignment: Alignment.centerLeft,
//                     children: [
//                       LangText(
//                         title,
//                         maxLine: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(fontSize: normalFontSize),
//                       ),
//                       LangText(
//                         '-\n-',
//                         maxLine: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: normalFontSize,
//                           color: Colors.transparent,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             LangText(
//               '$number',
//               isNumber: true,
//               style: TextStyle(
//                 fontSize: largeFontSize,
//                 color: primary,
//                 fontWeight: FontWeight.bold,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class StatisticsWidget extends StatelessWidget {
  final SaleType saleType;

  const StatisticsWidget({super.key, required this.saleType});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final retailerList = ref.watch(outletListProviderWithoutDropdown);
        return retailerList.when(
          data: (outlet) {
            return Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final preorderRetailerList =
                ref.watch(orderedOutletListProvider(saleType));
                return preorderRetailerList.when(
                  data: (orderedOutlets) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            statisticsTile(
                              title: 'Total Outlet',
                              number: outlet.length,
                              icon: Icons.store_mall_directory_rounded,
                              color: Colors.blue,
                            ),
                            12.horizontalSpacing,
                            statisticsTile(
                              title: 'Non Visited',
                              number: outlet.length - orderedOutlets.length,
                              icon: Icons.hourglass_top_rounded,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                        12.verticalSpacing,
                        Row(
                          children: [
                            Consumer(
                              builder: (BuildContext context, WidgetRef ref,
                                  Widget? child) {
                                AsyncValue<List> zeroSell =
                                ref.watch(unsoldOutlets);
                                List<int> zeroSoledOutletIds = [];

                                return zeroSell.when(
                                  data: (zeroS) {
                                    for (var val in zeroS) {
                                      if (!zeroSoledOutletIds.contains(val['outlet_id'])) {
                                        zeroSoledOutletIds.add(val['outlet_id']);
                                      }
                                    }
                                    return statisticsTile(
                                      title: 'No Order',
                                      number: zeroSoledOutletIds.length,
                                      icon: Icons.remove_shopping_cart_rounded,
                                      color: Colors.red,
                                    );
                                  },
                                  error: (e, s) => Container(),
                                  loading: () =>
                                      statisticsTile(
                                        title: 'No Order',
                                        number: zeroSoledOutletIds.length,
                                        icon: Icons.remove_shopping_cart_rounded,
                                        color: Colors.red,
                                      ),
                                );
                              },
                            ),
                            12.horizontalSpacing,
                            Consumer(
                              builder: (BuildContext context, WidgetRef ref,
                                  Widget? child) {
                                final inside25m =
                                ref.watch(allOutletLastGeoProvider(true));

                                return inside25m.when(
                                  data: (inside) {
                                    return statisticsTile(
                                      title: 'Within 25m',
                                      number: inside,
                                      icon: Icons.my_location_rounded,
                                      color: Colors.green,
                                    );
                                  },
                                  error: (e, s) => Container(),
                                  loading: () => statisticsTile(
                                    title: 'Within 25m',
                                    number: 0,
                                    icon: Icons.my_location_rounded,
                                    color: Colors.green,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        12.verticalSpacing,
                        Row(
                          children: [
                            Consumer(
                              builder: (BuildContext context, WidgetRef ref,
                                  Widget? child) {
                                AsyncValue<int> inside25m =
                                ref.watch(allOutletLastGeoProvider(false));

                                return inside25m.when(
                                  data: (inside) {
                                    return statisticsTile(
                                      title: 'Out of 25m',
                                      number: inside,
                                      icon: Icons.location_disabled_rounded,
                                      color: Colors.purple,
                                    );
                                  },
                                  error: (e, s) => Container(),
                                  loading: () => statisticsTile(
                                    title: 'Out of 25m',
                                    number: 0,
                                    icon: Icons.location_disabled_rounded,
                                    color: Colors.purple,
                                  ),
                                );
                              },
                            ),
                            12.horizontalSpacing,
                            const Expanded(child: SizedBox())
                          ],
                        ),
                        16.verticalSpacing,
                      ],
                    );
                  },
                  error: (e, s) => LangText('$e'),
                  loading: () => nullWidget(),
                );
              },
            );
          },
          error: (e, s) => LangText('$e'),
          loading: () => nullWidget(),
        );
      },
    );
  }

  Widget statisticsTile({
    required String title,
    required num number,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LangText(
                    '$number',
                    isNumber: true,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LangText(
                    title,
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nullWidget() {
    return Column(
      children: [
        Row(
          children: [
            statisticsTile(
              title: 'Total Outlet',
              number: 0,
              icon: Icons.store_mall_directory_rounded,
              color: Colors.blue,
            ),
            12.horizontalSpacing,
            statisticsTile(
              title: 'Non Visited',
              number: 0,
              icon: Icons.hourglass_top_rounded,
              color: Colors.orange,
            ),
          ],
        ),
        12.verticalSpacing,
        Row(
          children: [
            statisticsTile(
              title: 'No Order',
              number: 0,
              icon: Icons.remove_shopping_cart_rounded,
              color: Colors.red,
            ),
            12.horizontalSpacing,
            statisticsTile(
              title: 'Within 25m',
              number: 0,
              icon: Icons.my_location_rounded,
              color: Colors.green,
            ),
          ],
        ),
        12.verticalSpacing,
        Row(
          children: [
            statisticsTile(
              title: 'Out of 25m',
              number: 0,
              icon: Icons.location_disabled_rounded,
              color: Colors.purple,
            ),
            12.horizontalSpacing,
            const Expanded(child: SizedBox())
          ],
        ),
        16.verticalSpacing,
      ],
    );
  }
}
