// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sizer/sizer.dart';
// import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';
//
// import '../../../constants/constant_variables.dart';
// import '../../../constants/enum.dart';
// import '../../../constants/sync_global.dart';
// import '../../../models/brand/brand_model.dart';
// import '../../../models/module.dart';
// import '../../../models/outlet_model.dart';
// import '../../../models/posm/posm_type_model.dart';
// import '../../../models/products_details_model.dart';
// import '../../../models/sales/memo_information_model.dart';
// import '../../../models/trade_promotions/promotion_model.dart';
// import '../../../models/try_before_buy/try_before_buy_model.dart';
// import '../../../provider/global_provider.dart';
// import '../../../reusable_widgets/buttons/submit_button_group.dart';
// import '../../../reusable_widgets/cooler_available_image.dart';
// import '../../../reusable_widgets/custom_dialog.dart';
// import '../../../reusable_widgets/input_fields/custome_image_picker_button.dart';
// import '../../../reusable_widgets/input_fields/dropdowns.dart';
// import '../../../reusable_widgets/input_fields/input_text_fields.dart';
// import '../../../reusable_widgets/language_textbox.dart';
// import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
// import '../../../reusable_widgets/scaffold_widgets/body.dart';
// import '../../../services/asset_download/asset_service.dart';
// import '../../../services/sync_read_service.dart';
// import '../../../services/try_before_buy_service.dart';
// import '../../splash_screen/ui/splash_screen_ui.dart';
// import '../controller/sale_controller.dart';
// import 'before_sale_geo_validation_screen.dart';
// import 'case_piece_ui.dart';
// import 'preorder_category_filter_buttons.dart';
// import 'qps_offer_ui.dart';
// import 'qps_warning_ui.dart';
// import 'special_offer_ui.dart';
//
// class SaleUI extends ConsumerStatefulWidget {
//   SaleUI({Key? key, required this.allMemo}) : super(key: key);
//   static const routeName = "/sale_ui";
//
//   AllMemoInformationModel allMemo;
//
//   @override
//   ConsumerState<SaleUI> createState() => _SaleUIState();
// }
//
// class _SaleUIState extends ConsumerState<SaleUI> {
//   late SaleController _saleController;
//   late Alerts _alerts;
//
//   @override
//   void dispose() {
//     // refreshPosmProvider();
//     quantityNumberController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _saleController = SaleController(context: context, ref: ref);
//     _alerts = Alerts(context: context);
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       if (widget.allMemo.preorderMemo.isNotEmpty) {
//         ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.showSkus;
//         currentPreorderData = {};
//         for (PreorderMemoInformationModel preorderMemoInformationModel in widget.allMemo.preorderMemo) {
//           currentPreorderData[preorderMemoInformationModel.module.id] = {};
//           for (ProductDetailsModel sku in preorderMemoInformationModel.skus) {
//             if (sku.preorderData != null) {
//               currentPreorderData[preorderMemoInformationModel.module.id][sku.id] = sku.preorderData!.qty;
//               ref.read(saleSkuAmountProvider(sku).notifier).incrementDecrementAmount(sku.preorderData!.qty, true);
//             }
//           }
//         }
//
//         var retailer = ref.read(selectedRetailerProvider);
//
//         _saleController.selectBeforeSpecialOfferNew(
//           retailerId: retailer?.id ?? 0,
//           skus: widget.allMemo.preorderMemo[0].skus,
//         );
//       }
//     });
//   }
//
//   bool initialSet = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: widget.allMemo.preorderMemo.isNotEmpty ? "Pre-order Edit" : "Pre-order",
//         titleImage: "pre_order_button.png",
//         showLeading: true,
//       ),
//       body: CustomBody(
//         disableTopPadding: true,
//         child: Column(
//           children: [
//             ///=========== top container ====================================
//             Expanded(
//               child: Consumer(builder: (context, ref, _) {
//                 return CustomScrollView(
//                   clipBehavior: Clip.antiAlias,
//                   slivers: [
//                     ///======================= RETAILER SELECTION ========================
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 1.sp, top: 2.h),
//                         child: Column(
//                           children: [
//                             alphabetBox(),
//                             SizedBox(
//                               height: 10.sp,
//                             ),
//                             retailerDropdown(),
//                             moduleDropdown(),
//                           ],
//                         ),
//                       ),
//                     ),
//
//
//                     // if(false)
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 10.sp),
//                         child: Wrap(
//                           alignment: WrapAlignment.start,
//                           crossAxisAlignment: WrapCrossAlignment.center,
//                           runSpacing: -6.0,
//                           children: [
//                             ///POSM
//                             Consumer(
//                               builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                                 OutletModel? dropdownSelected = ref.watch(selectedRetailerProvider);
//                                 OutletSaleStatus geoFencingStatus = ref.watch(outletSaleStatusProvider);
//                                 AsyncValue<List<String>> allocatedPOSM = ref.watch(allocatedPOSMListProvider);
//
//                                 if (dropdownSelected != null &&
//                                     geoFencingStatus == OutletSaleStatus.showSkus &&
//                                     (allocatedPOSM.value?.isNotEmpty ?? false)) {
//                                   return Padding(
//                                     padding: EdgeInsets.only(top: 2.sp, right: 10),
//                                     child: SingleCustomButton(
//                                       color: primaryGreen,
//                                       label: "Execute POSM",
//                                       onPressed: () {
//                                         posmDialogue();
//                                       },
//                                       icon: null,
//                                       shrinkWrap: true,
//                                       smallSize: true,
//                                       maxWidth: false,
//                                     ),
//                                   );
//                                 }
//                                 return const SizedBox();
//                               },
//                             ),
//
//                             ///try before you buy
//                             Consumer(
//                               builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                                 OutletModel? dropdownSelected = ref.watch(selectedRetailerProvider);
//                                 OutletSaleStatus geoFencingStatus = ref.watch(outletSaleStatusProvider);
//
//                                 if (dropdownSelected != null) {
//                                   AsyncValue<List<TryBeforeBuyModel>> skuList =
//                                   ref.watch(allTryBeforeBuySkuForSpecificRetailer(dropdownSelected));
//
//                                   if (skuList.value?.isNotEmpty ?? false) {
//                                     return Padding(
//                                       padding: EdgeInsets.only(top: 2.sp, right: 10),
//                                       child: SingleCustomButton(
//                                         color: primaryGreen,
//                                         label: "Try Before Buy",
//                                         onPressed: () {
//                                           tryBeforeYouBuyDialogue(tryBeforeBuyList: skuList.value!, retailer: dropdownSelected);
//                                         },
//                                         icon: null,
//                                         shrinkWrap: true,
//                                         smallSize: true,
//                                         maxWidth: false,
//                                       ),
//                                     );
//                                   }
//                                   return const SizedBox();
//                                 }
//                                 return const SizedBox();
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     ///================== MODULE SELECTION ==========================
//                     SliverToBoxAdapter(
//                       child: Consumer(
//                         builder: (context, ref, _) {
//                           AsyncValue<List<Module>> asyncModules = ref.watch(moduleListProvider);
//                           Module? module = ref.watch(selectedSalesModuleProvider);
//                           return asyncModules.when(
//                               data: (modules) {
//                                 if (modules.isNotEmpty) {
//                                   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//                                     ref.read(selectedSalesModuleProvider.notifier).state = modules[0];
//                                   });
//                                 }
//                                 return Container();
//                               },
//                               error: (e, s) => Text('$e'),
//                               loading: () => Container());
//                         },
//                       ),
//                     ),
//
//                     ///================== PRODUCT CATEGORY VIEW FILTER ==========================
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 0.5.h),
//                         child: const Wrap(
//                           alignment: WrapAlignment.start,
//                           crossAxisAlignment: WrapCrossAlignment.center,
//                           runSpacing: 10.0,
//                           children: [
//                             SpecialOffer(),
//                             QpsOffer(),
//                             PreorderCategoryFilterButtons(),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     ///================== QPS (target) WARNING MESSAGE ==========================
//                     const SliverToBoxAdapter(
//                       child: QpsWarningUi(),
//                     ),
//
//                     ///====================== SKU LIST =====================================
//                     SliverToBoxAdapter(
//                       child: BeforeSaleGeoValidationScreenUI(
//                         saleEdit: widget.allMemo.preorderMemo.isNotEmpty,
//                       ),
//                     ),
//
//                     SliverToBoxAdapter(
//                       child: Container(height: 15.h),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//
//             Container(
//               height: 9.h,
//               padding: EdgeInsets.symmetric(horizontal: 3.w),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [primaryGreen, primaryBlue],
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.local_grocery_store_outlined,
//                         size: 16.sp,
//                         color: Colors.white,
//                       ),
//                       SizedBox(
//                         width: 1.w,
//                       ),
//                       Consumer(builder: (context, ref, _) {
//                         num soldAmount = ref.watch(totalSoldAmountProvider);
//                         return LangText(
//                           soldAmount.toStringAsFixed(2),
//                           isNumber: true,
//                           style: TextStyle(fontSize: 16.sp, color: Colors.white),
//                         );
//                       })
//                     ],
//                   ),
//                   SizedBox(
//                       width: 48.w,
//                       child: SubmitButtonGroup(
//                         button1Label: "Proceed",
//                         onButton1Pressed: () async {
//                           ref.refresh(selectedSlabPromotion);
//                           await Future.delayed(const Duration(milliseconds: 35));
//                           currentPromotionData = {};
//                           OutletModel? retailer = ref.read(selectedRetailerProvider);
//                           List<Module>? moduleList = ref.read(moduleListProvider).value;
//                           if (retailer != null && moduleList != null) {
//                             _alerts.floatingLoading();
//                             await _saleController
//                                 .formattingSaleData(module: moduleList, retailer: retailer, saleEdit: widget.allMemo.preorderMemo.isNotEmpty)
//                                 .then((value) async {
//                               Navigator.of(context).pop();
//                               if (value != null) {
//                                 // _saleController.sendToExaminPage(value);
//                                 bool validateBeforeSelectedOffers = await _saleController.checkBeforeSelectedOffers();
//                                 bool validateBeforeSelectedOffers2 =
//                                 await _saleController.checkBeforeSelectedOffers2(value.salesPreorderDiscountDataModel);
//                                 if (validateBeforeSelectedOffers2) {
//                                   _saleController.sendToExaminPage(value);
//                                 } else {
//                                   _alerts.customDialog(
//                                     type: AlertType.warning,
//                                     message: "Your selected SKUs are not covered by the selected offer. Are you agree to proceed?",
//                                     button1: 'Cancel',
//                                     twoButtons: true,
//                                     button2: 'Proceed',
//                                     onTap2: () {
//                                       Navigator.pop(context);
//                                       _saleController.sendToExaminPage(value);
//                                     },
//                                   );
//                                 }
//                               } else {
//                                 _alerts.customDialog(type: AlertType.warning, message: "No SKU selected for sale");
//                               }
//                             });
//                           } else {
//                             if (retailer == null) {
//                               _alerts.customDialog(type: AlertType.warning, message: 'Please select a retailer');
//                             } else {
//                               _alerts.customDialog(type: AlertType.error, message: 'No product found');
//                             }
//                           }
//                         },
//                       )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget retailerDropdown() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.sp),
//               color: Colors.white,
//               // border: Border.all(color: grey, width: 1.sp)
//             ),
//             child: widget.allMemo.preorderMemo.isNotEmpty
//
//             //When sale edit, retailer can not be changed
//                 ? Builder(builder: (context) {
//               OutletModel retailer = ref.read(selectedRetailerProvider)!;
//               return Padding(
//                   padding: EdgeInsets.all(2.w),
//                   child: LangText("${retailer.name} (${retailer.owner})", style: TextStyle(color: Colors.black, fontSize: normalFontSize)));
//             })
//                 :
//
//             //when normal sales, retailer can be changed via dropdown
//             Consumer(builder: (context, ref, _) {
//               OutletModel? dropdownSelected = ref.watch(selectedRetailerProvider);
//               AsyncValue<List<OutletModel>> retailerList = ref.watch(outletListProvider(true));
//               return retailerList.when(
//                   data: (data) {
//                     return Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 2.w),
//                       child: Center(
//                         child: DropdownButton<OutletModel>(
//                           hint: LangText(
//                             'Select a retailer',
//                             style: TextStyle(color: Colors.grey, fontSize: 8.sp),
//                           ),
//                           iconDisabledColor: Colors.transparent,
//                           focusColor: Theme.of(context).primaryColor,
//                           isExpanded: true,
//                           value: dropdownSelected,
//                           iconSize: 15.sp,
//                           items: data.map((item) {
//                             return DropdownMenuItem<OutletModel>(
//                               value: item,
//                               child: FittedBox(
//                                 child: Row(
//                                   children: [
//                                     // iconList(item.iconData),
//
//                                     SizedBox(
//                                       width: 1.w,
//                                     ),
//
//                                     LangText(
//                                       "${item.name} (${item.owner})",
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(color: Colors.black, fontSize: normalFontSize),
//                                     ),
//                                     SizedBox(
//                                       width: 1.w, // item.totalSale.toStringAsFixed(2)
//                                     ),
//                                     // (item.totalSale != 0.0)
//                                     //     ? Row(
//                                     //   mainAxisSize: MainAxisSize.min,
//                                     //   children: [
//                                     //     LangText(
//                                     //       ' : ',
//                                     //       isNumber: true,
//                                     //       style: TextStyle(color: darkGreen, fontSize: normalFontSize),
//                                     //     ),
//                                     //     LangText(
//                                     //       item.totalSale.toStringAsFixed(2),
//                                     //       isNumber: true,
//                                     //       style: TextStyle(color: darkGreen, fontSize: normalFontSize),
//                                     //     ),
//                                     //     LangText(
//                                     //       ' ৳',
//                                     //       isNumber: true,
//                                     //       style: TextStyle(color: darkGreen, fontSize: normalFontSize),
//                                     //     ),
//                                     //   ],
//                                     // )
//                                     //     : const SizedBox(),
//                                     // if(item.preorderExists) (Icon(Icons.token,color: green, size: normalFontSize,))
//                                     //
//                                     // // globalWidgets.customChip(text: item.subChanel, color: orange, textColor: Colors.white)
//                                     // // ]
//                                     CoolerAvailableImageWidget(outlet: item),
//                                     item.hasPreOrdered
//                                         ? const Icon(
//                                       Icons.done_all,
//                                       color: Colors.green,
//                                     )
//                                         : Container(),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                           style: const TextStyle(color: Colors.black),
//                           underline: Container(
//                             height: 0,
//                             color: Colors.transparent,
//                           ),
//                           onChanged: (val) {
//                             _saleController.handleRetailerChange(val);
//                             // print(val!.retailerName);
//                             // salesController.handleRetailerChange(val);
//                             // salesController.handleRetailerChange(val);
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                   error: (e, s) => LangText('$e'),
//                   loading: () => const CircularProgressIndicator());
//             }),
//           ),
//         ),
//         // IconButton(
//         //     onPressed: () {},
//         //     icon: const Icon(
//         //       Icons.info,
//         //       color: Colors.grey,
//         //     ))
//       ],
//     );
//   }
//
//   Widget alphabetBox() {
//     if (widget.allMemo.preorderMemo.isNotEmpty) {
//       return Container();
//     }
//     return Consumer(builder: (context, ref, _) {
//       List<String> alphabetList = ref.watch(alphabetListProvider);
//       String? selected = ref.watch(selectedAlphabetProvider);
//       // alphabetList = ["A","B","C","D",'E','F','G','H','I','J',"A","B","C","D",'E','F','G','H','I','J',"A","B","C","D",'E','F','G','H','I','J',"A","B","C","D",'E','F','G','H','I','J']  ;
//       return Container(
//         width: 100.w,
//         padding: EdgeInsets.symmetric(vertical: 0.0.h),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5.sp),
//             gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [0.5, 1], colors: [primaryGreen, blue3])),
//         child: DefaultTextStyle(
//           style: TextStyle(color: Colors.white, fontSize: normalFontSize),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 2.w),
//             child: Wrap(
//               alignment: WrapAlignment.center,
//               children: List.generate(
//                 alphabetList.length,
//                     (index) => FittedBox(
//                   child: InkWell(
//                     onTap: () {
//                       ref.read(outletListProvider(true).notifier).searchByFirstLetter(alphabetList[index]);
//                       // ref.read(selectedAlphabetProvider.notifier).state = alphabetList[index];
//                       // ref.read(retailerSaleStatusProvider.state).state = RetailerSaleStatus.inactive;
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.all(2.sp),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
//                         decoration: (selected == alphabetList[index])
//                             ? BoxDecoration(
//                           borderRadius: BorderRadius.circular(5.sp),
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [green, darkGreen],
//                           ),
//                         )
//                             : null,
//                         child: Center(
//                           child: LangText(
//                             alphabetList[index].toString(),
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   TextEditingController quantityNumberController = TextEditingController();
//
//   void posmDialogue() {
//     _alerts.showModalWithWidget(
//       backgroundColor: scaffoldBGColor,
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(6.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       refreshPosmProvider();
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: 100.circularRadius,
//                         color: primaryGreen,
//                       ),
//                       padding: const EdgeInsets.all(3),
//                       child: const Icon(
//                         Icons.close,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               heading("Brand"),
//               Consumer(builder: (context, ref, _) {
//                 AsyncValue<List<BrandModel>> asyncAssetType = ref.watch(getBrandsListProvider);
//                 String lang = ref.watch(languageProvider);
//                 String hint = "Select a brand";
//                 if (lang != "en") {
//                   hint = "ব্র্যান্ড নির্বাচন করুণ";
//                 }
//                 return asyncAssetType.when(
//                     data: (assetType) {
//                       return Consumer(builder: (context, ref, _) {
//                         BrandModel? selected = ref.watch(selectedBrandProvider);
//                         return CustomSingleDropdown<BrandModel>(
//                           value: selected,
//                           hintText: hint,
//                           items: assetType.map<DropdownMenuItem<BrandModel>>((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
//                           onChanged: (value) {
//                             ref.read(selectedBrandProvider.notifier).state = value;
//                           },
//                         );
//                       });
//                     },
//                     error: (error, _) => Container(),
//                     loading: () => Container());
//               }),
//               Consumer(builder: (context, ref, _) {
//                 BrandModel? selected = ref.watch(selectedBrandProvider);
//                 if (selected == null) {
//                   return const SizedBox();
//                 }
//                 AsyncValue<List<PosmTypeModel>> posmTypeList = ref.watch(getPosmTypesProvider(selected.id));
//                 String lang = ref.watch(languageProvider);
//                 String hint = "Select a brand";
//                 if (lang != "en") {
//                   hint = "ব্র্যান্ড নির্বাচন করুণ";
//                 }
//                 return posmTypeList.when(
//                     data: (assetType) {
//                       return Column(
//                         children: [
//                           heading("Posm type"),
//                           Consumer(builder: (context, ref, _) {
//                             PosmTypeModel? selected = ref.watch(selectedPosmTypeProvider);
//                             return CustomSingleDropdown<PosmTypeModel>(
//                               value: selected,
//                               hintText: hint,
//                               items: assetType
//                                   .map<DropdownMenuItem<PosmTypeModel>>(
//                                       (e) => DropdownMenuItem(value: e, child: Text('${e.posmType} (${e.quantity})')))
//                                   .toList(),
//                               onChanged: (value) {
//                                 ref.read(selectedPosmTypeProvider.notifier).state = value;
//                               },
//                             );
//                           }),
//                           heading("Quantity"),
//                           Consumer(builder: (context, ref, _) {
//                             String lang = ref.watch(languageProvider);
//                             String hint = "100";
//                             if (lang != "en") {
//                               hint = "১০০";
//                             }
//                             return NormalTextField(
//                               textEditingController: quantityNumberController,
//                               hintText: hint,
//                               inputType: TextInputType.number,
//                             );
//                           }),
//                           SizedBox(
//                             width: 100.w,
//                             child: CustomImagePickerButton(
//                               type: CapturedImageType.posmPhoto,
//                               onPressed: () {
//                                 _saleController.getCapturePhoto(CapturedImageType.posmPhoto);
//                               },
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                     error: (error, _) => Container(),
//                     loading: () => Container());
//               }),
//               SizedBox(
//                 width: 42.w,
//                 child: SubmitButtonGroup(
//                   button1Label: "Submit",
//                   onButton1Pressed: () async {
//                     bool result = await _saleController.submitPosm(quantity: quantityNumberController.text);
//                     if (result == true) {
//                       Navigator.of(context).pop();
//                       quantityNumberController.clear();
//                       refreshPosmProvider();
//                     }
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   final tryBeforeBuyService = TryBeforeBuyService();
//
//   // AsyncValue<List<MaintenanceModel>> asyncAssetRequisitionList = ref.watch(getAllMaintenanceList)
//   void tryBeforeYouBuyDialogue({
//     required List<TryBeforeBuyModel> tryBeforeBuyList,
//     required OutletModel retailer,
//   }) {
//     _alerts.showModalWithWidget(
//       backgroundColor: scaffoldBGColor,
//       child: Padding(
//         padding: const EdgeInsets.all(6.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: 100.circularRadius,
//                       color: primaryGreen,
//                     ),
//                     padding: const EdgeInsets.all(3),
//                     child: const Icon(
//                       Icons.close,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10.0),
//               child: SizedBox(
//                 height: tryBeforeBuyList.length == 1
//                     ? 18.w
//                     : tryBeforeBuyList.length == 2
//                         ? (2 * 18.w) + (6.0 * 2)
//                         : tryBeforeBuyList.length == 3
//                             ? 3 * 18.w + (6.0 * 3)
//                             : 4 * 18.w + (6.0 * 4),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: tryBeforeBuyList.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     TryBeforeBuyModel tryBeforeBuy = tryBeforeBuyList[index];
//                     return InkWell(
//                       onTap: () {
//                         _saleController.selectTryBeforeBuy(ref, tryBeforeBuy: tryBeforeBuy);
//                       },
//                       child: Consumer(
//                         builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                           List<TryBeforeBuyModel> selectedTryBeforeBuy = ref.watch(selectedTryBeforeBuyProvider);
//                           bool selected = selectedTryBeforeBuy.contains(tryBeforeBuy);
//                           return Container(
//                             height: 18.w,
//                             padding: EdgeInsets.all(3.sp),
//                             margin: const EdgeInsets.only(bottom: 6),
//                             decoration: BoxDecoration(
//                               borderRadius: 5.sp.circularRadius,
//                               color: Colors.white,
//                               border: Border.all(
//                                 width: 2,
//                                 color: selected ? primaryGreen : Colors.white,
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 SizedBox(
//                                   width: 15.w,
//                                   child: AssetService(context).superImage(
//                                     '${tryBeforeBuy.sku.id}.png',
//                                     folder: "SKU",
//                                     version: SyncReadService().getAssetVersion("SKU"),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 1.w,
//                                 ),
//                                 Expanded(
//                                   child: SizedBox(
//                                     child: LangText(
//                                       tryBeforeBuy.sku.shortName,
//                                       style: TextStyle(fontSize: normalFontSize, color: darkGreen),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 1.w,
//                                 ),
//                                 Icon(
//                                   Icons.check_circle,
//                                   size: 32,
//                                   color: selected ? primaryGreen : primaryGreen.withOpacity(0.1),
//                                 ),
//                                 SizedBox(
//                                   width: 1.w,
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//             // SizedBox(
//             //   width: 42.w,
//             //   child: ,
//             // ),
//
//             SizedBox(
//               width: 42.w,
//               child: Consumer(builder: (context, ref, _) {
//                 bool internet = ref.watch(internetConnectivityProvider);
//                 LeaveManagementType leaveManagementType = ref.watch(selectedLeaveManagementTypeProvider);
//                 if (!internet) {
//                   return Center(child: LangText("No internet"));
//                 }
//                 return SubmitButtonGroup(
//                   button1Label: "Submit",
//                   onButton1Pressed: () async {
//                     await _saleController.submitTryBeforeBuy();
//                   },
//                 );
//               }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget heading(String label, [double? fontSize, Alignment? alignment]) {
//     return Align(
//       alignment: alignment ?? Alignment.centerLeft,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
//         child: LangText(
//           label,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize ?? 11.sp),
//         ),
//       ),
//     );
//   }
//
//   void refreshPosmProvider() {
//     ref.refresh(selectedBrandProvider);
//     ref.refresh(outletImageProvider(CapturedImageType.posmPhoto).notifier);
//     quantityNumberController.clear();
//   }
//
//   Widget moduleDropdown() {
//     return Consumer(
//       builder: (context, ref, _) {
//         OutletModel? selectedRetailer = ref.watch(selectedRetailerProvider);
//         if(selectedRetailer==null) {
//           return const SizedBox();
//         }
//         AsyncValue<List<Module>> asyncModules = ref.watch(moduleListProvider);
//         Module? module = ref.watch(selectedSalesModuleProvider);
//         return asyncModules.when(
//           // data: (modules) {
//           //   if (modules.isNotEmpty) {
//           //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//           //       ref.read(selectedSalesModuleProvider.notifier).state = modules[1];
//           //     });
//           //   }
//           //   return Container();
//           // },
//             data: (data) {
//               if (data.isNotEmpty) {
//                 WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//                   if (initialSet == false) {
//                     ref.read(selectedSalesModuleProvider.notifier).state = data[0];
//                     initialSet = true;
//                   }
//                 });
//               }
//               if(data.length==1){
//                 return const SizedBox();
//               }
//               return Padding(
//                 padding: EdgeInsets.only(/*left: 10.sp, right: 10.sp,*/ top: 10.sp),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.sp),
//                     color: Colors.white,
//                     // border: Border.all(color: grey, width: 1.sp)
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 2.w),
//                     child: Center(
//                       child: DropdownButton<Module>(
//                         hint: LangText(
//                           'Select a module',
//                           style: TextStyle(color: Colors.grey, fontSize: 8.sp),
//                         ),
//                         iconDisabledColor: Colors.transparent,
//                         focusColor: Theme.of(context).primaryColor,
//                         isExpanded: true,
//                         value: module,
//                         iconSize: 15.sp,
//                         items: data.map((item) {
//                           return DropdownMenuItem<Module>(
//                             value: item,
//                             child: FittedBox(
//                               child: Row(
//                                 children: [
//                                   // iconList(item.iconData),
//
//                                   SizedBox(
//                                     width: 1.w,
//                                   ),
//
//                                   LangText(
//                                     "${item.name}",
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(color: Colors.black, fontSize: normalFontSize),
//                                   ),
//                                   SizedBox(
//                                     width: 1.w, // item.totalSale.toStringAsFixed(2)
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                         style: const TextStyle(color: Colors.black),
//                         underline: Container(
//                           height: 0,
//                           color: Colors.transparent,
//                         ),
//                         onChanged: (val) {
//                           // _saleController.handleRetailerChange(val);
//                           ref.read(selectedSalesModuleProvider.notifier).state = val;
//                           // print(val!.retailerName);
//                           // salesController.handleRetailerChange(val);
//                           // salesController.handleRetailerChange(val);
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//             error: (e, s) => Text('$e'),
//             loading: () => Container());
//       },
//     );
//   }
// }