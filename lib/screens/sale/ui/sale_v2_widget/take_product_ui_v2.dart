import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/models/sale_summary_model.dart';
import 'package:wings_olympic_sr/reusable_widgets/language_textbox.dart';
import 'package:wings_olympic_sr/screens/sale/model/product_view.dart';
import 'package:wings_olympic_sr/screens/sale/providers/sale_providers.dart';
import 'package:wings_olympic_sr/screens/sale/ui/sale_v2_widget/sku_list_tile.dart';
import '../../../../models/module.dart';
import '../../../../models/outlet_model.dart';
import '../../../../models/products_details_model.dart';
import '../../../../provider/global_provider.dart';
import '../../../../utils/sales_type_utils.dart';
import '../../controller/sale_controller.dart';

class TakeProductUIV2 extends ConsumerStatefulWidget {
  final List<ProductDetailsModel> skus;
  final Map<int, SalesSummaryModel> skuIdWiseSalesSummary;
  final Map<String, dynamic> preOrderData;
  final int totalRetailerCount;
  final bool showOnlySelected;
  final ViewComplexity viewType;

  const TakeProductUIV2({
    Key? key,
    this.saleType = SaleType.preorder,
    required this.skus,
    required this.showOnlySelected,
    required this.skuIdWiseSalesSummary,
    required this.totalRetailerCount,
    required this.preOrderData,
    required this.viewType,
  }) : super(key: key);
  final SaleType saleType;

  @override
  ConsumerState<TakeProductUIV2> createState() => _TakePreorderUIState();
}

class _TakePreorderUIState extends ConsumerState<TakeProductUIV2> {
  late SaleController saleController;

  @override
  void initState() {
    saleController = SaleController(context: context, ref: ref);
    super.initState();
  }

  bool disableForUsingCoupon = false;

  @override
  Widget build(BuildContext context) {
    Module? selectedModule = ref.watch(selectedSalesModuleProvider);

    OutletModel? outlet = ref.watch(selectedRetailerProvider);

    if (widget.skus.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 56),
          LangText('No product available.'),
        ],
      );
    }

    if (selectedModule == null) {
      return SizedBox();
    }
    // AsyncValue<List<ProductDetailsModel>> asyncSkus =
    // widget.saleType == SaleType.preorder ? ref.watch(productListFutureProvider(selectedModule)) : ref.watch(deliveryListFutureProvider(selectedModule));

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AsyncValue<bool> alreadyUseCoupon =
            ref.watch(disableEditForCouponDiscountProvider(outlet!));

        return alreadyUseCoupon.when(
          data: (couponUsed) {
            return IgnorePointer(
              ignoring: couponUsed == true && widget.saleType == SaleType.delivery,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        LangText('No product selected.', textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: widget.skus.length,
                    primary: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      final memoCount = widget.skuIdWiseSalesSummary[widget.skus[i].id]?.memo ?? 0;
                      final bcp = memoCount == 0 ? 0.0 : (memoCount / widget.totalRetailerCount) * 100;
                      final preOrderVolume = widget.preOrderData[widget.skus[i].id.toString()] ?? 0;

                      final tile = SkuListTile(
                        sku: widget.skus[i],
                        saleController: saleController,
                        showPreorderInfo: widget.saleType == SaleType.delivery,
                        saleType: widget.saleType,
                        viewType: widget.viewType,
                        isFirstItem: i == 0,
                        isLastItem: i == widget.skus.length - 1,
                        bcpValue: bcp,
                        preOrderVolume: preOrderVolume,
                        soqVolume: 0,
                      );

                      if (widget.showOnlySelected) {
                        return Consumer(builder: (context, ref, _) {
                          final saleData = ref.watch(saleSkuAmountProvider(widget.skus[i]));

                          if (saleData.qty <= 0) {
                            return SizedBox();
                          }

                          return tile;
                        });
                      }

                      return tile;
                    },
                  ),
                ],
              ),
            );
          },
          error: (e, s) => Text('$e'),
          loading: () => Padding(
            padding: const EdgeInsets.only(top: 100),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
