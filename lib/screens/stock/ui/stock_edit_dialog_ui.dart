import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';

import '../../../models/products_details_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/asset_download/asset_service.dart';
import '../../../services/sync_read_service.dart';
import '../../../utils/case_piece_type_utils.dart';
import '../../sale/ui/case_piece_ui.dart';
import '../../sale/ui/sku_case_piece_show_widget.dart';
import '../controller/stocks_controller.dart';

class StockEditDialogUI extends ConsumerStatefulWidget {
  StockEditDialogUI(
    this.sku,
    this.globalWidgets,
    this.slug,
    this.preorderMessage, {
    Key? key,
    this.idealStock,
  }) : super(key: key);
  ProductDetailsModel sku;
  GlobalWidgets globalWidgets;
  String slug;
  String preorderMessage;
  final int? idealStock;

  @override
  _StockEditDialogUIState createState() => _StockEditDialogUIState();
}

class _StockEditDialogUIState extends ConsumerState<StockEditDialogUI> {
  late StockController stockController;
  TextEditingController stockEditController = TextEditingController();

  @override
  void dispose() {
    stockEditController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    stockController = StockController(context: context, ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    String lang = ref.watch(languageProvider);
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 3.w,
              right: 3.w,
              bottom: 1.h,
              top: 2.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  height: 10.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 17.w,
                            child: AssetService(context).superImage(
                              '${widget.sku.id}.png',
                              folder: "SKU",
                              version:
                                  SyncReadService().getAssetVersion("SKU"),
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          SizedBox(
                            width: 10.w,
                            child: LangText(
                              widget.sku.shortName,
                              style: TextStyle(
                                  fontSize: 8.sp,
                                  color: redDeep,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  /// removing
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  stockController.removingStock(
                                    widget.sku,
                                    ref.read(productStockEditProvider(widget.sku)),
                                    widget.sku.increasedId,
                                    stockEditIsOpen: true,
                                  );
                                },
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  left: 8,
                                  right: 0,
                                  bottom: 8,
                                ),
                                icon: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.sp),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [green, darkGreen],
                                    ),
                                  ),
                                  child: Icon(Icons.remove,
                                      color: Colors.white, size: 17.sp),
                                ),
                              ),
                              Center(
                                child: SizedBox(
                                  width: 18.w,
                                  child: Consumer(builder: (context, ref, _) {
                                    StockModel stocks =
                                        ref.watch(productStockEditProvider(widget.sku));
                                    SkuUnitItem? selectedUnit = ref.watch(selectedSkuUnitConfigProvider(widget.sku));
                                    int packSize = selectedUnit?.packSize ?? 1;
                                    
                                    // Calculate display value: if pack_size > 1, show in packs, else show pieces
                                    int displayValue = packSize > 1 
                                      ? (stocks.liftingStock / packSize).floor() 
                                      : stocks.liftingStock;
                                    stockEditController.text = displayValue.toString();
                                    
                                    return Column(
                                      children: [
                                        TextFormField(
                                          enabled: false,
                                          controller: stockEditController,
                                          decoration: InputDecoration(
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.2.w,
                                                    style: BorderStyle.solid)),
                                            isDense: true,
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.2.w,
                                                    style: BorderStyle.solid)),
                                          ),
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]*')),
                                            TextInputFormatter.withFunction(
                                              (oldValue, newValue) =>
                                                  newValue.copyWith(
                                                text: newValue.text
                                                    .replaceAll('.', ','),
                                              ),
                                            ),
                                          ],
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              color: darkGrey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: lang == 'en'
                                                  ? englishFont
                                                  : banglaFont),
                                          onChanged: (_) {
                                            if (stockEditController.text.isEmpty) {
                                              stockEditController.text = "0";
                                              FocusScope.of(context).requestFocus(FocusNode());
                                            }
                                          },
                                        ),
                                        SKUCasePieceShowWidget(
                                          sku: widget.sku,
                                          qty: stocks.liftingStock,
                                          showUnitName: true,
                                          qtyTextStyle: TextStyle(fontSize: 8.sp, color: darkGrey, fontWeight: FontWeight.bold),
                                          unitTextStyle: TextStyle(fontSize: 8.sp, color: darkGrey),
                                        ),
                                        if(widget.idealStock != null && widget.idealStock! > 0)
                                          Row(
                                            children: [
                                              LangText(
                                                'Ideal: ',
                                                style: TextStyle(fontSize: 7.sp, color: Colors.grey),
                                              ),
                                              LangText(
                                                (widget.idealStock).toString(),
                                                style: TextStyle(fontSize: 7.sp, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  /// adding
                                  try {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    stockController.addingStock(
                                      widget.sku,
                                      ref.read(productStockEditProvider(widget.sku)),
                                      widget.sku.increasedId,
                                      stockEditIsOpen: true,
                                    );
                                  } catch (e, t) {
                                    debugPrint("Error is :::");
                                    debugPrint(e.toString());
                                    debugPrint(t.toString());
                                  }
                                },
                                padding: const EdgeInsets.only(
                                    top: 8, left: 0, right: 8, bottom: 8),
                                icon: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.sp),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [green, darkGreen],
                                    ),
                                  ),
                                  child: Icon(Icons.add,
                                      color: Colors.white, size: 17.sp),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                CasePieceUI(sku: widget.sku),
                SizedBox(
                  height: 1.h,
                ),

                /// Packet with buttons container
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.sp),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [red3, red3],
                    ),
                  ),
                  child: Consumer(
                      builder: (context,ref,_) {
                        SkuUnitItem? selectedUnit = ref.watch(selectedSkuUnitConfigProvider(widget.sku));
                        int addedAmount = selectedUnit?.packSize ?? 1;
                        return Row(
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                plusButton(multiply: 1, addedAmount: addedAmount),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                plusButton(multiply: 5, addedAmount: addedAmount),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                plusButton(multiply: 10, addedAmount: addedAmount),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                plusButton(multiply: 20, addedAmount: addedAmount),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                plusButton(multiply: 50, addedAmount: addedAmount),
                              ]),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                removeButton(multiply: 1, addedAmount: addedAmount),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                removeButton(multiply: 5, addedAmount: addedAmount),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                removeButton(multiply: 10, addedAmount: addedAmount),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                removeButton(multiply: 20, addedAmount: addedAmount),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                removeButton(multiply: 50, addedAmount: addedAmount),
                              ]),
                            ),
                            SizedBox(
                              height: 2.h,
                            )
                          ],
                        );
                      }
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),

                /// last day, ADS, SDLW
                Consumer(builder: (context, ref, _) {
                  AsyncValue<Map<String, dynamic>> asyncStockAnalyticData =
                      ref.watch(stockAnalyticProvider(widget.sku.id));
                  return asyncStockAnalyticData.when(
                      data: (stockAnalyticData) {
                        if (stockAnalyticData.isEmpty) {
                          return Container();
                        }
                        return DefaultTextStyle(
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: normalFontSize,
                              fontWeight: FontWeight.bold),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: orange,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [orange, orange],
                              ),
                              borderRadius: BorderRadius.circular(7.sp),
                              // border: Border.all(color: or)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LangText("Last Sale"),
                                    LangText("ADS"),
                                    LangText("SDLW"),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    LangText(
                                      stockAnalyticData["last_sale"] == null
                                          ? 'N/A'
                                          : stockAnalyticData["last_sale"]
                                              .toString(),
                                    ),
                                    LangText(
                                      stockAnalyticData["ads"] == null
                                          ? 'N/A'
                                          : stockAnalyticData["ads"].toString(),
                                    ),
                                    LangText(
                                      stockAnalyticData["sdlw"] == null
                                          ? 'N/A'
                                          : stockAnalyticData["sdlw"]
                                              .toString(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      error: (error, _) => Container(),
                      loading: () => const CircularProgressIndicator());
                }),
                SizedBox(
                  height: 1.h,
                ),
                Visibility(
                    visible: widget.preorderMessage.isNotEmpty,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LangText(
                            widget.preorderMessage,
                            isNumber: true,
                            style: const TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          LangText('items has preorder',
                              style: const TextStyle(color: Colors.red))
                        ],
                      ),
                    )),
                SizedBox(
                  height: 1.5.h,
                ),
                Center(
                  child: Container(
                    width: 40.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.sp),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [green, darkGreen],
                      ),
                    ),
                    child: ElevatedButton(
                        onPressed: () async {
                          int stockPrev = ref
                              .read(productStockProvider(widget.sku))
                              .liftingStock;
                          await stockController.inputFormatting(
                              widget.sku, stockEditController);
                          StockController(ref: ref, context: context)
                              .saveStockEditDialog(widget.sku, stockPrev);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                        child: SizedBox(
                          width: 35.w,
                          height: 5.h,
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.save_outlined,
                                  color: Colors.white,
                                  size: 10.sp,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Center(
                                  child: LangText(
                                    'Save',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: 0.h,
              right: 0.w,
              child: IconButton(
                onPressed: () {
                  ref.refresh(productStockEditProvider(widget.sku));
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 13.sp,
                ),
              ))
        ],
      ),
    );
  }

  Widget plusButton({required int multiply, required int addedAmount}) {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        StockModel stocks =
            stockController.inputFormatting(widget.sku, stockEditController);
        stockController.addSpecificAmountOfStock(
            widget.sku, stocks, multiply, multiply * addedAmount,
            stockEditIsOpen: true);
      },
      child: Container(
        // width: 11.w,
        height: 3.5.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.sp), color: Colors.white),
        child: Center(
            child: LangText(
          multiply.toString(),
          isNum: false,
          isNumber: true,
        )),
      ),
    );
  }

  Widget removeButton({required int multiply, required int addedAmount}) {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        StockModel stocks =
            stockController.inputFormatting(widget.sku, stockEditController);
        stockController.removeSpecificAmountOfStock(
            widget.sku, stocks, multiply, multiply * addedAmount,
            stockEditIsOpen: true);
      },
      child: Container(
        // width: 11.w,
        height: 3.5.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.sp), color: Colors.white),
        child: Center(
            child: LangText(
                ('-${multiply.toString()}').toString(),
                isNumber: true,
                isNum: false)),
      ),
    );
  }
}
