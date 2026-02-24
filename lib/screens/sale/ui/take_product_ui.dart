// import 'dart:developer';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../constants/constant_variables.dart';
// import '../../../models/module.dart';
// import '../../../models/outlet_model.dart';
// import '../../../models/products_details_model.dart';
// import '../../../models/sales/sale_data_model.dart';
// import '../../../provider/global_provider.dart';
// import '../../../reusable_widgets/custom_dialog.dart';
// import '../../../reusable_widgets/global_widgets.dart';
// import '../../../reusable_widgets/language_textbox.dart';
// import '../../../services/asset_download/asset_service.dart';
// import '../../../services/sync_read_service.dart';
// import '../../../utils/case_piece_type_utils.dart';
// import '../../../utils/sales_type_utils.dart';
// import '../controller/sale_controller.dart';
// import 'preorder_edit_dialog.dart';
// import 'promotion_ui.dart';
// import 'sku_case_piece_show_widget.dart';
//
// class TakePreorderUI extends ConsumerStatefulWidget {
//   const TakePreorderUI({Key? key, this.saleType = SaleType.preorder}) : super(key: key);
//   final SaleType saleType;
//
//   @override
//   ConsumerState<TakePreorderUI> createState() => _TakePreorderUIState();
// }
//
// class _TakePreorderUIState extends ConsumerState<TakePreorderUI> {
//   late SaleController saleController;
//
//   @override
//   void initState() {
//     saleController = SaleController(context: context, ref: ref);
//     super.initState();
//   }
//
//   bool disableForUsingCoupon = false;
//
//   @override
//   Widget build(BuildContext context) {
//     Module? selectedModule = ref.watch(selectedSalesModuleProvider);
//
//     OutletModel? outlet = ref.watch(selectedRetailerProvider);
//     if (selectedModule != null) {
//       AsyncValue<List<ProductDetailsModel>> asyncSkus =
//           widget.saleType == SaleType.preorder ? ref.watch(productListFutureProvider(selectedModule)) : ref.watch(deliveryListFutureProvider(selectedModule));
//
//       return Consumer(
//         builder: (BuildContext context, WidgetRef ref, Widget? child) {
//           AsyncValue<bool> alreadyUseCoupon = ref.watch(disableEditForCouponDiscountProvider(outlet!));
//
//           return alreadyUseCoupon.when(
//             data: (couponUsed) {
//               return asyncSkus.when(
//                 data: (skus) {
//                   return IgnorePointer(
//                     ignoring: couponUsed==true && widget.saleType == SaleType.delivery,
//                     child: ListView.builder(
//                       itemCount: skus.length,
//                       primary: false,
//                       shrinkWrap: true,
//                       padding: EdgeInsets.symmetric(vertical: 0.5.h),
//                       physics: NeverScrollableScrollPhysics(),
//                       itemBuilder: (context, i) {
//                         return SKUItem(
//                           sku: skus[i],
//                           saleController: saleController,
//                           showPreorderInfo: widget.saleType == SaleType.delivery,
//                           saleType: widget.saleType,
//                         );
//                       },
//                     ),
//                   );
//                 },
//                 error: (e, s) => Text('$e'),
//                 loading: () => const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             },
//             error: (e, s) => Text('$e'),
//             loading: () => const Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         },
//       );
//     }
//     return SizedBox();
//   }
// }
//
// class SKUItem extends ConsumerWidget {
//   SKUItem({Key? key, required this.saleType, required this.sku, required this.saleController, required this.showPreorderInfo}) : super(key: key);
//   ProductDetailsModel sku;
//   final bool showPreorderInfo;
//   SaleType saleType;
//
//   GlobalWidgets globalWidgets = GlobalWidgets();
//   final SaleController saleController;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 1.w),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8.sp),
//           color: Colors.white,
//         ),
//         margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
//         child: Stack(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 3.w),
//               child: Row(
//                 children: [
//                   ///sku image and name
//                   InkWell(
//                     onTap: () async {
//                       OutletModel? dropdownSelected = ref.read(selectedRetailerProvider);
//                       if (dropdownSelected != null) {
//                         Alerts(context: context).showModalWithWidget(
//                           child: PreorderEditDialogUI(
//                             sku,
//                             globalWidgets,
//                             saleType: saleType,
//                           ),
//                         );
//                       }
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         SizedBox(
//                           width: 15.w,
//                           // height: 8.h,
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 10.sp, bottom: 5.sp),
//                             child: AssetService(context).superImage('${sku.id}.png', folder: 'SKU', version: SyncReadService().getAssetVersion('SKU'), height: 12.h),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 1.w,
//                         ),
//                         SizedBox(
//                           width: 15.w,
//                           child: LangText(
//                             sku.shortName,
//                             style: TextStyle(fontSize: normalFontSize, color: darkGreen),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     width: 3.w,
//                   ),
//
//                   ///offer, count and stock
//                   Column(
//                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       PromotionUI(sku: sku),
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: 2.h),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 // saleController.decrement(sku);
//                                 saleController.decrement(
//                                   sku,
//                                   casePieceType: saleType == SaleType.preorder ? null : CasePieceType.PIECE,
//                                 );
//
//                                 // salesController.decrement(widget.item[index]);
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5.sp),
//                                   gradient: LinearGradient(
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                     colors: [green, darkGreen],
//                                   ),
//                                 ),
//                                 child: Icon(Icons.remove, color: Colors.white, size: 15.sp),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 1.w,
//                             ),
//                             Consumer(builder: (context, ref, _) {
//                               SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));
//                               // ref.read(saleEditSkuAmountProvider(widget.item[index]).notifier).state = count;
//                               return InkWell(
//                                 onTap: () {
//                                   OutletModel? dropdownSelected = ref.read(selectedRetailerProvider);
//                                   if (dropdownSelected != null) {
//                                     Alerts(context: context).showModalWithWidget(
//                                       child: PreorderEditDialogUI(
//                                         sku,
//                                         globalWidgets,
//                                         saleType: saleType,
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
//                                           CasePieceType type = saleType == SaleType.preorder ? ref.watch(selectedCasePieceTypeProvider) : CasePieceType.PIECE;
//
//                                           return SKUCasePieceShowWidget(
//                                             sku: sku,
//                                             qty: saleData.qty,
//                                             casePieceType: type,
//                                           );
//                                         }),
//                                         Divider(
//                                           color: Colors.grey,
//                                           height: 1.w,
//                                           thickness: 0.2.w,
//                                         ),
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
//                                 saleController.increment(
//                                   sku,
//                                   casePieceType: saleType == SaleType.preorder ? CasePieceType.CASE : CasePieceType.PIECE,
//                                 );
//                                 // salesController.increment(widget.item[index]);
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5.sp),
//                                   gradient: LinearGradient(
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                     colors: [green, darkGreen],
//                                   ),
//                                 ),
//                                 child: Icon(Icons.add, color: Colors.white, size: 15.sp),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       showPreorderInfo
//                           ? Consumer(builder: (context, ref, _) {
//                               AsyncValue<Map<String, dynamic>> asyncPreorderPerRetailer = ref.watch(preorderPerRetailerProvider);
//                               return asyncPreorderPerRetailer.when(
//                                   data: (preorderData) {
//                                     return Builder(builder: (context) {
//                                       if (preorderData.containsKey(sku.id.toString())) {
//                                         int preorderAmount = int.tryParse(preorderData[sku.id.toString()].toString()) ?? 0;
//                                         if (preorderAmount > 0) {
//                                           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//                                             ref.read(saleSkuAmountProvider(sku).notifier).increment(preorderAmount);
//                                           });
//                                         }
//
//                                         return Container(
//                                           height: 3.h,
//                                           width: 30.w,
//                                           decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(50.sp), topLeft: Radius.circular(50.sp)), color: Color(0xFFBADEFF)),
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
//                                                   CasePieceType type = saleType == SaleType.preorder ? CasePieceType.CASE : CasePieceType.PIECE;
//
//                                                   return SKUCasePieceShowWidget(
//                                                     sku: sku,
//                                                     qty: preorderData[sku.id.toString()],
//                                                     casePieceType: type,
//                                                     pieceWithQty: saleType == SaleType.delivery ? true : false,
//                                                     showUnitName: true,
//                                                     qtyTextStyle: TextStyle(fontSize: 10.sp, color: darkGrey, fontWeight: FontWeight.bold),
//                                                     unitTextStyle: TextStyle(fontSize: 10.sp, color: darkGrey),
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
//                           : SizedBox(
//                               height: 3.h,
//                               width: 30.w,
//                             ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: 3.w,
//                   ),
//
//                   ///other infos
//                   Expanded(
//                     child: Consumer(
//                       builder: (context, ref, _) {
//                         SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));
//
//                         return LangText(
//                           saleData.price.toStringAsFixed(2),
//                           isNumber: true,
//                           style: TextStyle(fontSize: 12.sp, color: darkGrey, fontWeight: FontWeight.bold),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 1.h,
//               right: 3.w,
//               child: Consumer(builder: (context, ref, _) {
//                 SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));
//                 CasePieceType type = saleType == SaleType.preorder ? CasePieceType.CASE : CasePieceType.PIECE;
//
//                 return SKUCasePieceShowWidget(
//                   sku: sku,
//                   qty: saleData.qty,
//                   showUnitName: true,
//                   pieceWithQty: saleType == SaleType.delivery ? true : false,
//                   casePieceType: type,
//                   qtyTextStyle: TextStyle(fontSize: 10.sp, color: darkGrey, fontWeight: FontWeight.bold),
//                   unitTextStyle: TextStyle(fontSize: 10.sp, color: darkGrey),
//                 );
//               }),
//             ),
//             Visibility(
//               visible: kDebugMode,
//               child: Text("${sku.id}", style: TextStyle(color: Colors.black.withOpacity(0.05)),),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
