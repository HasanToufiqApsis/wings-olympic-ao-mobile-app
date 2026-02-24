import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/products_details_model.dart';
import '../../../models/sales/sale_data_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/asset_download/asset_service.dart';
import '../../../services/sync_read_service.dart';
import '../../../utils/case_piece_type_utils.dart';
import '../../../utils/sales_type_utils.dart';
import '../controller/sale_controller.dart';
import 'case_piece_ui.dart';
import 'sku_case_piece_show_widget.dart';

class PreorderEditDialogUI extends ConsumerStatefulWidget {
  PreorderEditDialogUI( this.sku, this.globalWidgets, {this.saleType = SaleType.preorder,Key? key}) : super(key: key);
  ProductDetailsModel sku;
  GlobalWidgets globalWidgets;
  SaleType saleType;
  @override
  _PreorderEditDialogUIState createState() => _PreorderEditDialogUIState();
}

class _PreorderEditDialogUIState extends ConsumerState<PreorderEditDialogUI> {
  late SaleController salesController;
  TextEditingController preorderEditController = TextEditingController();
  @override
  void dispose() {
    preorderEditController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    salesController = SaleController(context: context, ref: ref);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SaleDataModel saleData = ref.read(saleSkuAmountProvider(widget.sku));
      ref.read(saleEditSkuAmountProvider(widget.sku).notifier).state = saleData;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String lang = ref.watch(languageProvider);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 1.h, top: 2.h),
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
                          child: AssetService(context).superImage('${widget.sku.id}.png', folder: "SKU", version: SyncReadService().getAssetVersion("SKU")),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        SizedBox(
                          width: 10.w,
                          child: LangText(
                            widget.sku.shortName,
                            style: TextStyle(fontSize: 8.sp, color: red3, fontWeight: FontWeight.bold),
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
                              onPressed: () async {
                                // FocusScope.of(context).requestFocus(FocusNode());
                                // salesController.decrement(widget.sku, edit: true);

                                SkuUnitItem? selectedUnit = ref.watch(selectedSkuUnitConfigProvider(widget.sku));
                                int addedAmount = selectedUnit?.packSize ?? 1;
                                FocusScope.of(context).requestFocus(FocusNode());
                                salesController.removeSpecificAmountOfSales(widget.sku, 1, addedAmount);
                              },
                              padding: const EdgeInsets.only(top: 8, left: 8, right: 0, bottom: 8),
                              icon: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.sp),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [green, darkGreen],
                                  ),
                                ),
                                child: Icon(Icons.remove, color: Colors.white, size: 17.sp),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: 18.w,
                                // height: 15.h,
                                child: Consumer(builder: (context, ref, _) {
                                  SaleDataModel preorderEdit = ref.watch(saleEditSkuAmountProvider(widget.sku));
                                  SkuUnitItem? selectedUnit = ref.watch(selectedSkuUnitConfigProvider(widget.sku));
                                  int packSize = selectedUnit?.packSize ?? 1;
                                  
                                  // Calculate display value: if pack_size > 1, show in packs, else show pieces
                                  int displayValue = packSize > 1 
                                    ? (preorderEdit.qty / packSize).floor() 
                                    : preorderEdit.qty;
                                  preorderEditController.text = displayValue.toString();
                                  
                                  return Column(
                                    children: [
                                      TextFormField(
                                        controller: preorderEditController,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.2.w, style: BorderStyle.solid)),
                                          isDense: true,
                                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.2.w, style: BorderStyle.solid)),
                                        ),
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]*')),
                                          TextInputFormatter.withFunction(
                                                (oldValue, newValue) => newValue.copyWith(
                                              text: newValue.text.replaceAll('.', ','),
                                            ),
                                          ),
                                        ],
                                        style: TextStyle(fontSize: 15.sp, color: darkGrey, fontWeight: FontWeight.bold, fontFamily: lang == 'en' ? englishFont : banglaFont),
                                        onChanged: (_) {
                                          if (preorderEditController.text.isEmpty) {
                                            preorderEditController.text = "0";
                                            salesController.bulkInsertOfSales(widget.sku, 0, widget.saleType);
                                            FocusScope.of(context).requestFocus(FocusNode());
                                          } else {
                                            final count = int.parse(preorderEditController.text);
                                            bool? editable = salesController.bulkInsertOfSales(widget.sku, count, widget.saleType);
                                            if(editable == false) {
                                              preorderEditController.text = removeLastChar(preorderEditController.text);
                                            }
                                          }
                                        },
                                      ),
                                      SKUCasePieceShowWidget(
                                        sku: widget.sku,
                                        qty: preorderEdit.qty,
                                        showUnitName: true,
                                        qtyTextStyle: TextStyle(fontSize: 8.sp, color: darkGrey, fontWeight: FontWeight.bold),
                                        unitTextStyle: TextStyle(fontSize: 8.sp, color: darkGrey),
                                      )
                                    ],
                                  );
                                }),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                // FocusScope.of(context).requestFocus(FocusNode());
                                // salesController.increment(widget.sku, edit: true, saleType: widget.saleType);

                                SkuUnitItem? selectedUnit = ref.watch(selectedSkuUnitConfigProvider(widget.sku));
                                int addedAmount = selectedUnit?.packSize ?? 1;
                                FocusScope.of(context).requestFocus(FocusNode());
                                salesController.addSpecificAmountOfSales(widget.sku, 1, addedAmount, widget.saleType);
                              },
                              padding: const EdgeInsets.only(top: 8, left: 0, right: 8, bottom: 8),
                              icon: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.sp),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [green, darkGreen],
                                  ),
                                ),
                                child: Icon(Icons.add, color: Colors.white, size: 17.sp),
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
              // if(widget.saleType == SaleType.delivery)const CasePieceUI(),
              CasePieceUI(sku: widget.sku),
              SizedBox(
                height: 1.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
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
                        SkuUnitItem? selectedUnit = ref.read(selectedSkuUnitConfigProvider(widget.sku));
                        String countString = preorderEditController.text.isNotEmpty ? preorderEditController.text : "0";
                        int count = int.tryParse(countString) ?? 0;
                        int multiplier = selectedUnit?.packSize ?? 1;
                        count = count * multiplier;
                        await salesController.saveEditedPreorder(widget.sku, count);
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
                                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
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
              onPressed: () async {
                // await salesController.preorderInputFormatting(widget.sku, preorderEditController, widget.onHand??' -');
                FocusScope.of(context).requestFocus(FocusNode());
                SaleDataModel saleData = ref.read(saleSkuAmountProvider(widget.sku));
                int amount = saleData.qty;
                ref.read(saleEditSkuAmountProvider(widget.sku).notifier).setState(amount);

                Navigator.pop(context);
              },
              icon: Icon(
                Icons.cancel_outlined,
                color: Colors.red,
                size: 13.sp,
              ),
            ))
      ],
    );
  }

  Widget plusButton({required int multiply, required int addedAmount}) {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        salesController.addSpecificAmountOfSales(widget.sku, multiply, addedAmount, widget.saleType);
      },
      child: Container(
        // width: 11.w,
        height: 3.5.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.sp), color: Colors.white),
        // child: Center(child: LangText((multiply * addedAmount).toString(), isNum: false, isNumber: true)),
        child: Center(child: LangText(multiply.toString(), isNum: false, isNumber: true)),
      ),
    );
  }

  Widget removeButton({required int multiply, required int addedAmount}) {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        salesController.removeSpecificAmountOfSales(widget.sku, multiply, addedAmount);
      },
      child: Container(
        // width: 11.w,
        height: 3.5.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.sp), color: Colors.white),
        child: Center(
            child: LangText(
              // ('-${(multiply * addedAmount).toString()}').toString(),
              ('-${multiply.toString()}').toString(),
              isNumber: true,
              isNum: false,
            )),
      ),
    );
  }

  String removeLastChar(String input) {
    if (input.isEmpty) return input;
    return input.substring(0, input.length - 1);
  }
}

// class PreorderEditDialogUI extends ConsumerStatefulWidget {
//   PreorderEditDialogUI(this.sku, this.globalWidgets, {this.saleType = SaleType.preorder, Key? key}) : super(key: key);
//   ProductDetailsModel sku;
//   GlobalWidgets globalWidgets;
//   SaleType saleType;
//
//   @override
//   _PreorderEditDialogUIState createState() => _PreorderEditDialogUIState();
// }
//
// class _PreorderEditDialogUIState extends ConsumerState<PreorderEditDialogUI> {
//   late SaleController salesController;
//   TextEditingController preorderEditController = TextEditingController();
//
//   @override
//   void dispose() {
//     preorderEditController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     salesController = SaleController(context: context, ref: ref);
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       SaleDataModel saleData = ref.read(saleSkuAmountProvider(widget.sku));
//       ref.read(saleEditSkuAmountProvider(widget.sku).notifier).state = saleData;
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String lang = ref.watch(languageProvider);
//     return Stack(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 1.h, top: 2.h),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                 height: 1.h,
//               ),
//               SizedBox(
//                 height: 10.h,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         SizedBox(
//                           width: 17.w,
//                           child: AssetService(context).superImage('${widget.sku.id}.png', folder: "SKU", version: SyncReadService().getAssetVersion("SKU")),
//                           // Stack(
//                           //   children: [
//                           //     AssetService(context).superImage('${widget.sku.id}.png', folder: "SKU", version: SyncReadService().getAssetVersion("SKU")),
//                           //     Positioned(
//                           //       right: 0,
//                           //       bottom: 0,
//                           //       child: Consumer(builder: (context, ref, _) {
//                           //
//                           //         int skuCount = ref.watch(
//                           //             selectedPreorderSkuEditCount(widget.sku));
//                           //
//                           //         String lang = ref.watch(languageProvider);
//                           //         return widget.globalWidgets.customChip(text: widget.globalWidgets.numberEnglishToBangla(num: skuCount.toString(), lang: lang), color: blue3);
//                           //       }),
//                           //     )
//                           //   ],
//                           // ),
//                         ),
//                         SizedBox(
//                           width: 1.w,
//                         ),
//                         SizedBox(
//                           width: 10.w,
//                           child: LangText(
//                             widget.sku.shortName,
//                             style: TextStyle(fontSize: 8.sp, color: blue3, fontWeight: FontWeight.bold),
//                           ),
//                         )
//                       ],
//                     ),
//                     Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               onPressed: () async {
//                                 /// removing
//                                 FocusScope.of(context).requestFocus(FocusNode());
//                                 salesController.decrement(
//                                   widget.sku,
//                                   edit: true,
//                                   casePieceType: widget.saleType == SaleType.preorder ? null : CasePieceType.PIECE,
//                                 );
//                               },
//                               padding: const EdgeInsets.only(top: 8, left: 8, right: 0, bottom: 8),
//                               icon: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5.sp),
//                                   gradient: LinearGradient(
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                     colors: [green, darkGreen],
//                                   ),
//                                 ),
//                                 child: Icon(Icons.remove, color: Colors.white, size: 17.sp),
//                               ),
//                             ),
//                             Center(
//                               child: SizedBox(
//                                 width: 18.w,
//                                 // height: 15.h,
//                                 child: Consumer(builder: (context, ref, _) {
//                                   SaleDataModel preorderEdit = ref.watch(saleEditSkuAmountProvider(widget.sku));
//                                   CasePieceType type = widget.saleType == SaleType.delivery ? CasePieceType.PIECE : ref.watch(selectedCasePieceTypeProvider);
//                                   preorderEditController.text = type == CasePieceType.CASE ? salesController.getPackWiseCount(widget.sku, preorderEdit.qty).toString() : preorderEdit.qty.toString();
//                                   return Column(
//                                     children: [
//                                       TextFormField(
//                                         controller: preorderEditController,
//                                         decoration: InputDecoration(
//                                           border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.2.w, style: BorderStyle.solid)),
//                                           isDense: true,
//                                           enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.2.w, style: BorderStyle.solid)),
//                                         ),
//                                         textAlign: TextAlign.center,
//                                         keyboardType: TextInputType.number,
//                                         inputFormatters: [
//                                           FilteringTextInputFormatter.allow(RegExp(r'[0-9]*')),
//                                           TextInputFormatter.withFunction(
//                                             (oldValue, newValue) => newValue.copyWith(
//                                               text: newValue.text.replaceAll('.', ','),
//                                             ),
//                                           ),
//                                         ],
//                                         style: TextStyle(fontSize: 15.sp, color: darkGrey, fontWeight: FontWeight.bold, fontFamily: lang == 'en' ? englishFont : banglaFont),
//                                         onChanged: (_) {
//                                           if (preorderEditController.text.isEmpty) {
//                                             preorderEditController.text = "0";
//                                             FocusScope.of(context).requestFocus(FocusNode());
//                                           } else {}
//                                         },
//                                       ),
//                                       SKUCasePieceShowWidget(
//                                         sku: widget.sku,
//                                         qty: preorderEdit.qty,
//                                         showUnitName: true,
//                                         qtyTextStyle: TextStyle(fontSize: 8.sp, color: darkGrey, fontWeight: FontWeight.bold),
//                                         unitTextStyle: TextStyle(fontSize: 8.sp, color: darkGrey),
//                                       )
//                                     ],
//                                   );
//                                 }),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 0.w,
//                             ),
//                             IconButton(
//                               onPressed: () async {
//                                 /// adding
//                                 FocusScope.of(context).requestFocus(FocusNode());
//                                 // await salesController.preorderInputFormatting(widget.sku, preorderEditController);
//                                 salesController.increment(
//                                   widget.sku,
//                                   edit: true,
//                                   casePieceType: widget.saleType == SaleType.preorder ? null : CasePieceType.PIECE,
//                                 );
//                               },
//                               padding: const EdgeInsets.only(top: 8, left: 0, right: 8, bottom: 8),
//                               icon: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5.sp),
//                                   gradient: LinearGradient(
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                     colors: [green, darkGreen],
//                                   ),
//                                 ),
//                                 child: Icon(Icons.add, color: Colors.white, size: 17.sp),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 1.h,
//               ),
//               // if(widget.saleType == SaleType.delivery)const CasePieceUI(),
//               SizedBox(
//                 height: 1.h,
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(7.sp),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [blue3, blue3],
//                   ),
//                 ),
//                 child: Consumer(builder: (context, ref, _) {
//                   CasePieceType type = widget.saleType == SaleType.delivery ? CasePieceType.PIECE : ref.watch(selectedCasePieceTypeProvider);
//                   int addedAmount = type == CasePieceType.CASE ? 1 : widget.sku.packSize;
//                   return Row(
//                     children: [
//                       SizedBox(
//                         height: 1.h,
//                       ),
//                       Expanded(
//                         child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                           plusButton(1, addedAmount),
//                           SizedBox(
//                             height: 1.5.h,
//                           ),
//                           plusButton(3, addedAmount),
//                           SizedBox(
//                             height: 1.5.h,
//                           ),
//                           plusButton(6, addedAmount),
//                           SizedBox(
//                             height: 1.5.h,
//                           ),
//                           plusButton(12, addedAmount),
//                           SizedBox(
//                             height: 1.5.h,
//                           ),
//                           plusButton(24, addedAmount),
//                           SizedBox(
//                             height: 1.5.h,
//                           ),
//                           plusButton(48, addedAmount),
//                         ]),
//                       ),
//                       SizedBox(
//                         width: 3.w,
//                       ),
//                       Expanded(
//                         child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                           removeButton(1, addedAmount),
//                           SizedBox(
//                             height: 1.5.h,
//                           ),
//                           removeButton(3, addedAmount),
//                           SizedBox(
//                             height: 1.5.h,
//                           ),
//                           removeButton(6, addedAmount),
//                           SizedBox(
//                             height: 1.5.h,
//                           ),
//                           removeButton(12, addedAmount),
//                           SizedBox(
//                             height: 1.5.h,
//                           ),
//                           removeButton(24, addedAmount),
//                           SizedBox(
//                             height: 1.5.h,
//                           ),
//                           removeButton(48, addedAmount),
//                         ]),
//                       ),
//                       SizedBox(
//                         height: 2.h,
//                       )
//                     ],
//                   );
//                 }),
//               ),
//               SizedBox(
//                 height: 1.h,
//               ),
//               SizedBox(
//                 height: 1.5.h,
//               ),
//               Center(
//                 child: Container(
//                   width: 40.w,
//                   height: 5.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5.sp),
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [green, darkGreen],
//                     ),
//                   ),
//                   child: ElevatedButton(
//                       onPressed: () async {
//                         CasePieceType type = widget.saleType == SaleType.delivery ? CasePieceType.PIECE : ref.read(selectedCasePieceTypeProvider);
//                         String countString = preorderEditController.text.isNotEmpty ? preorderEditController.text : "0";
//                         int count = int.tryParse(countString) ?? 0;
//                         int multiplier = type == CasePieceType.CASE ? widget.sku.packSize : 1;
//                         count = count * multiplier;
//                         await salesController.saveEditedPreorder(widget.sku, count);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         elevation: 0,
//                       ),
//                       child: SizedBox(
//                         width: 35.w,
//                         height: 5.h,
//                         child: Center(
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.save_outlined,
//                                 color: Colors.white,
//                                 size: 10.sp,
//                               ),
//                               SizedBox(
//                                 width: 1.w,
//                               ),
//                               Center(
//                                 child: LangText(
//                                   'Save',
//                                   style: TextStyle(color: Colors.white, fontSize: 12.sp),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       )),
//                 ),
//               )
//             ],
//           ),
//         ),
//         Positioned(
//             top: 0.h,
//             right: 0.w,
//             child: IconButton(
//               onPressed: () async {
//                 // await salesController.preorderInputFormatting(widget.sku, preorderEditController, widget.onHand??' -');
//                 FocusScope.of(context).requestFocus(FocusNode());
//                 SaleDataModel saleData = ref.read(saleSkuAmountProvider(widget.sku));
//                 int amount = saleData.qty;
//                 ref.read(saleEditSkuAmountProvider(widget.sku).notifier).setState(amount);
//
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 Icons.cancel_outlined,
//                 color: Colors.red,
//                 size: 13.sp,
//               ),
//             ))
//       ],
//     );
//   }
//
//   Widget plusButton(int multiply, int addedAmount) {
//     return InkWell(
//       onTap: () async {
//         FocusScope.of(context).requestFocus(FocusNode());
//         salesController.addSpecificAmountOfSales(widget.sku, multiply, addedAmount);
//       },
//       child: Container(
//         // width: 11.w,
//         height: 3.5.h,
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.sp), color: Colors.white),
//         child: Center(child: LangText((multiply * addedAmount).toString(), isNum: false, isNumber: true)),
//       ),
//     );
//   }
//
//   Widget removeButton(int multiply, int addedAmount) {
//     return InkWell(
//       onTap: () async {
//         FocusScope.of(context).requestFocus(FocusNode());
//         salesController.removeSpecificAmountOfSales(widget.sku, multiply, addedAmount);
//       },
//       child: Container(
//         // width: 11.w,
//         height: 3.5.h,
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.sp), color: Colors.white),
//         child: Center(
//             child: LangText(
//           ('-${(multiply * addedAmount).toString()}').toString(),
//           isNumber: true,
//           isNum: false,
//         )),
//       ),
//     );
//   }
// }
