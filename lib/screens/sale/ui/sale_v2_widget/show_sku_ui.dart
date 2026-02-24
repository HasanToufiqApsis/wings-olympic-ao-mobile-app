// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sizer/sizer.dart';
// import 'package:wings_olympic_sr/constants/constant_variables.dart';
// import 'package:wings_olympic_sr/screens/sale/ui/sale_v2_widget/sku_filter_drawer.dart';
// import 'package:wings_olympic_sr/screens/sale/ui/take_product_ui.dart';
//
// import '../../../../constants/enum.dart';
// import '../../../../constants/sync_global.dart';
// import '../../../../models/module.dart';
// import '../../../../models/outlet_model.dart';
// import '../../../../models/products_details_model.dart';
// import '../../../../models/sales/memo_information_model.dart';
// import '../../../../models/sales/sales_preorder_configuration_model.dart';
// import '../../../../provider/global_provider.dart';
// import '../../../../reusable_widgets/buttons/submit_button_group.dart';
// import '../../../../reusable_widgets/custom_dialog.dart';
// import '../../../../reusable_widgets/global_widgets.dart';
// import '../../../../reusable_widgets/language_textbox.dart';
// import '../../../../reusable_widgets/sales_date_widget.dart';
// import '../../../../reusable_widgets/scaffold_widgets/appbar.dart';
// import '../../../../services/storage_prmission_service.dart';
// import '../../../../services/sync_read_service.dart';
// import '../../controller/sale_controller.dart';
// import '../preorder_category_filter_buttons.dart';
// import '../qps_offer_ui.dart';
// import '../qps_warning_ui.dart';
// import '../special_offer_ui.dart';
//
// class ShowSkuUI extends ConsumerStatefulWidget {
//   ShowSkuUI({
//     Key? key,
//     required this.allMemo,
//   }) : super(key: key);
//
//   static const routeName = "/show-sku-ui";
//
//   AllMemoInformationModel allMemo;
//
//   /// when ss come from IVR then here retailer will be received for selecting the retailer automatically
//   // RetailerModel? retailerFromIvr;
//   // IvrModel? ivr;
//
//   @override
//   _ShowSkuUIState createState() => _ShowSkuUIState();
// }
//
// class _ShowSkuUIState extends ConsumerState<ShowSkuUI> {
//   late GlobalWidgets globalWidgets;
//   late SaleController salesController;
//   late Alerts alerts;
//   late StoragePermissionService _storagePermissionService;
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       // String orderType = ref.watch(orderTypeProvider);
//       // ref.refresh(totalSoldAmountProvider(orderType));
//       // ref.refresh(orderTypeProvider);
//     });
//     super.initState();
//     //reseting global Sale Data
//     if (widget.allMemo.saleMemo.isEmpty) {
//       currentSaleData = {};
//       // currentPackRedemptionData = {};
//     }
//     if (widget.allMemo.preorderMemo.isEmpty) {
//       currentPreorderData = {};
//     }
//
//     alerts = Alerts(context: context);
//     globalWidgets = GlobalWidgets();
//     salesController = SaleController(context: context, ref: ref);
//
//     _storagePermissionService = StoragePermissionService(context: context);
//     _storagePermissionService.requestStoragePermission();
//
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
//         salesController.selectBeforeSpecialOfferNew(
//           retailerId: retailer?.id ?? 0,
//           skus: widget.allMemo.preorderMemo[0].skus,
//         );
//       }
//     });
//
//     if (widget.allMemo.saleMemo.isNotEmpty ||
//         widget.allMemo.preorderMemo.isNotEmpty) {
//       setShowSkuWhenEdit();
//       for (MemoInformationModel memoInformationModel in widget.allMemo.saleMemo) {
//         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//           // salesController
//           //     .setPackRedemptionData(memoInformationModel.packRedemptions);
//         });
//       }
//     }
//   }
//
//   setShowSkuWhenEdit() {
//     //initialize callStartTime
//     callStartTime = DateTime.now();
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.showSkus;
//       double totalPrice = 0;
//       for (MemoInformationModel memo in widget.allMemo.saleMemo) {
//         totalPrice += memo.totalSaleData.price;
//       }
//       // String orderType = ref.read(orderTypeProvider);
//       // ref.read(totalSoldAmountProvider(orderType).state).state = totalPrice;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: globalWidgets.customAppBar(
//       //     context: context,
//       //     title: widget.allMemo.preorderMemo.isNotEmpty ? "Pre-order Edit" : "Pre-order",
//       //     // iconName: 'sales.png',
//       //     keepLeadingIcon: true,
//       //     voidCallback: () {
//       //       Navigator.of(context).pop();
//       //     },
//       //     keepNotificationIcon: false,
//       //   keepDrawerIcon: true,
//       //   drawerIcon: Icons.tune_rounded,
//       // ),
//       appBar: CustomAppBar(
//         title: widget.allMemo.preorderMemo.isNotEmpty ? "Pre-order Edit" : "Pre-order",
//         titleImage: "pre_order_button.png",
//         showLeading: true,
//         // actions: [
//         //   Builder(builder: (context) {
//         //     return IconButton(
//         //       onPressed: (){
//         //         Scaffold.of(context).openEndDrawer();
//         //       },
//         //       icon: Icon(Icons.tune_rounded, color: Colors.white,),
//         //     );
//         //   }),
//         // ],
//       ),
//       // endDrawer: SkuFilterDrawer(),
//       body: SafeArea(
//         top: false,
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//
//                     SizedBox(height: 12),
//                     ///=============== Retailer Info ===========================
//                     const SalesDateWidget(),
//
//                     Consumer(
//                       builder: (context, ref, _) {
//                         AsyncValue<List<Module>> asyncModules = ref.watch(moduleListProvider);
//                         Module? module = ref.watch(selectedSalesModuleProvider);
//                         return asyncModules.when(
//                             data: (modules) {
//                               if (modules.isNotEmpty) {
//                                 WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//                                   ref.read(selectedSalesModuleProvider.notifier).state = modules[0];
//                                 });
//                               }
//                               return Container();
//                             },
//                             error: (e, s) => Text('$e'),
//                             loading: () => Container());
//                       },
//                     ),
//                     const Wrap(
//                       alignment: WrapAlignment.start,
//                       crossAxisAlignment: WrapCrossAlignment.center,
//                       runSpacing: 10.0,
//                       children: [
//                         SpecialOffer(),
//                         QpsOffer(),
//                         // PreorderCategoryFilterButtons(),
//                       ],
//                     ),
//                     QpsWarningUi(),
//                     Consumer(builder: (context, ref, _) {
//                       OutletModel? dropdownSelected = ref.watch(selectedRetailerProvider);
//                       if (dropdownSelected != null) {
//                         bool saleEdit = widget.allMemo.saleMemo.isNotEmpty ||
//                             widget.allMemo.preorderMemo.isNotEmpty;
//                         return TakePreorderUI();
//                       }
//                       return Container();
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//
//             ///=========== top container ====================================
//
//             ///============= bottom total count container =========================
//
//             Container(
//               height: 65,
//               padding: EdgeInsets.symmetric(horizontal: 3.w),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [primary, primaryBlue],
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
//                       width: MediaQuery.of(context).size.width / 2.2,
//                       child: SubmitButtonGroup(
//                         button1Label: "Proceed",
//                         onButton1Pressed: () async {
//                           ref.refresh(selectedSlabPromotion);
//                           await Future.delayed(const Duration(milliseconds: 35));
//                           currentPromotionData = {};
//                           OutletModel? retailer = ref.read(selectedRetailerProvider);
//                           List<Module>? moduleList = ref.read(moduleListProvider).value;
//                           if (retailer != null && moduleList != null) {
//                             alerts.floatingLoading();
//                             await salesController
//                                 .formattingSaleData(module: moduleList, retailer: retailer, saleEdit: widget.allMemo.preorderMemo.isNotEmpty)
//                                 .then((value) async {
//                               Navigator.of(context).pop();
//                               if (value != null) {
//                                 // _saleController.sendToExaminPage(value);
//                                 bool validateBeforeSelectedOffers = await salesController.checkBeforeSelectedOffers();
//                                 bool validateBeforeSelectedOffers2 =
//                                 await salesController.checkBeforeSelectedOffers2(value.salesPreorderDiscountDataModel);
//                                 if (validateBeforeSelectedOffers2) {
//                                   salesController.sendToExaminPage(value);
//                                 } else {
//                                   alerts.customDialog(
//                                     type: AlertType.warning,
//                                     message: "Your selected SKUs are not covered by the selected offer. Are you agree to proceed?",
//                                     button1: 'Cancel',
//                                     twoButtons: true,
//                                     button2: 'Proceed',
//                                     onTap2: () {
//                                       Navigator.pop(context);
//                                       salesController.sendToExaminPage(value);
//                                     },
//                                   );
//                                 }
//                               } else {
//                                 alerts.customDialog(type: AlertType.warning, message: "No SKU selected for sale");
//                               }
//                             });
//                           } else {
//                             if (retailer == null) {
//                               alerts.customDialog(type: AlertType.warning, message: 'Please select a retailer');
//                             } else {
//                               alerts.customDialog(type: AlertType.error, message: 'No product found');
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
//   // setSelectedModule(
//   //   WidgetRef ref,
//   //   Module module,
//   //   SalesPreorderConfigurationModel salesPreorderConfigurations,
//   // ) {
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     // ref.read(selectedSalesModuleProvider.state).state = module;
//   //     // if (salesPreorderConfigurations.availableModuleForSales.contains(
//   //     //   module.id,
//   //     // )) {
//   //     //   ref.read(orderTypeProvider.notifier).onSalePressed();
//   //     // } else if (salesPreorderConfigurations.availableModuleForPreoderder
//   //     //     .contains(
//   //     //   module.id,
//   //     // )) {
//   //     //   ref.read(orderTypeProvider.notifier).onPreOrderPressed();
//   //     // } else {
//   //     //   ref.read(orderTypeProvider.notifier).onOrderTypePressed();
//   //     // }
//   //   });
//   // }
// }
