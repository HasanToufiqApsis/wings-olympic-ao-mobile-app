import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_keys.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';
import 'package:wings_olympic_sr/models/sale_summary_model.dart';
import 'package:wings_olympic_sr/models/sales/sku_classification.dart';
import 'package:wings_olympic_sr/reusable_widgets/taka_icon.dart';
import 'package:wings_olympic_sr/screens/sale/providers/sale_providers.dart';
import 'package:wings_olympic_sr/screens/sale/ui/sale_v2_widget/search_container.dart';
import 'package:wings_olympic_sr/screens/sale/ui/sale_v2_widget/tab_widget.dart';
import 'package:wings_olympic_sr/screens/sale/ui/sale_v2_widget/take_product_ui_v2.dart';
import 'package:wings_olympic_sr/screens/sale/ui/sale_v2_widget/three_option_button.dart';
import 'package:wings_olympic_sr/screens/sale/ui/sku_search/sku_search_delegate.dart';
import 'package:wings_olympic_sr/services/product_category_services.dart';
import 'package:wings_olympic_sr/services/shared_storage_services.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../../../constants/enum.dart';
import '../../../../constants/sync_global.dart';
import '../../../../models/module.dart';
import '../../../../models/outlet_model.dart';
import '../../../../models/products_details_model.dart';
import '../../../../models/sales/memo_information_model.dart';
import '../../../../models/try_before_buy/try_before_buy_model.dart';
import '../../../../provider/global_provider.dart';
import '../../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../../reusable_widgets/custom_dialog.dart';
import '../../../../reusable_widgets/global_widgets.dart';
import '../../../../reusable_widgets/language_textbox.dart';
import '../../../../reusable_widgets/sales_date_widget.dart';
import '../../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../../services/asset_download/asset_service.dart';
import '../../../../services/storage_prmission_service.dart';
import '../../../../services/sync_read_service.dart';
import '../../controller/sale_controller.dart';
import '../qps_warning_ui.dart';
import 'special_offer_and_qps_offer_widget.dart';

class ShowSkuUIV2 extends ConsumerStatefulWidget {
  static const routeName = "/show-sku-ui";

  final SaleType saleType;
  AllMemoInformationModel allMemo;

  ShowSkuUIV2({
    Key? key,
    required this.allMemo,
    required this.saleType,
  }) : super(key: key);

  @override
  _ShowSkuUIState createState() => _ShowSkuUIState();
}

class _ShowSkuUIState extends ConsumerState<ShowSkuUIV2> with SingleTickerProviderStateMixin {
  final _sliverScrollController = ScrollController();
  final _searchNode = FocusNode();
  late final TabController? _tabController;
  Map<String, List<ProductDetailsModel>> byClassificationProductData = {};
  final _cartClassification = SkuClassification(id: -1, name: 'All');

  late final SyncReadService _syncReadService;
  final List<SkuClassification> _skuClassificationList = [];

  late GlobalWidgets globalWidgets;
  late SaleController salesController;
  late Alerts alerts;
  late StoragePermissionService _storagePermissionService;
  late SaleController _saleController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // String orderType = ref.watch(orderTypeProvider);
      // ref.refresh(totalSoldAmountProvider(orderType));
      // ref.refresh(orderTypeProvider);
    });
    super.initState();
    _saleController = SaleController(context: context, ref: ref);
    //reseting global Sale Data
    if (widget.allMemo.saleMemo.isEmpty) {
      currentSaleData = {};
      // currentPackRedemptionData = {};
    }
    if (widget.allMemo.preorderMemo.isEmpty) {
      currentPreorderData = {};
    }

    alerts = Alerts(context: context);
    globalWidgets = GlobalWidgets();
    salesController = SaleController(context: context, ref: ref);

    _storagePermissionService = StoragePermissionService(context: context);
    _storagePermissionService.requestStoragePermission();

    _syncReadService = SyncReadService();
    _initiateClassificationListAndTabController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.allMemo.preorderMemo.isNotEmpty) {
        ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.showSkus;
        currentPreorderData = {};
        for (PreorderMemoInformationModel preorderMemoInformationModel
            in widget.allMemo.preorderMemo) {
          currentPreorderData[preorderMemoInformationModel.module.id] = {};
          for (ProductDetailsModel sku in preorderMemoInformationModel.skus) {
            if (sku.preorderData != null) {
              currentPreorderData[preorderMemoInformationModel.module.id][sku.id] =
                  sku.preorderData!.qty;
              ref
                  .read(saleSkuAmountProvider(sku).notifier)
                  .incrementDecrementAmount(sku.preorderData!.qty, true);
            }
          }
        }

        var retailer = ref.read(selectedRetailerProvider);

        salesController.selectBeforeSpecialOfferNew(
          retailerId: retailer?.id ?? 0,
          skus: widget.allMemo.preorderMemo[0].skus,
        );
      }
    });

    if (widget.allMemo.saleMemo.isNotEmpty || widget.allMemo.preorderMemo.isNotEmpty) {
      setShowSkuWhenEdit();
      for (MemoInformationModel memoInformationModel in widget.allMemo.saleMemo) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          // salesController
          //     .setPackRedemptionData(memoInformationModel.packRedemptions);
        });
      }
    }
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

  setShowSkuWhenEdit() {
    //initialize callStartTime
    callStartTime = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.showSkus;
      double totalPrice = 0;
      for (MemoInformationModel memo in widget.allMemo.saleMemo) {
        totalPrice += memo.totalSaleData.price;
      }
      // String orderType = ref.read(orderTypeProvider);
      // ref.read(totalSoldAmountProvider(orderType).state).state = totalPrice;
    });
  }

  @override
  void dispose() {
    _sliverScrollController.dispose();
    _tabController?.dispose();
    _searchNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: _getTitleText(widget.allMemo.preorderMemo, widget.saleType),
          titleImage: "pre_order_button.png",
          showLeading: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer(builder: (context, ref, _) {
                final asyncSummaryData = ref.watch(salesSummaryProvider(widget.saleType));
                final asyncTotalRetailer = ref.watch(totalRetailerProvider(widget.saleType));
                final asyncPreOrderData = ref.watch(preorderPerRetailerProvider);
                final viewType = ref.watch(productViewTypeProvider);

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

                            return CustomScrollView(
                              controller: _sliverScrollController,
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
                                                        if (selectedModule == null)
                                                          return const SizedBox();
                                                        return SearchContainer(
                                                          onTap: () async {
                                                            if (byClassificationProductData.isEmpty) {
                                                              return;
                                                            }
                                                            await showSearch(
                                                              context: context,
                                                              delegate: SkuSearchDelegate(
                                                                saleController: salesController,
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
                                                            ref.read(productViewTypeProvider.notifier)
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
                                      Consumer(
                                        builder: (context, ref, _) {
                                          AsyncValue<List<Module>> asyncModules =
                                          ref.watch(moduleListProvider);
                                          Module? module = ref.watch(selectedSalesModuleProvider);
                                          return asyncModules.when(
                                            data: (modules) {
                                              if (modules.isNotEmpty) {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((timeStamp) {
                                                  ref.read(selectedSalesModuleProvider.notifier).state =
                                                  modules[0];
                                                });
                                              }
                                              return Container();
                                            },
                                            error: (e, s) => Text('$e'),
                                            loading: () => Container(),
                                          );
                                        },
                                      ),
                                      8.verticalSpacing,
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: const SpecialOfferAndQpsOfferWidget(),
                                      ),
                                      QpsWarningUi(),
                                      Row(
                                        children: [
                                          SizedBox(width: 10,),
                                          Consumer(
                                            builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                              OutletModel? dropdownSelected = ref.watch(selectedRetailerProvider);
                                              OutletSaleStatus geoFencingStatus = ref.watch(outletSaleStatusProvider);

                                              if (dropdownSelected != null) {
                                                AsyncValue<List<TryBeforeBuyModel>> skuList = ref.watch(allTryBeforeBuySkuForSpecificRetailer(dropdownSelected));

                                                if (skuList.value?.isNotEmpty ?? false) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(top: 2.sp, right: 10),
                                                    child: SingleCustomButton(
                                                      color: primary,
                                                      label: "Try Before Buy",
                                                      onPressed: () {
                                                        tryBeforeYouBuyDialogue(tryBeforeBuyList: skuList.value!, retailer: dropdownSelected);
                                                      },
                                                      icon: null,
                                                      shrinkWrap: true,
                                                      smallSize: true,
                                                      maxWidth: false,
                                                    ),
                                                  );
                                                }
                                                return const SizedBox();
                                              }
                                              return const SizedBox();
                                            },
                                          ),
                                        ],
                                      ),
                                      8.verticalSpacing,
                                      Consumer(builder: (context, ref, _) {
                                        final selectedRetailer = ref.watch(selectedRetailerProvider);
                                        if (selectedRetailer == null) return const SizedBox();
                                        final selectedModule = ref.watch(selectedSalesModuleProvider);
                                        if (selectedModule == null) return const SizedBox();
                                        final syncSkuByClassification = ref.watch(
                                            skuListGroupByClassificationProvider(selectedModule));

                                        return syncSkuByClassification.when(
                                          data: (skuByClassification) {

                                            byClassificationProductData = skuByClassification;

                                            return Consumer(builder: (context, ref, _) {
                                              final selectedClassification =
                                              ref.watch(selectedClassificationProvider);
                                              SkuClassification classification =
                                                  selectedClassification ?? _skuClassificationList[0];
                                              final productList =
                                                  skuByClassification[classification.name ?? ''] ?? [];
                                              List<ProductDetailsModel> finalProduct = [];
                                              if (widget.saleType == SaleType.spotSale) {
                                                for (var sku in productList) {
                                                  if (sku.stocks.liftingStock > 0) {
                                                    finalProduct.add(sku);
                                                  }
                                                }
                                              } else {
                                                finalProduct = productList;
                                              }


                                              if (widget.saleType == SaleType.spotSale) {
                                                salesController.changeStockWhenEditingStock(finalProduct, widget.allMemo.preorderMemo);
                                              } else if (widget.saleType == SaleType.preorder) {
                                                salesController.changePreorderStockWhenEditingStock(finalProduct, widget.allMemo.preorderMemo);
                                              }



                                              return TakeProductUIV2(
                                                saleType: widget.saleType,
                                                skus: finalProduct,
                                                showOnlySelected: selectedClassification?.id == -1,
                                                skuIdWiseSalesSummary: skuIdWiseSalesSummary,
                                                totalRetailerCount: totalRetailer,
                                                preOrderData: preOrderData,
                                                viewType: viewType,
                                              );
                                            });
                                          },
                                          error: (err, stack) => const SizedBox(),
                                          loading: () => Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }),
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
                      error: (error, stck) => const SizedBox(),
                      loading: () => const SizedBox(),
                    );
                  },
                  error: (error, stck) => const SizedBox(),
                  loading: () => const SizedBox(),
                );
              }),
            ),
            Container(
              height: 9.h,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: const BoxDecoration(
                gradient: primaryGradient,
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
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 2.2,
                    child: SingleCustomButton(
                      color: primary, label: 'Proceed', onPressed: () async {
                      ref.refresh(selectedSlabPromotion);
                      await Future.delayed(const Duration(milliseconds: 35));
                      currentPromotionData = {};
                      OutletModel? retailer = ref.read(selectedRetailerProvider);
                      List<Module>? moduleList = ref
                          .read(moduleListProvider)
                          .value;
                      if (retailer != null && moduleList != null) {
                        alerts.floatingLoading();
                        await salesController
                            .formattingSaleData(
                            module: moduleList,
                            retailer: retailer,
                            saleEdit: widget.allMemo.preorderMemo.isNotEmpty)
                            .then((value) async {
                          Navigator.of(context).pop();
                          if (value != null) {
                            value.saleType = widget.saleType;
                            // _saleController.sendToExaminPage(value);
                            bool validateBeforeSelectedOffers =
                            await salesController.checkBeforeSelectedOffers();
                            bool validateBeforeSelectedOffers2 = await salesController
                                .checkBeforeSelectedOffers2(value.salesPreorderDiscountDataModel);
                            if (validateBeforeSelectedOffers2) {
                              salesController.sendToExaminPage(value);
                            } else {
                              alerts.customDialog(
                                type: AlertType.warning,
                                message:
                                "Your selected SKUs are not covered by the selected offer. Are you agree to proceed?",
                                button1: 'Cancel',
                                twoButtons: true,
                                button2: 'Proceed',
                                onTap2: () {
                                  Navigator.pop(context);
                                  salesController.sendToExaminPage(value);
                                },
                              );
                            }
                          } else {
                            alerts.customDialog(
                                type: AlertType.warning, message: "No SKU selected for sale");
                          }
                        });
                      } else {
                        if (retailer == null) {
                          alerts.customDialog(
                              type: AlertType.warning, message: 'Please select a retailer');
                        } else {
                          alerts.customDialog(type: AlertType.error, message: 'No product found');
                        }
                      }
                    }, icon: null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitleText(List<PreorderMemoInformationModel> preorderMemo, SaleType saleType) {
    if(preorderMemo.isEmpty) {
      switch (saleType) {
        case SaleType.spotSale:
          return "Sale";
        case SaleType.preorder:
          return "Pre-order";
        case SaleType.delivery:
          return "Delivery";
      }
    }
    switch (saleType) {
      case SaleType.spotSale:
        return "Sale Edit";
      case SaleType.preorder:
        return "Pre-order Edit";
      case SaleType.delivery:
        return "Delivery";
    }
  }

  // AsyncValue<List<MaintenanceModel>> asyncAssetRequisitionList = ref.watch(getAllMaintenanceList)
  void tryBeforeYouBuyDialogue({
    required List<TryBeforeBuyModel> tryBeforeBuyList,
    required OutletModel retailer,
  }) {
    alerts.showModalWithWidget(
      backgroundColor: scaffoldBGColor,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: 100.circularRadius,
                      color: primary,
                    ),
                    padding: const EdgeInsets.all(3),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                height: tryBeforeBuyList.length == 1
                    ? 18.w
                    : tryBeforeBuyList.length == 2
                    ? (2 * 18.w) + (6.0 * 2)
                    : tryBeforeBuyList.length == 3
                    ? 3 * 18.w + (6.0 * 3)
                    : 4 * 18.w + (6.0 * 4),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tryBeforeBuyList.length,
                  itemBuilder: (BuildContext context, int index) {
                    TryBeforeBuyModel tryBeforeBuy = tryBeforeBuyList[index];
                    return InkWell(
                      onTap: () {
                        _saleController.selectTryBeforeBuy(ref, tryBeforeBuy: tryBeforeBuy);
                      },
                      child: Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          List<TryBeforeBuyModel> selectedTryBeforeBuy = ref.watch(selectedTryBeforeBuyProvider);
                          bool selected = selectedTryBeforeBuy.contains(tryBeforeBuy);
                          return Container(
                            height: 18.w,
                            padding: EdgeInsets.all(3.sp),
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              borderRadius: 5.sp.circularRadius,
                              color: Colors.white,
                              border: Border.all(
                                width: 2,
                                color: selected ? primary : Colors.white,
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 15.w,
                                  child: AssetService(context).superImage(
                                    '${tryBeforeBuy.sku.id}.png',
                                    folder: "SKU",
                                    version: SyncReadService().getAssetVersion("SKU"),
                                  ),
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: LangText(
                                      tryBeforeBuy.sku.shortName,
                                      style: TextStyle(fontSize: normalFontSize, color: darkGreen),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Icon(
                                  Icons.check_circle,
                                  size: 32,
                                  color: selected ? primary : primary.withOpacity(0.1),
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            // SizedBox(
            //   width: 42.w,
            //   child: ,
            // ),

            SizedBox(
              width: 42.w,
              child: Consumer(builder: (context, ref, _) {
                bool internet = ref.watch(internetConnectivityProvider);
                LeaveManagementType leaveManagementType = ref.watch(selectedLeaveManagementTypeProvider);
                if (!internet) {
                  return Center(child: LangText("No internet"));
                }
                return SubmitButtonGroup(
                  button1Label: "Submit",
                  onButton1Pressed: () async {
                    await _saleController.submitTryBeforeBuy();
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
