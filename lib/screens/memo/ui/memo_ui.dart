import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../../constants/constant_variables.dart';
import '../../../main.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/cooler_available_image.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/null_retailer_widget.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/geo_location_service.dart';
import '../../outlet_informations/controller/outlet_controller.dart';
import '../../outlet_informations/ui/outlet_details_ui.dart';
import '../../retailer_selection/controller/retailer_selection_controller.dart';
import '../../retailer_selection/ui/retailer_details_ui.dart';
import '../../retailer_selection/ui/retailer_selection_ui.dart';
import '../../retailer_selection/widgets/retailer_list_tile.dart';
import '../../sale/controller/sale_controller.dart';
import '../memo_controller/memo_controller.dart';
import 'preorder_memo_ui.dart';

class MemoUI extends ConsumerStatefulWidget {
  const MemoUI({Key? key}) : super(key: key);
  static const routeName = "/memo";

  @override
  _MemoUIState createState() => _MemoUIState();
}

class _MemoUIState extends ConsumerState<MemoUI> {
  final _appBarTitle = DashboardBtnNames.memo;
  GlobalWidgets globalWidgets = GlobalWidgets();
  late MemoController memoController;
  late SaleController salesController;
  late final RetailerSelectionController _retailerSelectionController;

  @override
  void initState() {
    memoController = MemoController(context: context, ref: ref);
    salesController = SaleController(context: context, ref: ref);

    _retailerSelectionController = RetailerSelectionController(
      alerts: Alerts(context: context),
      locationService: LocationService(context),
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _appBarTitle,
        titleImage: "memo.png",
        showLeading: true,
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: SizedBox(
                            width: 100.w,
                            child: globalWidgets.showInfo(
                                message:
                                    'You can view a memo by selecting the outlet.'),
                        ),
                      ),

                      _retailerSelectionUiForMemo(),

                      Column(
                        children: [
                          PreorderMemoUI(
                            saleType: SaleType.preorder,
                            onMemoEdit: () {
                              memoController.onEdit(saleType: SaleType.preorder);
                            },
                          ),

                          PreorderMemoUI(
                            saleType: SaleType.spotSale,
                            onMemoEdit: () {
                              memoController.onEdit(saleType: SaleType.spotSale);
                            },
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 3.h,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _retailerSelectionUiForMemo() {
    return Consumer(
      builder: (context, ref, _) {
        AsyncValue<List<OutletModel>> availableRetailers = ref.watch(memoOutletListProvider(true));
        OutletModel? selectedRetailer = ref.watch(selectedRetailerProvider);

        return availableRetailers.when(
          data: (retailers) {
            if (retailers.isNotEmpty && selectedRetailer == null) {
              return NullRetailerWidget(
                onTap: () async {
                  final dynamic retailer = await navigatorKey.currentState
                      ?.pushNamed(RetailerSelectionUi.routeName, arguments: {
                    "forMemo": true,
                    "retailerList": retailers,
                  });
                  if (retailer != null) {
                    log('selected retailer => ${retailer?.id}');
                    salesController.handleRetailerChange(retailer);
                  }
                },
              );
            }

            if (selectedRetailer != null) {
              return RetailerListTile(
                retailer: selectedRetailer,
                onItemTap: () async {
                  final dynamic retailer = await navigatorKey.currentState
                      ?.pushNamed(RetailerSelectionUi.routeName, arguments: {"forMemo": true});
                  if (retailer != null) {
                    ref.refresh(couponDiscountProvider);
                    SaleController(context: context, ref: ref).refreshPreviousSaleData();
                  }
                },
                navigationTileEnabled: true,
                onInfoTap: () async {
                  // navigatorKey.currentState?.pushNamed(
                  //   RetailerDetailsScreen.routeName,
                  //   arguments: selectedRetailer,
                  // );

                  await OutletController(ref: ref, context: context)
                      .setDifferentImageURL(selectedRetailer);
                  navigatorKey.currentState?.pushNamed(
                      OutletDetailsUI.routeName,
                      arguments: selectedRetailer);
                },
                onMapTap: () async {
                  _retailerSelectionController.retailerLocationNavigator(retailer: selectedRetailer);
                },
              );
            }

            return LangText("No available memo");
          },
          error: (error, _) => Container(),
          loading: () => Container(),
        );
      },
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
              // border: Border.all(color: grey, width: 1.sp)
            ),
            child: Consumer(builder: (context, ref, _) {
              OutletModel? dropdownSelected = ref.watch(selectedRetailerProvider);
              AsyncValue<List<OutletModel>> retailerList = ref.watch(memoOutletListProvider(true));
              return retailerList.when(
                  data: (data) {
                    if (data.isNotEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Center(
                          child: DropdownButton<OutletModel>(
                            hint: LangText(
                              'Select a retailer',
                              style: TextStyle(color: Colors.grey, fontSize: 8.sp),
                            ),
                            iconDisabledColor: Colors.transparent,
                            focusColor: Theme.of(context).primaryColor,
                            isExpanded: true,
                            value: dropdownSelected,
                            iconSize: 15.sp,
                            items: data.reversed.map((item) {
                              return DropdownMenuItem<OutletModel>(
                                value: item,
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      // iconList(item.iconData),

                                      SizedBox(
                                        width: 1.w,
                                      ),

                                      LangText(
                                        "${item.name} (${item.owner})",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: normalFontSize),
                                      ),
                                      SizedBox(
                                        width: 1.w, // item.totalSale.toStringAsFixed(2)
                                      ),
                                      CoolerAvailableImageWidget(outlet: item),
                                      item.hasPreOrdered
                                          ? const Icon(
                                              Icons.done_all,
                                              color: Colors.green,
                                            )
                                          : Container(),
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
                              ref.read(selectedRetailerProvider.notifier).state = val;
                              ref.refresh(couponDiscountProvider);
                              SaleController(context: context, ref: ref).refreshPreviousSaleData();
                            },
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: LangText(
                            "Please take Preorder First",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }
                  },
                  error: (e, s) => LangText('$e'),
                  loading: () => const CircularProgressIndicator());
            }),
          ),
        ),
        // IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.info,
        //       color: Colors.grey,
        //     ))
      ],
    );
  }

  Widget alphabetBox() {
    return Consumer(builder: (context, ref, _) {
      List<String> alphabetList = ref.watch(alphabetListProvider);
      String? selected = ref.watch(selectedAlphabetProvider);
      return Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(vertical: 0.0.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.sp),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.5, 1],
                colors: [primary, red3])),
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white, fontSize: normalFontSize),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                alphabetList.length,
                (index) => FittedBox(
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(memoOutletListProvider(true).notifier)
                          .searchByFirstLetter(alphabetList[index]);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(2.sp),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
                        decoration: (selected == alphabetList[index])
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(5.sp),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [green, darkGreen],
                                ),
                              )
                            : null,
                        child: Center(
                          child: LangText(
                            alphabetList[index].toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
