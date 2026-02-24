import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/products_details_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/asset_download/asset_service.dart';
import '../../../services/sync_read_service.dart';
import '../../sale/providers/sale_providers.dart';
import '../controller/stocks_controller.dart';

class StockSkuWidget extends ConsumerStatefulWidget {
  final ProductDetailsModel sku;
  final bool enableFilter;
  const StockSkuWidget({super.key, required this.sku, this.enableFilter = false,});

  @override
  ConsumerState<StockSkuWidget> createState() => _StockSkuWidgetState();
}

class _StockSkuWidgetState extends ConsumerState<StockSkuWidget> {
  final globalWidgets = GlobalWidgets();
  late StockController stockController;

  @override
  void initState() {

    stockController = StockController(context: context, ref: ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String slug = widget.sku.slug;
    String increasedId = widget.sku.increasedId;

    AsyncValue<Map<String, int>> asyncPreorderStock = ref.watch(preorderProvider);
    StockModel stocks = ref.watch(productStockProvider(widget.sku));
    final selectedClassification = ref.watch(selectedClassificationProvider);

    if (widget.enableFilter && selectedClassification?.id == -1 && stocks.liftingStock == 0) {
      return SizedBox();
    }
    return asyncPreorderStock.when(
      data: (preorderStock) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 12.5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.sp),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 0.5,
                      blurRadius: 5,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                StockController(context: context, ref: ref)
                                    .openStockDialog(widget.sku, preorderStock, slug, globalWidgets);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(70),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    padding: EdgeInsets.all(2),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(70),
                                      child: AssetService(context).superImage(
                                        '${widget.sku.id}.png',
                                        folder: 'SKU',
                                        version: SyncReadService().getAssetVersion('SKU'),
                                        height: 60,
                                        width: 60,
                                        circular: true,
                                        // fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0.w,
                                    top: 0.5.h,
                                    child: Consumer(
                                      builder: (context, ref, _) {
                                        AsyncValue<int?> asyncSkuCount =
                                        ref.watch(stockAllocationProvider(widget.sku.id));
                                        String lang = ref.watch(languageProvider);

                                        return asyncSkuCount.when(
                                          data: (skuCount) {
                                            if (skuCount == null) {
                                              return Container();
                                            }
                                            return globalWidgets.customChip(
                                              text: globalWidgets.numberEnglishToBangla(
                                                  num: skuCount.toString(), lang: lang),
                                              color: Colors.red,
                                            );
                                          },
                                          error: (error, _) => Container(),
                                          loading: () => Container(),
                                        );
                                      },
                                    ),
                                  ),

                                  ///issue here
                                  // Positioned(
                                  //   right: 0.5.w,
                                  //   bottom: 0.5.h,
                                  //   child: Consumer(
                                  //     builder: (context, ref, _) {
                                  //       int skuCount = ref.watch(
                                  //           selectedStockSkuCount(sku));
                                  //       String lang =
                                  //           ref.watch(languageProvider);
                                  //
                                  //       return globalWidgets.customChip(
                                  //         text: globalWidgets
                                  //             .numberEnglishToBangla(
                                  //                 num: skuCount.toString(),
                                  //                 lang: lang),
                                  //         color: Colors.blue,
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: LangText(
                                widget.sku.shortName,
                                style: TextStyle(
                                  fontSize: 8.5.sp,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Consumer(builder: (context, ref, _) {
                          StockModel stocks = ref.watch(productStockProvider(widget.sku));
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              /// removing
                                              stockController.removingStock(
                                                  widget.sku, stocks, increasedId);
                                            },
                                            padding: const EdgeInsets.only(
                                                top: 8, left: 8, right: 0, bottom: 8),
                                            icon: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: primary,
                                              ),
                                              child: Icon(Icons.remove,
                                                  color: Colors.white, size: 15.sp),
                                            ),
                                          ),
                                          Expanded(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: InkWell(
                                                      onTap: () {
                                                        StockController(context: context, ref: ref)
                                                            .openStockDialog(widget.sku, preorderStock, slug,
                                                            globalWidgets,
                                                            idealStock: widget.sku.stocks.ideaStock);
                                                      },
                                                      child: LangText(
                                                        stocks.liftingStock.toString(),
                                                        isNumber: true,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: darkGrey,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  if (widget.sku.stocks.ideaStock != null &&
                                                      widget.sku.stocks.ideaStock! > 0)
                                                    Row(
                                                      children: [
                                                        LangText(
                                                          widget.sku.stocks.ideaStock.toString(),
                                                          style: TextStyle(fontSize: 8.sp),
                                                        ),
                                                      ],
                                                    ),
                                                  // Consumer(builder: (context, ref, _) {
                                                  //   int skuCount = ref.watch(selectedStockSkuCount(sku));
                                                  //   String lang = ref.watch(languageProvider);
                                                  //
                                                  //   return globalWidgets.customChip(
                                                  //       text:
                                                  //       globalWidgets.numberEnglishToBangla(num: sku.stocks.ideaStock.toString(), lang: lang),
                                                  //       color: green,
                                                  //       fontSize:7.sp);
                                                  // })
                                                ],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              /// adding
                                              stockController.addingStock(
                                                  widget.sku, stocks, increasedId);
                                            },
                                            padding: const EdgeInsets.only(
                                                top: 8, left: 0, right: 8, bottom: 8),
                                            icon: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: primary,
                                              ),
                                              child: Icon(Icons.add,
                                                  color: Colors.white, size: 15.sp),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    preorderStock.containsKey(widget.sku.id.toString())
                                        ? Container(
                                      height: 3.h,
                                      width: 30.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(50.sp),
                                              topLeft: Radius.circular(50.sp)),
                                          color: lightBlue),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.note_alt_outlined,
                                              color: purple,
                                              size: 10.sp,
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            LangText(
                                              '${preorderStock[widget.sku.id.toString()]}',
                                              isNumber: true,
                                              style: TextStyle(
                                                  color: darkGrey, fontSize: 10.sp),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                        : SizedBox()
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: LangText(
                                    stocks.currentStock.toString(),
                                    isNumber: true,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: darkGrey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, _) {
        print('inside Stock UI preorder error $error');
        return Container();
      },
      loading: () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.5.h),
        child: Container(
          height: 12.5.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.sp),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0.5,
                blurRadius: 5,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
        ),
      ),
    );
  }
}
