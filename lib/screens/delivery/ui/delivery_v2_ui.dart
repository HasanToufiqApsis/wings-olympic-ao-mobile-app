import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/reusable_widgets/sales_date_widget.dart';
import 'package:wings_olympic_sr/screens/sale/model/product_view.dart';
import 'package:wings_olympic_sr/screens/sale/ui/sale_v2_widget/sku_list_tile.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_keys.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../models/module.dart';
import '../../../models/outlet_model.dart';
import '../../../models/products_details_model.dart';
import '../../../models/sale_summary_model.dart';
import '../../../models/sales/sale_data_model.dart';
import '../../../models/sales/sku_classification.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../reusable_widgets/taka_icon.dart';
import '../../../services/asset_download/asset_service.dart';
import '../../../services/shared_storage_services.dart';
import '../../../services/sync_read_service.dart';
import '../../../utils/case_piece_type_utils.dart';
import '../../../utils/sales_type_utils.dart';
import '../../sale/controller/sale_controller.dart';
import '../../sale/providers/sale_providers.dart';
import '../../sale/ui/preorder_edit_dialog.dart';
import '../../sale/ui/promotion_ui.dart';
import '../../sale/ui/sale_v2_widget/search_container.dart';
import '../../sale/ui/sale_v2_widget/tab_widget.dart';
import '../../sale/ui/sale_v2_widget/three_option_button.dart';
import '../../sale/ui/sku_case_piece_show_widget.dart';
import '../../sale/ui/sku_search/sku_search_delegate.dart';

class DeliveryV2UI extends ConsumerStatefulWidget {
  static const routeName = "/delivery_ui_v2";

  const DeliveryV2UI({Key? key}) : super(key: key);

  @override
  ConsumerState<DeliveryV2UI> createState() => _DeliveryV2UIState();
}

class _DeliveryV2UIState extends ConsumerState<DeliveryV2UI> with SingleTickerProviderStateMixin{
  Map<String, List<ProductDetailsModel>> byClassificationProductData = {};
  final _cartClassification = SkuClassification(id: -1, name: 'All');
  late final TabController? _tabController;
  final List<SkuClassification> _skuClassificationList = [];
  late final SyncReadService _syncReadService;

  late SaleController saleController;
  late final Alerts _alerts;

  @override
  void initState() {
    saleController = SaleController(context: context, ref: ref);
    _alerts = Alerts(context: context);

    _syncReadService = SyncReadService();
    _initiateClassificationListAndTabController();

    super.initState();
  }

  void _initiateClassificationListAndTabController() {
    _skuClassificationList.add(SkuClassification(id: 0, name: 'All'));
    _skuClassificationList.addAll(_syncReadService.getSkuClassifications());
    _tabController = TabController(
      length: _skuClassificationList.length,
      vsync: this,
      initialIndex: 0,
    );
  }

  bool initialSet = false;
  bool disableForUsingCoupon = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Delivery",
          titleImage: "pre_order_button.png",
          showLeading: true,
        ),
        body: Consumer(builder: (context, ref, _) {
          Module? selectedModule = ref.watch(selectedSalesModuleProvider);
          OutletModel? outlet = ref.watch(selectedRetailerProvider);

          return Column(
            children: [
              Expanded(
                child: Consumer(builder: (context, ref, _) {
                  final asyncSummaryData = ref.watch(salesSummaryProvider(SaleType.delivery));
                  final asyncTotalRetailer = ref.watch(totalRetailerProvider(SaleType.delivery));
                  final asyncPreOrderData = ref.watch(preorderPerRetailerProvider);

                  return asyncPreOrderData.when(
                    data: (preOrderData) {
                      return asyncTotalRetailer.when(
                        data: (totalRetailer) {
                          return asyncSummaryData.when(
                            data: (summaryData) {
                              final skuIdWiseSalesSummary = <int, SalesSummaryModel>{};
                              for (var entry in summaryData.entries) {
                                for (var sum in entry.value) {
                                  skuIdWiseSalesSummary[sum.sku.id] = sum;
                                }
                              }

                              return Consumer(
                                builder: (context, ref, _) {
                                  OutletModel? selectedRetailer =
                                      ref.watch(selectedRetailerProvider);
                                  if (selectedRetailer == null) {
                                    return const SizedBox();
                                  }
                                  AsyncValue<List<Module>> asyncModules =
                                      ref.watch(moduleListProvider);
                                  Module? module = ref.watch(selectedSalesModuleProvider);
                                  final viewType = ref.watch(productViewTypeProvider);
                                  return asyncModules.when(
                                    data: (data) {
                                      if (data.isNotEmpty) {
                                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                          if (initialSet == false) {
                                            ref.read(selectedSalesModuleProvider.notifier).state =
                                                data.first;
                                            initialSet = true;
                                          }
                                        });
                                      }

                                      return CustomScrollView(
                                        slivers: [
                                          SliverAppBar(
                                            floating: true,
                                            pinned: true,
                                            expandedHeight: expandedHeight,
                                            automaticallyImplyLeading: false,
                                            toolbarHeight: kToolbarHeight + kToolbarHeight,
                                            flexibleSpace: Stack(
                                              children: [
                                                // Collapsible background using FlexibleSpaceBar
                                                const FlexibleSpaceBar(
                                                  collapseMode: CollapseMode.parallax,
                                                  background: SalesDateWidget(),
                                                ),

                                                // Manually pinned title bar (fixed size, no scaling)
                                                Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Container(
                                                    height: kToolbarHeight + kToolbarHeight,
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    color: Colors.white,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              // Expanded(
                                                              //   child: SizedBox(
                                                              //     height: 40,
                                                              //     child: TextFormField(
                                                              //       focusNode: _searchNode,
                                                              //       onTap: () {
                                                              //
                                                              //       },
                                                              //       decoration: InputDecoration(
                                                              //         hintText: 'Search...',
                                                              //         contentPadding: EdgeInsets.symmetric(
                                                              //           horizontal: 8,
                                                              //           vertical: 0,
                                                              //         ),
                                                              //         border: inputBorder,
                                                              //         focusedBorder: focussedInputBorder,
                                                              //         enabledBorder: inputBorder,
                                                              //         hintStyle: TextStyle(color: Colors.grey.shade300),
                                                              //       ),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                              Expanded(
                                                                child: Consumer(builder: (context, ref, _) {
                                                                  final selectedModule =
                                                                  ref.watch(selectedSalesModuleProvider);
                                                                  if (selectedModule == null) {
                                                                    return const SizedBox();
                                                                  }
                                                                  return SearchContainer(
                                                                    onTap: () async {
                                                                      if (byClassificationProductData.isEmpty) {
                                                                        return;
                                                                      }
                                                                      await showSearch(
                                                                        context: context,
                                                                        delegate: SkuSearchDelegate(
                                                                          saleController: saleController,
                                                                          data: byClassificationProductData,
                                                                          skuIdWiseSalesSummary:
                                                                          skuIdWiseSalesSummary,
                                                                          totalRetailerCount: totalRetailer,
                                                                          preOrderData: preOrderData,
                                                                          viewType: viewType,
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                }),
                                                              ),
                                                              4.horizontalSpacing,
                                                              Consumer(
                                                                builder: (context, ref, _) {
                                                                  return ThreeOptionButton(
                                                                    value: viewType,
                                                                    onTap: (type) {
                                                                      ref
                                                                          .read(productViewTypeProvider.notifier)
                                                                          .state = type;
                                                                      LocalStorageHelper.save(viewComplexityKey, type.label);
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Consumer(builder: (context, ref, _) {
                                                          final cls = ref.watch(selectedClassificationProvider);

                                                          return Row(
                                                            children: [
                                                              InkResponse(
                                                                onTap: () {
                                                                  ref
                                                                      .read(
                                                                      selectedClassificationProvider.notifier)
                                                                      .state = _cartClassification;
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: cls?.id == -1
                                                                        ? const Color(0xFFCFDEED)
                                                                        : Colors.transparent,
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    border:
                                                                    Border.all(color: Colors.grey.shade300),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal: 16,
                                                                      vertical: 8,
                                                                    ),
                                                                    child: Icon(
                                                                      Icons.shopping_cart,
                                                                      size: 16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              4.horizontalSpacing,
                                                              Expanded(
                                                                child: TabBar(
                                                                  controller: _tabController,
                                                                  dividerColor: Colors.transparent,
                                                                  isScrollable: true,
                                                                  physics: const BouncingScrollPhysics(),
                                                                  padding: EdgeInsets.zero,
                                                                  indicatorAnimation:
                                                                  TabIndicatorAnimation.elastic,
                                                                  indicator: BoxDecoration(
                                                                    color: cls?.id == -1
                                                                        ? Colors.transparent
                                                                        : const Color(0xFFCFDEED),
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  tabAlignment: TabAlignment.start,
                                                                  indicatorSize: TabBarIndicatorSize.tab,
                                                                  labelColor: Colors.black,
                                                                  unselectedLabelColor: Colors.black,
                                                                  splashBorderRadius: BorderRadius.circular(10),
                                                                  labelPadding: const EdgeInsets.symmetric(
                                                                    horizontal: 4,
                                                                    vertical: 0,
                                                                  ),
                                                                  indicatorPadding: EdgeInsets.symmetric(
                                                                    horizontal: 4,
                                                                    vertical: 2,
                                                                  ),
                                                                  onTap: (index) {
                                                                    ref
                                                                        .read(selectedClassificationProvider
                                                                        .notifier)
                                                                        .state = _skuClassificationList[index];
                                                                  },
                                                                  tabs: _skuClassificationList
                                                                      .map((classification) {
                                                                    switch (classification.id) {
                                                                      default:
                                                                        return TabWidget(
                                                                          text: classification.name ?? '-',
                                                                        );
                                                                    }
                                                                  }).toList(),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                        8.verticalSpacing,
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SliverToBoxAdapter(
                                            child: Column(
                                              children: [
                                                if (data.length > 1) ...[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      /*left: 10.sp, right: 10.sp,*/
                                                        top: 10.sp),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10.sp),
                                                        color: Colors.white,
                                                        // border: Border.all(color: grey, width: 1.sp)
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                                                        child: Center(
                                                          child: DropdownButton<Module>(
                                                            hint: LangText(
                                                              'Select a module',
                                                              style: TextStyle(
                                                                  color: Colors.grey, fontSize: 8.sp),
                                                            ),
                                                            iconDisabledColor: Colors.transparent,
                                                            focusColor: Theme.of(context).primaryColor,
                                                            isExpanded: true,
                                                            value: module,
                                                            iconSize: 15.sp,
                                                            items: data.map((item) {
                                                              return DropdownMenuItem<Module>(
                                                                value: item,
                                                                child: FittedBox(
                                                                  child: Row(
                                                                    children: [
                                                                      // iconList(item.iconData),

                                                                      SizedBox(
                                                                        width: 1.w,
                                                                      ),

                                                                      LangText(
                                                                        item.name,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: normalFontSize),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 1
                                                                            .w, // item.totalSale.toStringAsFixed(2)
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            style: const TextStyle(color: Colors.black),
                                                            underline: Container(
                                                              height: 0,
                                                              color: Colors.transparent,
                                                            ),
                                                            onChanged: (val) {
                                                              // _saleController.handleRetailerChange(val);
                                                              ref
                                                                  .read(selectedSalesModuleProvider
                                                                  .notifier)
                                                                  .state = val;
                                                              // print(val!.retailerName);
                                                              // salesController.handleRetailerChange(val);
                                                              // salesController.handleRetailerChange(val);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                                Consumer(
                                                  builder: (BuildContext context, WidgetRef ref,
                                                      Widget? child) {
                                                    OutletModel? selectedRetailer =
                                                    ref.watch(selectedRetailerProvider);
                                                    if (selectedRetailer == null) {
                                                      return const SizedBox();
                                                    }
                                                    AsyncValue<bool> alreadyUseCoupon = ref.watch(
                                                        disableEditForCouponDiscountProvider(outlet!));
                                                    if (selectedModule == null) {
                                                      return SizedBox();
                                                    }
                                                    // AsyncValue<List<ProductDetailsModel>> asyncSkus =
                                                    // ref.watch(
                                                    //     deliveryListFutureProvider(selectedModule));
                                                    final asyncSkuByClassification = ref.watch(skuListGroupByClassificationProviderForDelivery(selectedModule));

                                                    return alreadyUseCoupon.when(
                                                      data: (couponUsed) {
                                                        return asyncSkuByClassification.when(
                                                          data: (skuByClassification) {

                                                            byClassificationProductData = skuByClassification;

                                                            return IgnorePointer(
                                                              ignoring: false,
                                                              child: Consumer(
                                                                builder: (context, ref, _) {
                                                                  final selectedClassification =
                                                                  ref.watch(selectedClassificationProvider);
                                                                  SkuClassification classification =
                                                                      selectedClassification ?? _skuClassificationList[0];
                                                                  final productList =
                                                                      skuByClassification[classification.name ?? ''] ?? [];

                                                                  return ListView.builder(
                                                                    itemCount: productList.length,
                                                                    primary: false,
                                                                    shrinkWrap: true,
                                                                    padding: EdgeInsets.only(
                                                                      bottom: 32,
                                                                      top: 8,
                                                                      left: 8,
                                                                      right: 8,
                                                                    ),
                                                                    itemBuilder: (context, i) {
                                                                      final memoCount = skuIdWiseSalesSummary[productList[i].id]?.memo ?? 0;
                                                                      final bcp = memoCount == 0 ? 0.0 : (memoCount / totalRetailer) * 100;
                                                                      final preOrderVolume = preOrderData[productList[i].id.toString()] ?? 0;

                                                                      final tile = SkuListTile(
                                                                        sku: productList[i],
                                                                        saleController: saleController,
                                                                        showPreorderInfo: true,
                                                                        saleType: SaleType.delivery,
                                                                        viewType: viewType,
                                                                        isFirstItem: i == 0,
                                                                        isLastItem: i == productList.length - 1,
                                                                        bcpValue: bcp,
                                                                        preOrderVolume: preOrderVolume,
                                                                        soqVolume: 0,
                                                                      );

                                                                      if (selectedClassification?.id == -1) {
                                                                        final saleData = ref.read(saleSkuAmountProvider(productList[i]));

                                                                        if (saleData.qty <= 0) {
                                                                          return SizedBox();
                                                                        }

                                                                        return tile;
                                                                      }

                                                                      return tile;
                                                                    },
                                                                  );
                                                                }
                                                              ),
                                                            );
                                                          },
                                                          error: (e, s) => Text('$e'),
                                                          loading: () => const Center(
                                                            child: CircularProgressIndicator(),
                                                          ),
                                                        );
                                                      },
                                                      error: (e, s) => Text('$e'),
                                                      loading: () => const Center(
                                                        child: CircularProgressIndicator(),
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    error: (error, stck) {
                                      return const SizedBox();
                                    },
                                    loading: () => const SizedBox(),
                                  );
                                },
                              );
                            },
                            error: (error, stck) => const SizedBox(),
                            loading: () => const SizedBox(),
                          );
                        },
                        error: (e, s) => Text('$e'),
                        loading: () => Container(),
                      );
                    },
                    error: (error, stck) => const SizedBox(),
                    loading: () => const SizedBox(),
                  );
                }),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primary, primaryBlue],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TakaIcon(
                          color: Colors.white,
                          size: 24,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Consumer(builder: (context, ref, _) {
                          num soldAmount = ref.watch(totalSoldAmountProvider);
                          return LangText(
                            soldAmount.toStringAsFixed(2),
                            isNumber: true,
                            style: TextStyle(fontSize: 16.sp, color: Colors.white),
                          );
                        })
                      ],
                    ),
                    SizedBox(
                        width: 48.w,
                        child: SubmitButtonGroup(
                          button1Label: "Proceed",
                          onButton1Pressed: () async {
                            ref.refresh(selectedSlabPromotion);
                            await Future.delayed(const Duration(milliseconds: 35));
                            currentPromotionData = {};
                            OutletModel? retailer = ref.read(selectedRetailerProvider);
                            List<Module>? moduleList = ref.read(moduleListProvider).value;
                            if (retailer != null && moduleList != null) {
                              _alerts.floatingLoading();
                              await saleController
                                  .formattingSaleData(
                                      module: moduleList, retailer: retailer, saleEdit: false)
                                  .then((value) async {
                                Navigator.of(context).pop();
                                if (value != null) {
                                  //setting sale type as delivery
                                  value.saleType = SaleType.delivery;

                                  bool validateBeforeSelectedOffers =
                                      await saleController.checkBeforeSelectedOffers();
                                  bool validateBeforeSelectedOffers2 =
                                      await saleController.checkBeforeSelectedOffers2(
                                          value.salesPreorderDiscountDataModel);

                                  if (validateBeforeSelectedOffers2) {
                                    saleController.sendToExaminPage(value);
                                  } else {
                                    _alerts.customDialog(
                                      type: AlertType.warning,
                                      message:
                                          "Your selected SKUs are not covered by the selected offer. Are you agree to proceed?",
                                      button1: 'Cancel',
                                      twoButtons: true,
                                      button2: 'Proceed',
                                      onTap2: () {
                                        Navigator.pop(context);
                                        saleController.sendToExaminPage(value);
                                      },
                                    );
                                  }
                                } else {
                                  saleController.handleZeroSale(retailer);
                                }
                              });
                            } else {
                              if (retailer == null) {
                                _alerts.customDialog(
                                    type: AlertType.warning, message: 'Please select a retailer');
                              } else {
                                _alerts.customDialog(
                                    type: AlertType.error, message: 'No product found');
                              }
                            }
                          },
                        )),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class SKUItem extends ConsumerWidget {
  SKUItem(
      {Key? key,
      required this.saleType,
      required this.sku,
      required this.saleController,
      required this.showPreorderInfo})
      : super(key: key);
  ProductDetailsModel sku;
  final bool showPreorderInfo;
  SaleType saleType;

  GlobalWidgets globalWidgets = GlobalWidgets();
  final SaleController saleController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.sp),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                children: [
                  ///sku image and name
                  InkWell(
                    onTap: () async {
                      OutletModel? dropdownSelected = ref.read(selectedRetailerProvider);
                      if (dropdownSelected != null) {
                        Alerts(context: context).showModalWithWidget(
                          child: PreorderEditDialogUI(
                            sku,
                            globalWidgets,
                            saleType: saleType,
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 15.w,
                          // height: 8.h,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.sp, bottom: 5.sp),
                            child: AssetService(context).superImage('${sku.id}.png',
                                folder: 'SKU',
                                version: SyncReadService().getAssetVersion('SKU'),
                                height: 12.h),
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        SizedBox(
                          width: 15.w,
                          child: LangText(
                            sku.shortName,
                            style: TextStyle(fontSize: normalFontSize, color: darkGreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),

                  ///offer, count and stock
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PromotionUI(sku: sku),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                // saleController.decrement(sku);
                                saleController.decrement(
                                  sku,
                                  casePieceType:
                                      saleType == SaleType.preorder ? null : CasePieceType.PIECE,
                                );

                                // salesController.decrement(widget.item[index]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.sp),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [green, darkGreen],
                                  ),
                                ),
                                child: Icon(Icons.remove, color: Colors.white, size: 15.sp),
                              ),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Consumer(builder: (context, ref, _) {
                              SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));
                              // ref.read(saleEditSkuAmountProvider(widget.item[index]).notifier).state = count;
                              return InkWell(
                                onTap: () {
                                  OutletModel? dropdownSelected =
                                      ref.read(selectedRetailerProvider);
                                  if (dropdownSelected != null) {
                                    Alerts(context: context).showModalWithWidget(
                                      child: PreorderEditDialogUI(
                                        sku,
                                        globalWidgets,
                                        saleType: saleType,
                                      ),
                                    );
                                  }
                                },
                                child: Center(
                                  child: SizedBox(
                                    width: 18.w,
                                    // height: 15.h,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Consumer(builder: (context, ref, _) {
                                          // CasePieceType type = ref.watch(selectedCasePieceTypeProvider);

                                          CasePieceType type = saleType == SaleType.preorder
                                              ? ref.watch(selectedCasePieceTypeProvider)
                                              : CasePieceType.PIECE;

                                          return SKUCasePieceShowWidget(
                                            sku: sku,
                                            qty: saleData.qty,
                                            casePieceType: type,
                                          );
                                        }),
                                        Divider(
                                          color: Colors.grey,
                                          height: 1.w,
                                          thickness: 0.2.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                            SizedBox(
                              width: 1.w,
                            ),
                            InkWell(
                              onTap: () {
                                saleController.increment(
                                  sku,
                                  casePieceType: saleType == SaleType.preorder
                                      ? CasePieceType.CASE
                                      : CasePieceType.PIECE,
                                );
                                // salesController.increment(widget.item[index]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.sp),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [green, darkGreen],
                                  ),
                                ),
                                child: Icon(Icons.add, color: Colors.white, size: 15.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                      showPreorderInfo
                          ? Consumer(builder: (context, ref, _) {
                              AsyncValue<Map<String, dynamic>> asyncPreorderPerRetailer =
                                  ref.watch(preorderPerRetailerProvider);
                              return asyncPreorderPerRetailer.when(
                                  data: (preorderData) {
                                    return Builder(builder: (context) {
                                      if (preorderData.containsKey(sku.id.toString())) {
                                        int preorderAmount = int.tryParse(
                                                preorderData[sku.id.toString()].toString()) ??
                                            0;
                                        if (preorderAmount > 0) {
                                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                            ref
                                                .read(saleSkuAmountProvider(sku).notifier)
                                                .increment(preorderAmount);
                                          });
                                        }

                                        return Container(
                                          height: 3.h,
                                          width: 30.w,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(50.sp),
                                                  topLeft: Radius.circular(50.sp)),
                                              color: Color(0xFFBADEFF)),
                                          child: Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.note_alt_outlined,
                                                  color: Color(0xFFE72582),
                                                  size: 10.sp,
                                                ),
                                                SizedBox(
                                                  width: 1.w,
                                                ),

                                                ///phase 1
                                                // SKUCasePieceShowWidget(
                                                //   sku: sku,
                                                //   qty: preorderData[sku.id.toString()],
                                                //   showUnitName: true,
                                                //   qtyTextStyle: TextStyle(fontSize: 10.sp, color: darkGrey, fontWeight: FontWeight.bold),
                                                //   unitTextStyle: TextStyle(fontSize: 10.sp, color: darkGrey),
                                                // ),

                                                ///phase 2
                                                Consumer(builder: (context, ref, _) {
                                                  // CasePieceType type = ref.watch(selectedCasePieceTypeProvider);
                                                  CasePieceType type = saleType == SaleType.preorder
                                                      ? CasePieceType.CASE
                                                      : CasePieceType.PIECE;

                                                  return SKUCasePieceShowWidget(
                                                    sku: sku,
                                                    qty: preorderData[sku.id.toString()],
                                                    casePieceType: type,
                                                    pieceWithQty: saleType == SaleType.delivery
                                                        ? true
                                                        : false,
                                                    showUnitName: true,
                                                    qtyTextStyle: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: darkGrey,
                                                        fontWeight: FontWeight.bold),
                                                    unitTextStyle:
                                                        TextStyle(fontSize: 10.sp, color: darkGrey),
                                                  );
                                                })

                                                // LangText(
                                                //   '${preorderData[sku.id.toString()]}',
                                                //   isNumber: true,
                                                //   style: TextStyle(color: darkGrey, fontSize: 10.sp),
                                                // )
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
                          : SizedBox(
                              height: 3.h,
                              width: 30.w,
                            ),
                    ],
                  ),
                  SizedBox(
                    width: 3.w,
                  ),

                  ///other infos
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));

                        return LangText(
                          saleData.price.toStringAsFixed(2),
                          isNumber: true,
                          style: TextStyle(
                              fontSize: 12.sp, color: darkGrey, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 1.h,
              right: 3.w,
              child: Consumer(builder: (context, ref, _) {
                SaleDataModel saleData = ref.watch(saleSkuAmountProvider(sku));
                CasePieceType type =
                    saleType == SaleType.preorder ? CasePieceType.CASE : CasePieceType.PIECE;

                return SKUCasePieceShowWidget(
                  sku: sku,
                  qty: saleData.qty,
                  showUnitName: true,
                  pieceWithQty: saleType == SaleType.delivery ? true : false,
                  casePieceType: type,
                  qtyTextStyle:
                      TextStyle(fontSize: 10.sp, color: darkGrey, fontWeight: FontWeight.bold),
                  unitTextStyle: TextStyle(fontSize: 10.sp, color: darkGrey),
                );
              }),
            ),
            Visibility(
              visible: kDebugMode,
              child: Text(
                "${sku.id}",
                style: TextStyle(color: Colors.black.withOpacity(0.05)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
