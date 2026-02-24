import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';
import 'package:wings_olympic_sr/reusable_widgets/scaffold_widgets/appbar.dart';
import 'package:wings_olympic_sr/screens/stock/ui/stock_search_delegate.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/dashboard_btn_names.dart';
import '../../../constants/sync_global.dart';
import '../../../models/module.dart';
import '../../../models/products_details_model.dart';
import '../../../models/sales/sales_preorder_configuration_model.dart';
import '../../../models/sales/sku_classification.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/asset_download/asset_service.dart';
import '../../../services/sync_read_service.dart';
import '../../printer/controllers/printer_controller.dart';
import '../../sale/providers/sale_providers.dart';
import '../../sale/ui/sale_v2_widget/search_container.dart';
import '../../sale/ui/sale_v2_widget/tab_widget.dart';
import '../../video_player.dart';
import '../controller/stocks_controller.dart';
import '../widget/stock_sku_widget.dart';

class StockUI extends ConsumerStatefulWidget {
  const StockUI({Key? key}) : super(key: key);
  static const routeName = "/stock_ui";

  @override
  _StockUIState createState() => _StockUIState();
}

class _StockUIState extends ConsumerState<StockUI> with TickerProviderStateMixin {
  final _appBarTitle = DashboardBtnNames.stock;

  late GlobalWidgets globalWidgets;
  late StockController stockController;
  late TabController tabController;
  List<int> pageToModule = [];
  final _cartClassification = SkuClassification(id: -1, name: 'All');

  Map<String, List<ProductDetailsModel>> byClassificationProductData = {};
  final List<SkuClassification> _skuClassificationList = [];
  final _syncReadService = SyncReadService();
  late final TabController? _tabController;

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initiateClassificationListAndTabController();
    currentStockData = {};
    globalWidgets = GlobalWidgets();
    stockController = StockController(context: context, ref: ref);
    // PrinterController(ref: ref, context: context).connectBluetoothPrinter();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   stockController.showRTCVideo();
    // });
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

  @override
  Widget build(BuildContext context) {
    AsyncValue<SalesPreorderConfigurationModel> asyncSalesPreorderConfigurations =
        ref.watch(salesPreorderModuleIdProvider(null));
    return asyncSalesPreorderConfigurations.when(
      data: (salesPreorderConfigurations) {
        print('this length is :::: ${salesPreorderConfigurations.availableModuleForSales.length}');
        return Scaffold(
          appBar: CustomAppBar(
            title: _appBarTitle,
            heroTagTitle: _appBarTitle,
            titleImage: 'stock.png',
            heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
          ),
          body: Consumer(
            builder: (context, ref, _) {
              AsyncValue<List<Module>> asyncModules = ref.watch(allModuleListProvider);

              return asyncModules.when(
                data: (modules) {
                  tabController = TabController(
                      length: salesPreorderConfigurations.availableModuleForSales.length,
                      vsync: this);

                  return SafeArea(
                    child: Column(
                      children: [
                        /// ================== All the tabs and list ====================
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: modules.length == 1 ? 0 : 2.h, left: 3.w, right: 3.w),
                            child: DefaultTabController(
                              length: modules.length,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: modules.length == 1 ? 0 : 4.h,
                                    child: Consumer(builder: (context, ref, _) {
                                      return TabBar(
                                        controller: tabController,
                                        isScrollable: true,
                                        tabAlignment: TabAlignment.start,
                                        // labelStyle: TextStyle(color: blue),
                                        labelColor: Colors.white,
                                        // unselectedLabelColor: grey,
                                        dividerColor:
                                            modules.length == 1 ? Colors.transparent : null,
                                        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        indicator: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Colors.red, green],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5.sp),
                                            topRight: Radius.circular(5.sp),
                                          ),
                                        ),

                                        /// ========= tabs ============
                                        tabs: getTabs(
                                          modules,
                                          salesPreorderConfigurations.availableModuleForSales,
                                        ),
                                        // tabs: [Tab(child: Text("data"),)],
                                      );
                                    }),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      controller: tabController,
                                      children: getTabViewList(
                                        modules,
                                        salesPreorderConfigurations.availableModuleForSales,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        // SizedBox(height: 1.h,),
                        /// ================== total amount container on the bottom ================

                        // Consumer(builder: (context, ref, _) {
                        //   final asyncSettlementStatus =
                        //       ref.watch(cashSettlementStatusProvider);
                        //
                        //   return asyncSettlementStatus.when(
                        //     data: (settlementStatus) {
                        //       return getBottomWidget(
                        //         salesPreorderConfigurations,
                        //         settlementStatus,
                        //       );
                        //     },
                        //     error: (error, stck) => const SizedBox(),
                        //     loading: () => const SizedBox(),
                        //   );
                        // }),
                        getBottomWidget(
                          salesPreorderConfigurations,
                        )
                      ],
                    ),
                  );
                },
                error: (error, _) => Container(),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        );
      },
      error: (error, _) => Container(),
      loading: () => Container(),
    );
  }

  ///////////// Returns Tabs for modules////////////
  List<Tab> getTabs(List<Module> modules, List availableSales) {
    List<Tab> tabList = [];
    for (Module module in modules) {
      // if (availableSales.contains(module.id)) {
      print("MODULE LENGTH IS :: ${module.name}");
      pageToModule.add(module.id);
      tabList.add(
        Tab(
          text: module.id.toString(),
        ),
      );
      // }
    }
    return tabList;
  }

  ///////////// Returns Static Headers for STOCK Entry Table ////////////
  Widget getStockEntryTableHeaders() {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: LangText(
                'SKU',
                style: TextStyle(color: grey),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LangText(
                    'Issued\nStock',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: grey),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LangText(
                    'Stock On\nHand',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///////////// Returns TabBarView of every Modules////////////
  List<Widget> getTabViewList(
    List<Module> moduleList,
    List saleModuleIDs,
  ) {
    List<Widget> moduleTabBars = [];
    for (Module module in moduleList) {
      if (saleModuleIDs.contains(module.id)) {
        Widget moduleTabBar = Column(
          children: [
            14.verticalSpacing,
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final asyncProductDetailsList = ref.watch(stockProductListFutureProvider(module));
                  final selectedClassification = ref.watch(selectedClassificationProvider);

                  return asyncProductDetailsList.when(
                    data: (productDetailsList) {
                      if (productDetailsList.isEmpty) {
                        return Center(
                          child: LangText("Nothing to show"),
                        );
                      }
                      byClassificationProductData = productDetailsList;
                      final productList =
                          productDetailsList[selectedClassification?.name ?? 'All'] ?? [];

                      return Column(
                        children: [
                          Consumer(builder: (context, ref, _) {
                            final selectedModule = ref.watch(selectedSalesModuleProvider);
                            // if (selectedModule == null) {
                            //   return const SizedBox();
                            // }
                            return SearchContainer(
                              onTap: () async {
                                // if (byClassificationProductData.isEmpty) {
                                //   return;
                                // }
                                await showSearch(
                                  context: context,
                                  delegate: StockSearchDelegate(
                                    data: byClassificationProductData,
                                    skuIdWiseSalesSummary: {},
                                    totalRetailerCount: 10,
                                    preOrderData: {},
                                  ),
                                );
                              },
                            );
                          }),
                          14.verticalSpacing,
                          Consumer(builder: (context, ref, _) {
                            final cls = ref.watch(selectedClassificationProvider);

                            return Row(
                              children: [
                                InkResponse(
                                  onTap: () {
                                    ref.read(selectedClassificationProvider.notifier).state =
                                        _cartClassification;
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cls?.id == -1
                                          ? const Color(0xFFCFDEED)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade300),
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
                                    indicatorAnimation: TabIndicatorAnimation.elastic,
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
                                      ref.read(selectedClassificationProvider.notifier).state =
                                          _skuClassificationList[index];
                                    },
                                    tabs: _skuClassificationList.map((classification) {
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
                          14.verticalSpacing,
                          getStockEntryTableHeaders(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: productList.length,
                              padding: EdgeInsets.only(bottom: 1.h),
                              itemBuilder: (context, index) {
                                return StockSkuWidget(sku: productList[index], enableFilter: true);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    error: (error, _) => Container(),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            )
          ],
        );

        moduleTabBars.add(moduleTabBar);
      }
    }

    return moduleTabBars;
  }

  ///////////// Total ammount container on the bottom //////////
  /// Working here
  Widget getBottomWidget(SalesPreorderConfigurationModel salesPreorderConfigurationModel) {
    tabController.addListener(() {
      ref.read(stockPageProvider.notifier).state = tabController.index;
    });

    return Consumer(
      builder: (context, ref, _) {
        int page = ref.watch(stockPageProvider);
        return Container(
          color: red3,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 100.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LangText(
                            'Total Issue',
                            style: TextStyle(fontSize: 8.sp, color: Colors.white),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Consumer(
                            builder: (context, ref, _) {
                              int moduleID = ref.watch(stockPageProvider);
                              final isListEmpty =
                                  salesPreorderConfigurationModel.availableModuleForSales.isEmpty;
                              AsyncValue<Module> asyncModule = ref.watch(
                                moduleNameProvider(
                                  (isListEmpty
                                          ? '1'
                                          : salesPreorderConfigurationModel
                                              .availableModuleForSales[tabController.index]
                                              .toString())
                                      .toString(),
                                ),
                              );
                              return asyncModule.when(
                                data: (module) {
                                  return LangText(
                                    '(${module.name})',
                                    style: TextStyle(fontSize: 8.sp, color: Colors.white),
                                  );
                                },
                                error: (error, _) => Container(),
                                loading: () => const CircularProgressIndicator(),
                              );
                            },
                          ),
                        ],
                      ),
                      LangText(
                        'In Stock',
                        style: TextStyle(fontSize: 8.sp, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer(
                        builder: (context, ref, _) {
                          AsyncValue<void> totalIssuedFromData =
                              ref.watch(totalIssuedFutureProvider);
                          return totalIssuedFromData.when(
                            data: (data) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Consumer(
                                    builder: (context, ref, _) {
                                      int totalIssued =
                                          ref.watch(totalIssuedProvider(pageToModule[page]));
                                      return LangText(
                                        totalIssued.toString(),
                                        isNumber: true,
                                        style: TextStyle(fontSize: 20.sp, color: Colors.white),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                ],
                              );
                            },
                            error: (error, _) => Container(),
                            loading: () => const CircularProgressIndicator(),
                          );
                        },
                      ),
                      Consumer(
                        builder: (context, ref, _) {
                          int totalStock = ref.watch(totalStockedProvider(pageToModule[page]));
                          return Align(
                            alignment: Alignment.centerRight,
                            child: LangText(
                              totalStock.toString(),
                              isNumber: true,
                              style: TextStyle(fontSize: 20.sp, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  width: 100.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Expanded(
                      //   child: globalWidgets.button(
                      //     colors: [green, darkGreen],
                      //     text: 'Save', // Save
                      //     callback: () {
                      //       stockController.checkSave();
                      //     },
                      //     icon: const Icon(
                      //       Icons.save,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),

                      Expanded(
                        child: SingleCustomButton(
                          color: Colors.white,
                          label: "Save",
                          textColor: red3,
                          onPressed: () async {
                            stockController.checkSave();
                          },
                          icon: Icon(
                            Icons.save,
                            color: red3,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 45.w,
                      //   height: 5.h,
                      //   child: globalWidgets.button(
                      //       colors: [green, darkGreen],
                      //       text: 'Save', // Save
                      //       callback: () {
                      //         stockController.checkSave();
                      //       },
                      //       icon: const Icon(
                      //         Icons.save,
                      //         color: Colors.white,
                      //       )),
                      // ),
                      // SizedBox(
                      //   height: 1.h,
                      // ),
                      // SizedBox(
                      //     width: 45.w,
                      //     height: 5.h,
                      //     child: globalWidgets.button(
                      //         colors: [lightGrey, lightGrey],
                      //         text: 'Print',
                      //         textColor: Colors.grey[700]!,
                      //         callback: () {
                      //           stockController.printStock();
                      //         },
                      //         icon: Icon(
                      //           Icons.print,
                      //           color: Colors.grey[700],
                      //         )))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
