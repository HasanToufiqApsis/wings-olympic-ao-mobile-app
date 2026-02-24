import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';

import '../../../constants/sync_global.dart';
import '../../../main.dart';
import '../../../models/location_category_models.dart';
import '../../../models/module.dart';
import '../../../models/outlet_model.dart';
import '../../../models/products_details_model.dart';
import '../../../models/sales/memo_information_model.dart';
import '../../../models/sales/sales_preorder_configuration_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/loader/retailer_loader_widget.dart';
import '../../../reusable_widgets/null_retailer_widget.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/geo_location_service.dart';
import '../../../services/storage_prmission_service.dart';
import '../../map/service/map_service.dart';
import '../../outlet_informations/controller/outlet_controller.dart';
import '../../outlet_informations/ui/outlet_details_ui.dart';
import '../../retailer_selection/controller/retailer_selection_controller.dart';
import '../../retailer_selection/ui/retailer_details_ui.dart';
import '../../retailer_selection/ui/retailer_selection_ui.dart';
import '../../retailer_selection/widgets/retailer_list_tile.dart';
import '../controller/sale_controller.dart';
import 'before_sale_geo_validation_screen.dart';

class SalesUIv2 extends ConsumerStatefulWidget {
  SalesUIv2({Key? key, required this.selectedRetailer}) : super(key: key);
  static const routeName = "/sale-v2";
  final OutletModel selectedRetailer;
  final allMemo = AllMemoInformationModel(saleMemo: [], preorderMemo: []);

  @override
  _SalesUIv2State createState() => _SalesUIv2State();
}

class _SalesUIv2State extends ConsumerState<SalesUIv2> {
  late GlobalWidgets globalWidgets;
  late SaleController salesController;
  late Alerts alerts;
  late StoragePermissionService _storagePermissionService;
  late final LocationService _locationService;
  late final RetailerSelectionController _retailerSelectionController;

  @override
  void initState() {
    super.initState();
    if (widget.allMemo.saleMemo.isEmpty) {
      currentSaleData = {};
    }
    if (widget.allMemo.preorderMemo.isEmpty) {
      currentPreorderData = {};
    }

    alerts = Alerts(context: context);
    globalWidgets = GlobalWidgets();
    salesController = SaleController(context: context, ref: ref);

    _locationService = LocationService(context);

    _storagePermissionService = StoragePermissionService(context: context);
    _storagePermissionService.requestStoragePermission();
    _retailerSelectionController = RetailerSelectionController(
      alerts: alerts,
      locationService: _locationService,
    );

    if (widget.allMemo.saleMemo.isNotEmpty ||
        widget.allMemo.preorderMemo.isNotEmpty) {
      setShowSkuWhenEdit();
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(selectedRetailerProvider.notifier).state = widget.selectedRetailer;
      salesController.checkGeoFencing(widget.selectedRetailer);
    });
  }

  setShowSkuWhenEdit() {
    callStartTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.allMemo.preorderMemo.isNotEmpty ? "Order Edit" : "Order",
        titleImage: "pre_order_button.png",
        showLeading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(builder: (context, ref, _) {
              Module? selectedModule = ref.watch(selectedSalesModuleProvider);

              AsyncValue<List<ProductDetailsModel>>? productList;
              if (selectedModule != null) {
                productList = ref.watch(productListFutureProvider(selectedModule));
              }

              return CustomScrollView(
                clipBehavior: Clip.antiAlias,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                          child: Consumer(builder: (context, ref, _) {
                            OutletModel? retailer = ref.watch(selectedRetailerProvider);
                            return retailer == null
                                ? const NullRetailerWidget()
                                : RetailerListTile(
                              retailer: retailer,
                              onItemTap: () async {
                              final dynamic retailer = await navigatorKey
                                  .currentState
                                  ?.pushNamed(RetailerSelectionUi.routeName);
                              if (retailer != null) {
                                salesController.handleRetailerChange(retailer);
                              }
                            },
                              navigationTileEnabled: true,
                              onInfoTap: () async {
                                // navigatorKey.currentState
                                //     ?.pushNamed(
                                //   RetailerDetailsScreen.routeName,
                                //   arguments: retailer,
                                // );

                                await OutletController(ref: ref, context: context)
                                    .setDifferentImageURL(retailer);
                                navigatorKey.currentState?.pushNamed(
                                    OutletDetailsUI.routeName,
                                    arguments: retailer);
                              },
                              onMapTap: () async {
                                _retailerSelectionController.retailerLocationNavigator(retailer: retailer);
                              },
                            );
                          }),
                        );
                      },
                      childCount: 1,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: BeforeSaleGeoValidationScreenUI(
                      saleEdit: widget.allMemo.preorderMemo.isNotEmpty,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Container(height: 15.h),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  ///UI
  Widget sliverAppbarTitle() {
    return Consumer(builder: (context, ref, _) {
      OutletModel? dropdownSelected = ref.watch(selectedRetailerProvider);
      if (dropdownSelected != null) {
        bool saleEdit = widget.allMemo.saleMemo.isNotEmpty ||
            widget.allMemo.preorderMemo.isNotEmpty;
        AsyncValue<SalesPreorderConfigurationModel>
            asyncSalesPreorderConfigurations = ref.watch(
                salesPreorderModuleIdProvider(
                    saleEdit ? dropdownSelected.id : null));
        return asyncSalesPreorderConfigurations.when(
            data: (salesPreorderConfigurations) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 1.h),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer(builder: (context, ref, _) {
                      AsyncValue<List<Module>> moduleList =
                          ref.watch(moduleListProvider);
                      OutletModel? selectedRetailer =
                          ref.read(selectedRetailerProvider);
                      Module? selectedModule =
                          ref.watch(selectedSalesModuleProvider);

                      Map? color;
                      return asyncSalesPreorderConfigurations.when(
                          data: (salesPreorderConfigurations) {
                            return moduleList.when(
                                data: (data) {
                                  if (selectedRetailer != null &&
                                      selectedRetailer.sbuId.isNotEmpty) {
                                    data = data
                                        .where((element) => selectedRetailer
                                            .sbuId
                                            .contains(element.id))
                                        .toList();
                                  }
                                  if (selectedModule == null)
                                    // setSelectedModule(ref, data[0],
                                    //     salesPreorderConfigurations);
                                  if (data.isNotEmpty && data.length == 1) {
                                    return const SizedBox();
                                  }
                                  return Container(
                                    height: 5.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.sp),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          color != null
                                              ? color['color-1']
                                              : Colors.white,
                                          color != null
                                              ? color['color-2']
                                              : Colors.white
                                        ],
                                      ),
                                    ),
                                    child: DropdownButton<Module>(
                                      value: selectedModule,
                                      icon: const Icon(
                                        Icons.arrow_drop_down_outlined,
                                        color: Colors.white,
                                      ),
                                      iconSize: 24,
                                      // elevation: 16,
                                      selectedItemBuilder: (context) => data
                                          .map<Widget>((e) => Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 1.w),
                                                  child: LangText(
                                                    e.name,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 9.sp),
                                                  ))))
                                          .toList(),
                                      underline: Container(
                                        height: 0,
                                        color: Colors.transparent,
                                      ),
                                      onChanged: (newValue) {},
                                      items: data.map((item) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 1.w),
                                            child: LangText(
                                              item.name,
                                              style: TextStyle(
                                                  fontSize: 10.sp),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                                error: (e, s) => Text('$e'),
                                loading: () =>
                                    const CircularProgressIndicator());
                          },
                          error: (error, _) => Container(),
                          loading: () => Container());
                    }),
                  ],
                ),
              );
            },
            error: (error, _) => Container(),
            loading: () => Container());
      }
      return Container();
    });
  }

  Widget routeAndRetailerDropdown() {
    return Column(
      children: [
        /// Route dropdown
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  color: Colors.white,
                  // border: Border.all(color: grey, width: 1.sp)
                ),
                child: widget.allMemo.saleMemo.isNotEmpty ||
                        widget.allMemo.preorderMemo.isNotEmpty
                    //When sale edit, retailer can not be changed
                    ? Builder(
                        builder: (context) {
                          SectionModel? section =
                              ref.read(selectedSectionProvider)!;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 14),
                            child: LangText(
                              section.name ?? '-',
                              style: TextStyle(
                                  color: Colors.black),
                            ),
                          );
                        },
                      )
                    :
                    //when normal sales, retailer can be changed via dropdown
                    Consumer(
                        builder: (context, ref, _) {
                          AsyncValue<List<SectionModel>> asyncSectionList =
                              ref.watch(sectionListProvider);
                          return asyncSectionList.when(
                            data: (sectionList) {
                              /// Here auto select the active route
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) async {
                                await Future.delayed(
                                    const Duration(microseconds: 500));
                                for (var sec in sectionList) {
                                  if (sec.isActive == true) {
                                    final alreadySec = ref
                                        .read(selectedSectionProvider.notifier)
                                        .state;
                                    if (alreadySec == null) {
                                      ref
                                          .read(
                                              selectedSectionProvider.notifier)
                                          .state = sec;
                                      break;
                                    }
                                  }
                                }
                              });

                              return Consumer(builder: (context, ref, _) {
                                SectionModel? selectedSection =
                                    ref.watch(selectedSectionProvider);

                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
                                  child: Center(
                                    child: DropdownButton<SectionModel>(
                                      hint: LangText(
                                        'Select Route',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      iconDisabledColor: Colors.transparent,
                                      focusColor:
                                          Theme.of(context).primaryColor,
                                      isExpanded: true,
                                      value: selectedSection,
                                      iconSize: 15.sp,
                                      items: sectionList.map((item) {
                                        return DropdownMenuItem<SectionModel>(
                                          value: item,
                                          child: FittedBox(
                                            child: Row(
                                              children: [
                                                LangText(
                                                  item.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.black),
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
                                      style:
                                          const TextStyle(color: Colors.black),
                                      underline: Container(
                                        height: 0,
                                        color: Colors.transparent,
                                      ),
                                      onChanged: (val) {
                                        // print(val!.retailerName);
                                        salesController
                                            .handleSectionChange(val);
                                        // ref.refresh(alphabetListProvider);
                                        // salesController.handleRetailerChange(val);
                                      },
                                    ),
                                  ),
                                );
                              });
                            },
                            error: (e, s) => Text('$e'),
                            loading: () => const CircularProgressIndicator(),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        /// Retailer drop down
        Row(
          children: [
            Expanded(
              child: retailerDropdown(),
            ),
            SizedBox(
              width: 2.w,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                color: Colors.white,
              ),
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  OutletModel? dropdownSelected =
                      ref.watch(selectedRetailerProvider);
                  return IconButton(
                      onPressed: () {
                        if (dropdownSelected != null) {}
                      },
                      icon: Icon(
                        Icons.location_on,
                        color: dropdownSelected != null
                            ? primary
                            : Colors.grey,
                      ));
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget retailerDropdown() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              color: Colors.white,
            ),
            child: widget.allMemo.saleMemo.isNotEmpty ||
                    widget.allMemo.preorderMemo.isNotEmpty

                ? Builder(builder: (context) {
                    OutletModel retailer =
                        ref.read(selectedRetailerProvider)!;
                    return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 4.w),
                        child: LangText(retailer.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: normalFontSize)));
                  }) :
                Consumer(builder: (context, ref, _) {
                    OutletModel? dropdownSelected =
                        ref.watch(selectedRetailerProvider);
                    AsyncValue<List<OutletModel>> retailerList =
                        ref.watch(formattedRetailerListProvider);
                    return retailerList.when(
                        data: (data) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Center(
                              child: DropdownButton<OutletModel>(
                                hint: LangText(
                                  'Select a retailer',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                iconDisabledColor: Colors.transparent,
                                focusColor: Theme.of(context).primaryColor,
                                isExpanded: true,
                                value: dropdownSelected,
                                iconSize: 15.sp,
                                items: data.map((item) {
                                  return DropdownMenuItem<OutletModel>(
                                    value: item,
                                    child: FittedBox(
                                      child: Row(
                                        children: [

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
                                          (item.totalSale >= 0.0)
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    LangText(
                                                      ' : ',
                                                      isNumber: true,
                                                      style: TextStyle(
                                                          color: darkGreen,
                                                          fontSize:
                                                              normalFontSize),
                                                    ),
                                                    LangText(
                                                      item.totalSale
                                                          .toStringAsFixed(2),
                                                      isNumber: true,
                                                      style: TextStyle(
                                                          color: darkGreen,
                                                          fontSize:
                                                              normalFontSize),
                                                    ),
                                                    LangText(
                                                      ' currencySymbol',
                                                      isNumber: true,
                                                      style: TextStyle(
                                                          color: darkGreen,
                                                          fontSize:
                                                              normalFontSize),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                          if (item.preorderExists)
                                            (Icon(
                                              Icons.token,
                                              color: green,
                                              size: normalFontSize,
                                            ))
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
                                  // print(val!.retailerName);
                                  salesController.handleRetailerChange(val);
                                  // salesController.handleRetailerChange(val);
                                },
                              ),
                            ),
                          );
                        },
                        error: (e, s) => Text('$e'),
                        loading: () => const RetailerLoaderWidget());
                  }),
          ),
        ),
      ],
    );
  }
}
