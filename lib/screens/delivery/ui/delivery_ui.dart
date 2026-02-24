import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/reusable_widgets/taka_icon.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../models/module.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/cooler_available_image.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/body.dart';
import '../../../utils/sales_type_utils.dart';
import '../../sale/controller/sale_controller.dart';
import 'before_delivery_ui.dart';

class DeliveryUI extends ConsumerStatefulWidget {
  const DeliveryUI({super.key});
  static const routeName = "/delivery_ui";
  @override
  ConsumerState<DeliveryUI> createState() => _DeliveryUIState();
}

class _DeliveryUIState extends ConsumerState<DeliveryUI> {
  late final SaleController _saleController;
  late final Alerts _alerts;
  @override
  void initState() {
    super.initState();
    _saleController = SaleController(context: context, ref: ref);
    _alerts = Alerts(context: context);
  }

  bool initialSet = false;

  @override
  Widget build(BuildContext context) {
    return CustomBody(
      disableTopPadding: true,
      child: Column(
        children: [
          ///=========== top container ====================================
          Expanded(
            child: Consumer(builder: (context, ref, _) {
              return CustomScrollView(
                clipBehavior: Clip.antiAlias,
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(height: 2.h),
                  ),
                  ///======================= widgets except the list ========================
                  // SliverAppBar(
                  //   expandedHeight: 20.h,
                  //   backgroundColor: primaryGrey, //TODOL:: colors need to be changed
                  //   automaticallyImplyLeading: false,
                  //   floating: true,
                  //   pinned: true,
                  //   snap: false,
                  //   title: retailerDropdown(),
                  //   flexibleSpace: FlexibleSpaceBar(
                  //     centerTitle: true,
                  //     expandedTitleScale: 1,
                  //     titlePadding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: .5.h),
                  //     background: Padding(
                  //       padding: EdgeInsets.symmetric(
                  //         horizontal: 2.w,
                  //       ),
                  //       child: DefaultTextStyle(
                  //         style: const TextStyle(
                  //           fontFamily: 'NotoSansBengali',
                  //         ),
                  //         child: Column(
                  //           children: [
                  //             /// ================== purple container with point and Route ===============
                  //
                  //             SizedBox(
                  //               height: 7.5.h,
                  //             ),
                  //
                  //             /// ================== select alphabet ================
                  //
                  //             alphabetBox(),
                  //             SizedBox(
                  //               height: 1.h,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.sp,right: 10.sp, /*bottom: 10.sp*/),
                      child: Column(
                        children: [
                          alphabetBox(),
                          SizedBox(
                            height: 10.sp,
                          ),
                          retailerDropdown(),
                          moduleDropdown(),
                        ],
                      ),
                    ),
                  ),



                  // SliverToBoxAdapter(
                  //   child: Consumer(
                  //     builder: (context, ref, _) {
                  //       AsyncValue<List<Module>> asyncModules = ref.watch(moduleListProvider);
                  //       Module? module = ref.watch(selectedSalesModuleProvider);
                  //       return asyncModules.when(
                  //           data: (modules) {
                  //             if (modules.isNotEmpty) {
                  //               WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  //                 ref.read(selectedSalesModuleProvider.notifier).state = modules[0];
                  //               });
                  //             }
                  //             return Container();
                  //           },
                  //           error: (e, s) => Text('$e'),
                  //           loading: () => Container());
                  //     },
                  //   ),
                  // ),
                  // ///====================== the list =====================================
                  const SliverToBoxAdapter(child: BeforeDeliveryUI()),
                  SliverToBoxAdapter(
                    child: Container(height: 15.h),
                  ),
                ],
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TakaIcon(weight: FontWeight.bold, color: Colors.white, size: 24,),
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
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: SingleCustomButton(
                    color: primary, label: 'Proceed', onPressed: () async {
                    ref.refresh(selectedSlabPromotion);
                    await Future.delayed(const Duration(milliseconds: 35));
                    currentPromotionData = {};
                    OutletModel? retailer = ref.read(selectedRetailerProvider);
                    List<Module>? moduleList = ref.read(moduleListProvider).value;
                    if (retailer != null && moduleList != null) {
                      _alerts.floatingLoading();
                      await _saleController.formattingSaleData(module: moduleList, retailer: retailer, saleEdit: false).then((value) async {
                        Navigator.of(context).pop();
                        if (value != null) {
                          //setting sale type as delivery
                          value.saleType = SaleType.delivery;

                          bool validateBeforeSelectedOffers =
                          await _saleController
                              .checkBeforeSelectedOffers();
                          bool validateBeforeSelectedOffers2 = await _saleController.checkBeforeSelectedOffers2(value.salesPreorderDiscountDataModel);

                          if (validateBeforeSelectedOffers2) {
                            _saleController.sendToExaminPage(value);
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
                                _saleController.sendToExaminPage(value);
                              },
                            );
                          }
                        } else {
                          _saleController.handleZeroSale(retailer);
                        }
                      });
                    } else {
                      if (retailer == null) {
                        _alerts.customDialog(type: AlertType.warning, message: 'Please select a retailer');
                      } else {
                        _alerts.customDialog(type: AlertType.error, message: 'No product found');
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
              AsyncValue<List<OutletModel>> retailerList = ref.watch(deliveryOutletListProvider);
              return retailerList.when(
                  data: (data) {
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
                          items: data.map((item) {
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
                                      style: TextStyle(color: Colors.black, fontSize: normalFontSize),
                                    ),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    CoolerAvailableImageWidget(outlet: item),
                                    item.hasPreOrdered
                                        ? const Icon(
                                            Icons.done_all,
                                            color: Colors.green,
                                          )
                                        : Container()
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
                            _saleController.handleRetailerChange(val, fromDelivery: true);

                            // ref.watch(selectedAlphabetProvider);
                            // ref.refresh(outletSaleStatusProvider);
                          },
                        ),
                      ),
                    );
                  },
                  error: (e, s) => LangText('$e'),
                  loading: () => const CircularProgressIndicator());
            }),
          ),
        ),
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
            gradient: primaryGradient,
          ),
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
                      ref.read(deliveryOutletListProvider.notifier).searchByFirstLetter(alphabetList[index]);

                      ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.inactive;
                      // ref.refresh(selectedRetailerProvider);
                      // ref.read(selectedAlphabetProvider.notifier).state = alphabetList[index];
                      // ref.read(retailerSaleStatusProvider.state).state = RetailerSaleStatus.inactive;
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

  Widget moduleDropdown() {
    return Consumer(
      builder: (context, ref, _) {
        OutletModel? selectedRetailer = ref.watch(selectedRetailerProvider);
        if(selectedRetailer==null) {
          return const SizedBox();
        }
        AsyncValue<List<Module>> asyncModules = ref.watch(moduleListProvider);
        Module? module = ref.watch(selectedSalesModuleProvider);
        return asyncModules.when(
            data: (data) {
              if (data.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  if (initialSet == false) {
                    ref.read(selectedSalesModuleProvider.notifier).state = data[0];
                    initialSet = true;
                  }
                });
              }
              if(data.length==1){
                return const SizedBox();
              }
              return Padding(
                padding: EdgeInsets.only(/*left: 10.sp, right: 10.sp,*/ top: 10.sp),
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
                          style: TextStyle(color: Colors.grey, fontSize: 8.sp),
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
                                    "${item.name}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black, fontSize: normalFontSize),
                                  ),
                                  SizedBox(
                                    width: 1.w, // item.totalSale.toStringAsFixed(2)
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
                          ref.read(selectedSalesModuleProvider.notifier).state = val;
                          // print(val!.retailerName);
                          // salesController.handleRetailerChange(val);
                          // salesController.handleRetailerChange(val);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
            error: (e, s) => Text('$e'),
            loading: () => Container());
      },
    );
  }
}
