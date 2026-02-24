import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/screens/sale/ui/sale_v2_widget/take_product_ui_v2.dart';

import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../models/outlet_model.dart';
import '../../../models/sale_summary_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../utils/sales_type_utils.dart';
import '../../sale/controller/sale_controller.dart';
import '../../sale/providers/sale_providers.dart';
import '../../sale/ui/sale_yes_no.dart';

class BeforeDeliveryUI extends ConsumerWidget {
  const BeforeDeliveryUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    OutletModel? outlet = ref.watch(selectedRetailerProvider);
    OutletSaleStatus saleStatus = ref.watch(outletSaleStatusProvider);
    switch (saleStatus) {
      case OutletSaleStatus.inactive:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              LangText(
                'Please select a retailer..',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      case OutletSaleStatus.callStart:
        return SaleYesNoUI(onCallStart: () {
          callStartTime = DateTime.now();
          ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.showSkus;
          SaleController(context: context, ref: ref)
              .getAllSlabPromotionForDelivery(outletId: outlet?.id ?? 0);
        });
      case OutletSaleStatus.showSkus:
        return Consumer(builder: (context, ref, _) {
          final asyncSummaryData = ref.watch(salesSummaryProvider(SaleType.delivery));
          final asyncTotalRetailer = ref.watch(totalRetailerProvider(SaleType.delivery));
          final asyncPreOrderData = ref.watch(preorderPerRetailerProvider);

          return asyncPreOrderData.when(
            data: (preOrderData) {
              return asyncSummaryData.when(
                data: (summaryData) {
                  final skuIdWiseSalesSummary = <int, SalesSummaryModel>{};
                  for (var entry in summaryData.entries) {
                    for (var sum in entry.value) {
                      skuIdWiseSalesSummary[sum.sku.id] = sum;
                    }
                  }

                  return asyncTotalRetailer.when(
                    data: (totalRetailerCount) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // SpecialOffer(),
                              // CasePieceUI(),
                            ],
                          ),
                          Consumer(
                              builder: (context, ref, _) {

                                final selectedModule = ref.watch(selectedSalesModuleProvider);

                                if (selectedModule == null) return const SizedBox();

                                final asyncProductList = ref.watch(deliveryListFutureProvider(selectedModule));
                                final viewType = ref.watch(productViewTypeProvider);

                                return asyncProductList.when(
                                  data: (data) {
                                    return TakeProductUIV2(
                                      saleType: SaleType.delivery,
                                      skus: data,
                                      showOnlySelected: false,
                                      skuIdWiseSalesSummary: skuIdWiseSalesSummary,
                                      totalRetailerCount: totalRetailerCount,
                                      preOrderData: preOrderData,
                                      viewType: viewType,
                                    );
                                  },
                                  error: (err, stack) => const SizedBox(),
                                  loading: () => const CircularProgressIndicator(),
                                );

                              }
                          ),
                        ],
                      );
                    },
                    error: (error, stck) => const SizedBox(),
                    loading: () => const SizedBox(),
                  );
                },
                error: (error, stck) => const SizedBox(),
                loading: () => const SizedBox(),
              );
            },
            error: (error, stck) => const SizedBox(),
            loading: () => const SizedBox(),
          );
        });
      default:
        return Container();
    }
  }
}
