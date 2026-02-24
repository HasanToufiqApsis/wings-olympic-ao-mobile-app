import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/screens/sale/model/product_view.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../../constants/constant_variables.dart';
import '../../../../models/outlet_model.dart';
import '../../../../models/products_details_model.dart';
import '../../../../models/sales/sale_data_model.dart';
import '../../../../provider/global_provider.dart';
import '../../../../reusable_widgets/custom_dialog.dart';
import '../../../../reusable_widgets/global_widgets.dart';
import '../../../../reusable_widgets/language_textbox.dart';
import '../../../../services/asset_download/asset_service.dart';
import '../../../../services/sync_read_service.dart';
import '../../../../utils/case_piece_type_utils.dart';
import '../../../../utils/sales_type_utils.dart';
import '../../controller/sale_controller.dart';
import '../preorder_edit_dialog.dart';
import '../promotion_ui.dart';
import '../sku_case_piece_show_widget.dart';

// class SkuListTile extends ConsumerStatefulWidget {
//   SkuListTile({
//     super.key,
//     required this.saleType,
//     required this.sku,
//     required this.saleController,
//     required this.showPreorderInfo,
//     required this.viewType,
//     this.isFirstItem = false,
//     this.isLastItem = false,
//     required this.bcpValue,
//     required this.preOrderVolume,
//     required this.soqVolume,
//   });
//
//   final ProductDetailsModel sku;
//   final bool showPreorderInfo;
//   final SaleType saleType;
//   final ViewComplexity viewType;
//   final bool isFirstItem;
//   final bool isLastItem;
//   final double bcpValue;
//   final num preOrderVolume;
//   final num soqVolume;
//
//   final SaleController saleController;
//
//   @override
//   ConsumerState<SkuListTile> createState() => _SkuListTileState();
// }
//
// class _SkuListTileState extends ConsumerState<SkuListTile> {
//   final globalWidgets = GlobalWidgets();
//
//   @override
//   void initState() {
//     if (widget.showPreorderInfo) {
//       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//         // final prevVolume = ref.read(saleSkuAmountProvider(widget.sku)).qty;
//         // if (true) {
//         //   ref.read(saleSkuAmountProvider(widget.sku).notifier)
//         //       .increment(widget.preOrderVolume.toInt());
//         // }
//
//         ref
//             .read(saleSkuAmountProvider(widget.sku).notifier)
//             .increment(widget.preOrderVolume.toInt());
//       });
//     }
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SkuTileContainer(
//           viewType: widget.viewType,
//           isFistItem: widget.isFirstItem,
//           isLastItem: widget.isLastItem,
//           child: Stack(
//             children: [
//               Row(
//                 children: [
//                   ///sku image and name
//                   InkWell(
//                     onTap: () async {
//                       OutletModel? dropdownSelected = ref.read(selectedRetailerProvider);
//                       if (dropdownSelected != null) {
//                         Alerts(context: context).showModalWithWidget(
//                           child: PreorderEditDialogUI(
//                             widget.sku,
//                             globalWidgets,
//                             saleType: widget.saleType,
//                           ),
//                         );
//                       }
//                     },
//                     child: SkuImageWidget(
//                       viewType: widget.viewType,
//                       sku: widget.sku,
//                     ),
//                   ),
//                   12.horizontalSpacing,
//                   Expanded(
//                     child: SkuTileDataPanel(
//                       sku: widget.sku,
//                       viewType: widget.viewType,
//                       saleType: widget.saleType,
//                       bcpValue: widget.bcpValue,
//                       preOrderVolume: widget.preOrderVolume,
//                       soqVolume: widget.soqVolume,
//                     ),
//                   ),
//
//                   ///count and stock
//                   Column(
//                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: 2.h),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 // saleController.decrement(sku);
//                                 widget.saleController.decrement(
//                                   widget.sku,
//                                   casePieceType: widget.saleType == SaleType.preorder
//                                       ? null
//                                       : CasePieceType.PIECE,
//                                 );
//
//                                 // salesController.decrement(widget.item[index]);
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: primary,
//                                 ),
//                                 child: Icon(Icons.remove, color: Colors.white, size: 15.sp),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 1.w,
//                             ),
//                             Consumer(builder: (context, ref, _) {
//                               SaleDataModel saleData = ref.watch(saleSkuAmountProvider(widget.sku));
//                               // ref.read(saleEditSkuAmountProvider(widget.item[index]).notifier).state = count;
//                               return InkWell(
//                                 onTap: () {
//                                   OutletModel? dropdownSelected =
//                                       ref.read(selectedRetailerProvider);
//                                   if (dropdownSelected != null) {
//                                     Alerts(context: context).showModalWithWidget(
//                                       child: PreorderEditDialogUI(
//                                         widget.sku,
//                                         globalWidgets,
//                                         saleType: widget.saleType,
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 child: Center(
//                                   child: SizedBox(
//                                     width: 18.w,
//                                     // height: 15.h,
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Consumer(builder: (context, ref, _) {
//                                           // CasePieceType type = ref.watch(selectedCasePieceTypeProvider);
//
//                                           CasePieceType type = widget.saleType == SaleType.preorder
//                                               ? ref.watch(selectedCasePieceTypeProvider)
//                                               : CasePieceType.PIECE;
//
//                                           return SKUCasePieceShowWidget(
//                                             sku: widget.sku,
//                                             qty: saleData.qty,
//                                             casePieceType: type,
//                                             qtyTextStyle: TextStyle(
//                                               fontSize: 16,
//                                             ),
//                                           );
//                                         }),
//                                         // Divider(
//                                         //   color: Colors.grey,
//                                         //   height: 1.w,
//                                         //   thickness: 0.2.w,
//                                         // ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                             SizedBox(
//                               width: 1.w,
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 print("COME __________> COME ______________> ${widget.saleType}");
//                                 widget.saleController.increment(
//                                   widget.sku,
//                                   casePieceType: widget.saleType == SaleType.preorder
//                                       ? CasePieceType.CASE
//                                       : CasePieceType.PIECE,
//                                   saleType: widget.saleType,
//                                 );
//                                 // salesController.increment(widget.item[index]);
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: primary,
//                                 ),
//                                 child: Icon(Icons.add, color: Colors.white, size: 15.sp),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       /*showPreorderInfo*/ false
//                           ? Consumer(builder: (context, ref, _) {
//                               AsyncValue<Map<String, dynamic>> asyncPreorderPerRetailer =
//                                   ref.watch(preorderPerRetailerProvider);
//                               return asyncPreorderPerRetailer.when(
//                                   data: (preorderData) {
//                                     return Builder(builder: (context) {
//                                       if (preorderData.containsKey(widget.sku.id.toString())) {
//                                         int preorderAmount = int.tryParse(
//                                                 preorderData[widget.sku.id.toString()]
//                                                     .toString()) ??
//                                             0;
//                                         if (preorderAmount > 0) {
//                                           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//                                             ref
//                                                 .read(saleSkuAmountProvider(widget.sku).notifier)
//                                                 .increment(preorderAmount);
//                                           });
//                                         }
//
//                                         return Container(
//                                           height: 3.h,
//                                           width: 30.w,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.only(
//                                                   topRight: Radius.circular(50.sp),
//                                                   topLeft: Radius.circular(50.sp)),
//                                               color: Color(0xFFBADEFF)),
//                                           child: Center(
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Icon(
//                                                   Icons.note_alt_outlined,
//                                                   color: Color(0xFFE72582),
//                                                   size: 10.sp,
//                                                 ),
//                                                 SizedBox(
//                                                   width: 1.w,
//                                                 ),
//
//                                                 ///phase 1
//                                                 // SKUCasePieceShowWidget(
//                                                 //   sku: sku,
//                                                 //   qty: preorderData[sku.id.toString()],
//                                                 //   showUnitName: true,
//                                                 //   qtyTextStyle: TextStyle(fontSize: 10.sp, color: darkGrey, fontWeight: FontWeight.bold),
//                                                 //   unitTextStyle: TextStyle(fontSize: 10.sp, color: darkGrey),
//                                                 // ),
//
//                                                 ///phase 2
//                                                 Consumer(builder: (context, ref, _) {
//                                                   // CasePieceType type = ref.watch(selectedCasePieceTypeProvider);
//                                                   CasePieceType type =
//                                                       widget.saleType == SaleType.preorder
//                                                           ? CasePieceType.CASE
//                                                           : CasePieceType.PIECE;
//
//                                                   return SKUCasePieceShowWidget(
//                                                     sku: widget.sku,
//                                                     qty: preorderData[widget.sku.id.toString()],
//                                                     casePieceType: type,
//                                                     pieceWithQty:
//                                                         widget.saleType == SaleType.delivery
//                                                             ? true
//                                                             : false,
//                                                     showUnitName: true,
//                                                     qtyTextStyle: TextStyle(
//                                                         fontSize: 10.sp,
//                                                         color: darkGrey,
//                                                         fontWeight: FontWeight.bold),
//                                                     unitTextStyle:
//                                                         TextStyle(fontSize: 10.sp, color: darkGrey),
//                                                   );
//                                                 })
//
//                                                 // LangText(
//                                                 //   '${preorderData[sku.id.toString()]}',
//                                                 //   isNumber: true,
//                                                 //   style: TextStyle(color: darkGrey, fontSize: 10.sp),
//                                                 // )
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       } else {
//                                         return SizedBox(
//                                           height: 3.h,
//                                           width: 30.w,
//                                         );
//                                       }
//                                     });
//                                   },
//                                   error: (error, _) => Container(),
//                                   loading: () => Container());
//                             })
//                           : SizedBox(),
//                     ],
//                   ),
//                   SizedBox(
//                     width: 4,
//                   ),
//                 ],
//               ),
//               Visibility(
//                 visible: kDebugMode,
//                 child: Text(
//                   "${widget.sku.id}",
//                   style: TextStyle(color: Colors.black.withOpacity(0.05)),
//                 ),
//               )
//             ],
//           ),
//         ),
//         Visibility(
//           visible: !widget.isLastItem && widget.viewType != ViewComplexity.complex,
//           child: Divider(
//             thickness: 1,
//             height: 1,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class SkuTileContainer extends StatelessWidget {
//   final Widget child;
//   final ViewComplexity viewType;
//   final bool isFistItem;
//   final bool isLastItem;
//
//   const SkuTileContainer({
//     super.key,
//     required this.child,
//     required this.viewType,
//     required this.isFistItem,
//     required this.isLastItem,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     switch (viewType) {
//       case ViewComplexity.complex:
//         return Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//             border: Border.all(
//               width: 1,
//               color: Colors.grey.shade300,
//             ),
//           ),
//           margin: EdgeInsets.only(bottom: 8),
//           padding: EdgeInsets.all(8),
//           child: child,
//         );
//       case ViewComplexity.moderate:
//       case ViewComplexity.simple:
//         return Container(
//           decoration: BoxDecoration(
//             color: lightBlue,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(isFistItem ? 10 : 0),
//               topRight: Radius.circular(isFistItem ? 10 : 0),
//               bottomRight: Radius.circular(isLastItem ? 10 : 0),
//               bottomLeft: Radius.circular(isLastItem ? 10 : 0),
//             ),
//           ),
//           padding: EdgeInsets.symmetric(
//             horizontal: 8,
//             vertical: viewType == ViewComplexity.moderate ? 8 : 0,
//           ),
//           child: child,
//         );
//     }
//   }
// }
//
// class SkuImageWidget extends StatelessWidget {
//   final ViewComplexity viewType;
//   final ProductDetailsModel sku;
//
//   const SkuImageWidget({
//     super.key,
//     required this.viewType,
//     required this.sku,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final image = AssetService(context).superImage(
//       '${sku.id}.png',
//       folder: 'SKU',
//       version: SyncReadService().getAssetVersion('SKU'),
//       height: 60,
//       width: 60,
//       circular: true,
//       // fit: BoxFit.fitHeight,
//     );
//
//     switch (viewType) {
//       case ViewComplexity.complex:
//         return Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(70),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               padding: EdgeInsets.all(2),
//               child: image,
//             ),
//             PromotionUI(sku: sku),
//           ],
//         );
//       case ViewComplexity.moderate:
//         return Stack(
//           children: [
//             Card(
//               color: Colors.white,
//               margin: EdgeInsets.zero,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(2),
//                 child: image,
//               ),
//             ),
//             PromotionUI(sku: sku),
//           ],
//         );
//         throw UnimplementedError();
//       case ViewComplexity.simple:
//         return const SizedBox();
//     }
//   }
// }
//
// class SkuTileDataPanel extends StatelessWidget {
//   final ProductDetailsModel sku;
//   final ViewComplexity viewType;
//   final SaleType saleType;
//   final double bcpValue;
//   final num preOrderVolume;
//   final num soqVolume;
//
//   const SkuTileDataPanel({
//     super.key,
//     required this.sku,
//     required this.viewType,
//     required this.saleType,
//     required this.bcpValue,
//     required this.preOrderVolume,
//     required this.soqVolume,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     switch (viewType) {
//       case ViewComplexity.complex:
//         return _complexView();
//       case ViewComplexity.moderate:
//         return _moderateView();
//       case ViewComplexity.simple:
//         return _simpleView();
//     }
//   }
//
//   Widget _simpleView() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             PromotionUI(
//               sku: sku,
//               iconHeight: 16,
//               iconWidth: 16,
//             ),
//             4.horizontalSpacing,
//             Expanded(child: LangText(sku.shortName)),
//           ],
//         ),
//         4.verticalSpacing,
//         Row(
//           children: [
//             _pickedCasePiceWidget(viewType: viewType),
//             4.horizontalSpacing,
//             Text('-'),
//             4.horizontalSpacing,
//             _priceWidget(viewType: viewType),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _moderateView() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         LangText(sku.shortName),
//         4.verticalSpacing,
//         _pickedCasePiceWidget(viewType: viewType),
//         _priceWidget(viewType: viewType),
//       ],
//     );
//   }
//
//   Widget _complexView() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         LangText(
//           sku.shortName,
//           style: TextStyle(
//             color: primary,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         4.verticalSpacing,
//         Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _iconTitle(
//                     icon: Icon(CupertinoIcons.tag, size: 14),
//                     text: preOrderVolume.toStringAsFixed(0)),
//                 4.verticalSpacing,
//                 _iconTitle(
//                     icon: Icon(CupertinoIcons.percent, size: 14),
//                     text: bcpValue.toStringAsFixed(1)),
//               ],
//             ),
//             12.horizontalSpacing,
//             Consumer(builder: (context, ref, _) {
//               SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));
//               // ref.read(saleEditSkuAmountProvider(widget.item[index]).notifier).state = count;
//               return Consumer(builder: (context, ref, _) {
//                 // CasePieceType type = ref.watch(selectedCasePieceTypeProvider);
//
//                 CasePieceType type = saleType == SaleType.preorder
//                     ? ref.watch(selectedCasePieceTypeProvider)
//                     : CasePieceType.PIECE;
//
//                 final availableStock = sku.stocks.currentStock - saleData.qty;
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _iconTitle(
//                       icon: Icon(CupertinoIcons.cube_box, size: 14),
//                       text: saleType == SaleType.spotSale ? availableStock.toString() : sku.stocks.currentStock.toStringAsFixed(0),
//                     ),
//                     4.verticalSpacing,
//                     _iconTitle(
//                       icon: Icon(CupertinoIcons.cart, size: 14),
//                       textWidget: SKUCasePieceShowWidget(
//                         sku: sku,
//                         qty: saleData.qty,
//                         casePieceType: type,
//                         qtyTextStyle: TextStyle(fontSize: 12),
//                         unitTextStyle: TextStyle(fontSize: 12),
//                         showUnitName: true,
//                       ),
//                     ),
//                   ],
//                 );
//               });
//             }),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _iconTitle({required Widget icon, String? text, Widget? textWidget}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         icon,
//         4.horizontalSpacing,
//         textWidget ??
//             LangText(
//               text ?? '',
//               style: TextStyle(fontSize: 12),
//             ),
//       ],
//     );
//   }
//
//   Widget _pickedCasePiceWidget({required ViewComplexity viewType}) {
//     return Consumer(builder: (context, ref, _) {
//       SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));
//       CasePieceType type = saleType == SaleType.preorder ? CasePieceType.CASE : CasePieceType.PIECE;
//
//       return SKUCasePieceShowWidget(
//         sku: sku,
//         qty: saleData.qty,
//         showUnitName: true,
//         alignment: MainAxisAlignment.start,
//         pieceWithQty: saleType == SaleType.delivery ? true : false,
//         casePieceType: type,
//         qtyTextStyle: TextStyle(fontSize: 12),
//         unitTextStyle: TextStyle(fontSize: 12),
//       );
//     });
//   }
//
//   Widget _priceWidget({required ViewComplexity viewType}) {
//     return Consumer(
//       builder: (context, ref, _) {
//         SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));
//
//         return Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             LangText(
//               saleData.price.toStringAsFixed(2),
//               isNumber: true,
//               style: TextStyle(
//                 fontSize: 12,
//               ),
//             ),
//             4.horizontalSpacing,
//             LangText(
//               'tk',
//               style: TextStyle(fontSize: 12),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

class SkuListTile extends ConsumerStatefulWidget {
  SkuListTile({
    super.key,
    required this.saleType,
    required this.sku,
    required this.saleController,
    required this.showPreorderInfo,
    required this.viewType,
    this.isFirstItem = false,
    this.isLastItem = false,
    required this.bcpValue,
    required this.preOrderVolume,
    required this.soqVolume,
  });

  final ProductDetailsModel sku;
  final bool showPreorderInfo;
  final SaleType saleType;
  final ViewComplexity viewType;
  final bool isFirstItem;
  final bool isLastItem;
  final double bcpValue;
  final num preOrderVolume;
  final num soqVolume;

  final SaleController saleController;

  @override
  ConsumerState<SkuListTile> createState() => _SkuListTileState();
}

class _SkuListTileState extends ConsumerState<SkuListTile> {
  final globalWidgets = GlobalWidgets();

  @override
  void initState() {
    if (widget.showPreorderInfo) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref
            .read(saleSkuAmountProvider(widget.sku).notifier)
            .increment(widget.preOrderVolume.toInt());
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkuTileContainer(
          viewType: widget.viewType,
          isFistItem: widget.isFirstItem,
          isLastItem: widget.isLastItem,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        OutletModel? dropdownSelected =
                        ref.read(selectedRetailerProvider);
                        if (dropdownSelected != null) {
                          Alerts(context: context).showModalWithWidget(
                            child: PreorderEditDialogUI(
                              widget.sku,
                              globalWidgets,
                              saleType: widget.saleType,
                            ),
                          );
                        }
                      },
                      child: SkuImageWidget(
                        viewType: widget.viewType,
                        sku: widget.sku,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SkuTileDataPanel(
                        sku: widget.sku,
                        viewType: widget.viewType,
                        saleType: widget.saleType,
                        bcpValue: widget.bcpValue,
                        preOrderVolume: widget.preOrderVolume,
                        soqVolume: widget.soqVolume,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildCounterButton(
                                icon: Icons.remove,
                                onTap: () {
                                  widget.saleController.decrement(
                                    widget.sku,
                                    casePieceType:
                                    widget.saleType == SaleType.preorder
                                        ? null
                                        : CasePieceType.PIECE,
                                  );
                                },
                              ),
                              SizedBox(width: 1.w),
                              Consumer(builder: (context, ref, _) {
                                SaleDataModel saleData =
                                ref.watch(saleSkuAmountProvider(widget.sku));
                                return InkWell(
                                  onTap: () {
                                    OutletModel? dropdownSelected =
                                    ref.read(selectedRetailerProvider);
                                    if (dropdownSelected != null) {
                                      Alerts(context: context)
                                          .showModalWithWidget(
                                        child: PreorderEditDialogUI(
                                          widget.sku,
                                          globalWidgets,
                                          saleType: widget.saleType,
                                        ),
                                      );
                                    }
                                  },
                                  child: Center(
                                    child: SizedBox(
                                      width: 18.w,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Consumer(builder: (context, ref, _) {
                                            CasePieceType type = widget
                                                .saleType ==
                                                SaleType.preorder
                                                ? ref.watch(
                                                selectedCasePieceTypeProvider)
                                                : CasePieceType.PIECE;

                                            return SKUCasePieceShowWidget(
                                              sku: widget.sku,
                                              qty: saleData.qty,
                                              casePieceType: type,
                                              qtyTextStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              SizedBox(width: 1.w),
                              _buildCounterButton(
                                icon: Icons.add,
                                onTap: () {
                                  widget.saleController.increment(
                                    widget.sku,
                                    casePieceType:
                                    widget.saleType == SaleType.preorder
                                        ? CasePieceType.CASE
                                        : CasePieceType.PIECE,
                                    saleType: widget.saleType,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        if (false)
                          Consumer(builder: (context, ref, _) {
                            AsyncValue<Map<String, dynamic>>
                            asyncPreorderPerRetailer =
                            ref.watch(preorderPerRetailerProvider);
                            return asyncPreorderPerRetailer.when(
                                data: (preorderData) {
                                  return Builder(builder: (context) {
                                    if (preorderData
                                        .containsKey(widget.sku.id.toString())) {
                                      int preorderAmount = int.tryParse(
                                          preorderData[widget.sku.id
                                              .toString()]
                                              .toString()) ??
                                          0;
                                      if (preorderAmount > 0) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((timeStamp) {
                                          ref
                                              .read(saleSkuAmountProvider(
                                              widget.sku)
                                              .notifier)
                                              .increment(preorderAmount);
                                        });
                                      }

                                      return Container(
                                        height: 3.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: Colors.blue.withOpacity(0.1),
                                            border: Border.all(color: Colors.blue.withOpacity(0.2))
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.note_alt_outlined,
                                                color: Colors.blue[700],
                                                size: 10.sp,
                                              ),
                                              SizedBox(width: 1.w),
                                              Consumer(
                                                  builder: (context, ref, _) {
                                                    CasePieceType type =
                                                    widget.saleType ==
                                                        SaleType.preorder
                                                        ? CasePieceType.CASE
                                                        : CasePieceType.PIECE;

                                                    return SKUCasePieceShowWidget(
                                                      sku: widget.sku,
                                                      qty: preorderData[widget.sku.id
                                                          .toString()],
                                                      casePieceType: type,
                                                      pieceWithQty: widget.saleType ==
                                                          SaleType.delivery
                                                          ? true
                                                          : false,
                                                      showUnitName: true,
                                                      qtyTextStyle: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: Colors.grey[700],
                                                          fontWeight:
                                                          FontWeight.bold),
                                                      unitTextStyle: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: Colors.grey[700]),
                                                    );
                                                  })
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SizedBox(
                                        height: 3.h,
                                        width: 30.w,
                                      );
                                    }
                                  });
                                },
                                error: (error, _) => Container(),
                                loading: () => Container());
                          })
                        else
                          const SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: kDebugMode,
                child: Text(
                  "${widget.sku.id}",
                  style: TextStyle(color: Colors.black.withOpacity(0.05)),
                ),
              )
            ],
          ),
        ),
        Visibility(
          visible:
          !widget.isLastItem && widget.viewType != ViewComplexity.complex,
          child: Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ],
    );
  }

  Widget _buildCounterButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

class SkuTileContainer extends StatelessWidget {
  final Widget child;
  final ViewComplexity viewType;
  final bool isFistItem;
  final bool isLastItem;

  const SkuTileContainer({
    super.key,
    required this.child,
    required this.viewType,
    required this.isFistItem,
    required this.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    switch (viewType) {
      case ViewComplexity.complex:
        return Container(
          margin: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
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
          child: child,
        );
      case ViewComplexity.moderate:
      case ViewComplexity.simple:
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isFistItem ? 12 : 0),
              topRight: Radius.circular(isFistItem ? 12 : 0),
              bottomRight: Radius.circular(isLastItem ? 12 : 0),
              bottomLeft: Radius.circular(isLastItem ? 12 : 0),
            ),
          ),
          child: child,
        );
    }
  }
}

class SkuImageWidget extends StatelessWidget {
  final ViewComplexity viewType;
  final ProductDetailsModel sku;

  const SkuImageWidget({
    super.key,
    required this.viewType,
    required this.sku,
  });

  @override
  Widget build(BuildContext context) {
    final image = AssetService(context).superImage(
      '${sku.id}.png',
      folder: 'SKU',
      version: SyncReadService().getAssetVersion('SKU'),
      height: 60,
      width: 60,
      circular: true,
    );

    switch (viewType) {
      case ViewComplexity.complex:
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 4,
                  )
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: image,
            ),
            PromotionUI(sku: sku),
          ],
        );
      case ViewComplexity.moderate:
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(2),
              child: image,
            ),
            PromotionUI(sku: sku),
          ],
        );
      case ViewComplexity.simple:
        return const SizedBox();
    }
  }
}

class SkuTileDataPanel extends StatelessWidget {
  final ProductDetailsModel sku;
  final ViewComplexity viewType;
  final SaleType saleType;
  final double bcpValue;
  final num preOrderVolume;
  final num soqVolume;

  const SkuTileDataPanel({
    super.key,
    required this.sku,
    required this.viewType,
    required this.saleType,
    required this.bcpValue,
    required this.preOrderVolume,
    required this.soqVolume,
  });

  @override
  Widget build(BuildContext context) {
    switch (viewType) {
      case ViewComplexity.complex:
        return _complexView();
      case ViewComplexity.moderate:
        return _moderateView();
      case ViewComplexity.simple:
        return _simpleView();
    }
  }

  Widget _simpleView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PromotionUI(
              sku: sku,
              iconHeight: 16,
              iconWidth: 16,
            ),
            4.horizontalSpacing,
            Expanded(
              child: LangText(
                sku.shortName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        4.verticalSpacing,
        Row(
          children: [
            _pickedCasePiceWidget(viewType: viewType),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('-', style: TextStyle(color: Colors.grey)),
            ),
            _priceWidget(viewType: viewType),
          ],
        ),
      ],
    );
  }

  Widget _moderateView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LangText(
          sku.shortName,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        4.verticalSpacing,
        _pickedCasePiceWidget(viewType: viewType),
        _priceWidget(viewType: viewType),
      ],
    );
  }

  Widget _complexView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LangText(
          sku.shortName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        8.verticalSpacing,

        // previous design
        // Row(
        //   children: [
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         _iconTitle(
        //             icon: Icon(CupertinoIcons.tag_fill, size: 14, color: Colors.blue[300]),
        //             text: preOrderVolume.toStringAsFixed(0)),
        //         4.verticalSpacing,
        //         _iconTitle(
        //             icon: Icon(CupertinoIcons.percent, size: 14, color: Colors.orange[300]),
        //             text: bcpValue.toStringAsFixed(1)),
        //       ],
        //     ),
        //     12.horizontalSpacing,
        //     Consumer(builder: (context, ref, _) {
        //       SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));
        //       return Consumer(builder: (context, ref, _) {
        //         CasePieceType type = saleType == SaleType.preorder
        //             ? ref.watch(selectedCasePieceTypeProvider)
        //             : CasePieceType.PIECE;
        //
        //         final availableStock = sku.stocks.currentStock - saleData.qty;
        //
        //         return Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             _iconTitle(
        //               icon: Icon(CupertinoIcons.cube_box_fill, size: 14, color: Colors.grey[400]),
        //               text: saleType == SaleType.spotSale
        //                   ? availableStock.toString()
        //                   : sku.stocks.currentStock.toStringAsFixed(0),
        //             ),
        //             4.verticalSpacing,
        //             _iconTitle(
        //               icon: Icon(CupertinoIcons.cart_fill, size: 14, color: Colors.green[400]),
        //               textWidget: SKUCasePieceShowWidget(
        //                 sku: sku,
        //                 qty: saleData.qty,
        //                 casePieceType: type,
        //                 qtyTextStyle: TextStyle(fontSize: 12, color: Colors.grey[700]),
        //                 unitTextStyle: TextStyle(fontSize: 12, color: Colors.grey[600]),
        //                 showUnitName: true,
        //                 pieceWithQty: true,
        //               ),
        //             ),
        //           ],
        //         );
        //       });
        //     }),
        //   ],
        // ),
        Consumer(builder: (context, ref, _) {
          SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));
          return Consumer(builder: (context, ref, _) {
            CasePieceType type = saleType == SaleType.preorder
                ? ref.watch(selectedCasePieceTypeProvider)
                : CasePieceType.PIECE;

            final availableStock = sku.stocks.currentStock - saleData.qty;

            return Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                if(preOrderVolume > 0)
                _iconTitle(
                    icon: Icon(CupertinoIcons.tag_fill, size: 14, color: Colors.blue[300]),
                    text: preOrderVolume.toStringAsFixed(0)),

                if(saleType == SaleType.spotSale)
                _iconTitle(
                  icon: Icon(CupertinoIcons.cube_box_fill, size: 14, color: Colors.grey[400]),
                  text: saleType == SaleType.spotSale
                      ? availableStock.toString()
                      : sku.stocks.currentStock.toStringAsFixed(0),
                ),
                if(bcpValue > 0)
                _iconTitle(
                    icon: Icon(CupertinoIcons.percent, size: 14, color: Colors.orange[300]),
                    text: bcpValue.toStringAsFixed(0)),

                if(sku.preOrderStocks!=null && saleType == SaleType.preorder)
                  _iconTitle(
                    icon: Icon(CupertinoIcons.home, size: 14, color: Colors.purpleAccent[300]),
                    text: sku.preOrderStocks == null ?
                    "0" :
                    (((sku.preOrderStocks?.maxOrderLimit ?? 0) - (sku.preOrderStocks?.liftingStock ?? 0)) - saleData.qty).toStringAsFixed(0),
                  ),
                _iconTitle(
                  icon: Icon(CupertinoIcons.cart_fill, size: 14, color: Colors.green[400]),
                  textWidget: SKUCasePieceShowWidget(
                    sku: sku,
                    qty: saleData.qty,
                    casePieceType: type,
                    qtyTextStyle: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    unitTextStyle: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    showUnitName: true,
                    pieceWithQty: true,
                  ),
                ),
              ],
            );
          });
        }),
      ],
    );
  }

  Widget _iconTitle({required Widget icon, String? text, Widget? textWidget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        6.horizontalSpacing,
        textWidget ??
            LangText(
              text ?? '',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
      ],
    );
  }

  Widget _pickedCasePiceWidget({required ViewComplexity viewType}) {
    return Consumer(builder: (context, ref, _) {
      SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));
      CasePieceType type =
      saleType == SaleType.preorder ? CasePieceType.CASE : CasePieceType.PIECE;

      return SKUCasePieceShowWidget(
        sku: sku,
        qty: saleData.qty,
        showUnitName: true,
        alignment: MainAxisAlignment.start,
        pieceWithQty: saleType == SaleType.delivery ? true : false,
        casePieceType: type,
        qtyTextStyle: TextStyle(fontSize: 13, color: Colors.grey[800]),
        unitTextStyle: TextStyle(fontSize: 13, color: Colors.grey[600]),
      );
    });
  }

  Widget _priceWidget({required ViewComplexity viewType}) {
    return Consumer(
      builder: (context, ref, _) {
        SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LangText(
              saleData.price.toStringAsFixed(2),
              isNumber: true,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            4.horizontalSpacing,
            LangText(
              'tk',
              style: TextStyle(fontSize: 13, color: Colors.green[700]),
            ),
          ],
        );
      },
    );
  }
}