import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/decoration_extensions.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/coupon/coupon_model.dart';
import '../../../models/products_details_model.dart';
import '../../../models/qc_config_model.dart';
import '../../../models/qc_info_model.dart';
import '../../../models/sales/formatted_sales_preorder_discount_data_model.dart';
import '../../../models/sales/sale_data_model.dart';
import '../../../models/survey/question_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/headline.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/sales_date_widget.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/before_sale_services/survey_service.dart';
import '../../../services/coupon_service.dart';
import '../../../services/price_services.dart';
import '../../../utils/case_piece_type_utils.dart';
import '../../../utils/sales_type_utils.dart';
import '../../qc/ui/qc_ui.dart';
import '../../survey/survey_ui.dart';
import '../controller/sale_controller.dart';
import 'coupon_examine_ui.dart';
import 'discount_examin_ui.dart';
import 'examine_title_tab.dart';
import 'sku_case_piece_show_widget.dart';

class ExamineUI extends ConsumerStatefulWidget {
  final AllKindOfSaleDataModel allKindOfSaleDataModel;

  ExamineUI({required this.allKindOfSaleDataModel});

  static const routeName = "/examine";

  @override
  _ExamineUIState createState() => _ExamineUIState();
}

class _ExamineUIState extends ConsumerState<ExamineUI> {
  final GlobalWidgets globalWidgets = GlobalWidgets();

  late final SaleController _salesController;
  late Alerts _alerts;

  @override
  void initState() {
    super.initState();
    _alerts = Alerts(context: context);
    _salesController = SaleController(context: context, ref: ref);
    _salesController.selectSlabPromotionNew(slabs: widget.allKindOfSaleDataModel.slabsList ?? []);
  }

  @override
  void dispose() {
    couponTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ref.refresh(couponDiscountProvider);
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.allKindOfSaleDataModel.saleType == SaleType.preorder ? "Pre-order View" : "Delivery View",
          titleImage: "pre_order_button.png",
          onLeadingIconPressed: () {
            Alerts(context: context).customDialog(
                message: "Are you sure?",
                twoButtons: true,
                onTap1: () {
                  // ref.refresh(couponDiscountProvider);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                onTap2: () {
                  Navigator.of(context).pop();
                });
          },
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          children: [
            ///=============== Retailer Info ===========================
            const SalesDateWidget(removeExtraPadding: true,),
            2.h.verticalSpacing,

            //====================================pre order list ================================
            Consumer(builder: (context, ref, _) {
              Map<int, List<SelectedQCInfoModel>> qcByModule = ref.watch(finalQcInfoListProvider);
              return Column(
                children: List.generate(widget.allKindOfSaleDataModel.modules.length+1, (index) {
                  if (index == widget.allKindOfSaleDataModel.modules.length) {
                    return Consumer(
                      builder: (BuildContext context, WidgetRef ref, Widget? child) {
                        bool couponVisible = ref.watch(visibleCoupon);
                        return TotalDiscountExamineUI(
                          totalSaleData: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData,
                          discounts: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel
                              .discountData[widget.allKindOfSaleDataModel.modules[0].id] ??
                              [],
                          coupon: couponVisible ? widget.allKindOfSaleDataModel.coupon : null,
                          slabWise: false,
                        );
                      },
                    );
                  }
                  if (widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel
                      .preorderData[(widget.allKindOfSaleDataModel.modules[index].id)]!.isNotEmpty) {
                    ///sum all sku quantity and sku price for this module
                    List<ProductDetailsModel> products = widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel
                        .preorderData[widget.allKindOfSaleDataModel.modules[index].id] ??
                        [];
                    int totalVolumeForThisModule = 0;
                    num totalValueForThisModule = 0;
                    for (var val in products) {
                      totalVolumeForThisModule += val.preorderData?.qty ?? 0;
                      totalValueForThisModule += val.preorderData?.price ?? 0;
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// sku quantity price [TITLE]
                          ExamineTitleTab(
                            module: widget.allKindOfSaleDataModel.modules[index],
                          ),
                          Container(
                            decoration: widget.allKindOfSaleDataModel.modules[index].titleBackgroundDecoration,
                            child: DefaultTextStyle(
                              style: TextStyle(fontSize: normalFontSize, color: Colors.white, fontWeight: FontWeight.bold),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: LangText(
                                        'SKU',
                                        style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: LangText(
                                          'Quantity',
                                          style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: LangText(
                                        'Price',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// selected sku list
                          Container(
                            color: Colors.white,
                            child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel
                                    .preorderData[widget.allKindOfSaleDataModel.modules[index].id]!.length,
                                itemBuilder: (context, index1) {
                                  ProductDetailsModel product = widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel
                                      .preorderData[widget.allKindOfSaleDataModel.modules[index].id]![index1];

                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: LangText(
                                            product.shortName,
                                            style: TextStyle(fontSize: smallFontSize, color: grey),
                                            // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            // alignment:Alignment.centerRight,
                                            child: SKUCasePieceShowWidget(
                                              sku: product,
                                              qty: product.preorderData!.qty,
                                              showUnitName: true,
                                              unitTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                                              qtyTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: LangText(
                                            product.preorderData!.price.toStringAsFixed(2),
                                            isNumber: true,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: smallFontSize, color: grey),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),

                          /// total price per slab  for all sku
                          FutureBuilder(
                              future: PriceServices().calculateTotalPriceForQc(
                                qcByModule.containsKey(widget.allKindOfSaleDataModel.modules[index].id)
                                    ? qcByModule[widget.allKindOfSaleDataModel.modules[index].id] ?? []
                                    : [],
                              ),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                double price = snapshot.data as double;
                                SaleDataModel totalSaleData = widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData;
                                return Column(
                                  children: [
                                    //qc settlement
                                    qcByModule.containsKey(widget.allKindOfSaleDataModel.modules[index].id)
                                        ? Container(
                                      width: 100.w,
                                      height: 4.h,
                                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(5.sp),
                                          bottomLeft: Radius.circular(5.sp),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: LangText(
                                              'Damage settlement',
                                              style: TextStyle(fontSize: smallFontSize, color: Colors.red),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: LangText(
                                                "--",
                                                style: TextStyle(fontSize: smallFontSize, color: Colors.red),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: LangText(
                                              price.toStringAsFixed(2),
                                              isNumber: true,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontSize: smallFontSize, color: Colors.red),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                        : Container(),

                                    ///module wise total sales
                                    Container(
                                      width: 100.w,
                                      height: 4.h,
                                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                                      decoration: widget.allKindOfSaleDataModel.modules[index].bottomBackgroundDecoration,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: LangText(
                                              'Total',
                                              style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.unitWiseTotalQty.entries
                                                  .map(
                                                    (e) => UnitWiseCountWidget(
                                                  unitName: CasePieceTypeUtils.toStr(e.key),
                                                  count: totalVolumeForThisModule,
                                                  qtyTextStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                  unitTextStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                                  .toList(),
                                            ),
                                          ),
                                          Expanded(
                                            child: LangText(
                                              // (totalSaleData.price - totalSaleData.discount).toStringAsFixed(2),
                                              (totalValueForThisModule).toStringAsFixed(2),
                                              //  - price - totalSaleData.discount
                                              isNumber: true,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),

                          ///discount
                          DiscountExamineUI(
                            discounts: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel
                                .discountData[widget.allKindOfSaleDataModel.modules[index].id] ??
                                [],
                            module: widget.allKindOfSaleDataModel.modules[index],
                          ),

                          Consumer(
                            builder: (BuildContext context, WidgetRef ref, Widget? child) {
                              bool couponVisible = ref.watch(visibleCoupon);
                              if (couponVisible == true) {
                                return CouponExamineUI(
                                  coupon: widget.allKindOfSaleDataModel.coupon!,
                                  discounts: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel
                                      .discountData[widget.allKindOfSaleDataModel.modules[index].id] ??
                                      [],
                                  slabList: widget.allKindOfSaleDataModel.slabsList ?? [],
                                  totalSaleData: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData,
                                );
                              }
                              return const SizedBox();
                            },
                          ),

                          ///coupon uses discount
                          FutureBuilder(
                            future: CouponService().checkRetailerCouponCode(retailer: widget.allKindOfSaleDataModel.retailer),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox();
                              } else {
                                if (snapshot.data == null) {
                                  return const SizedBox();
                                }
                                return FutureBuilder(
                                  future: CouponService().getCouponFromCouponCode(couponCode: snapshot.data!["code"]),
                                  builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
                                    if (!snap.hasData) {
                                      return const SizedBox();
                                    } else {
                                      if (snap.data == null) {
                                        return const SizedBox();
                                      }
                                      CouponModel coupon = snap.data;

                                      print(
                                          'sale type is::::: ${widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData.discount}'
                                              ' coupon is:: ${coupon.code}'
                                              ' slab list:: ${widget.allKindOfSaleDataModel.slabsList?.length}');

                                      return CouponExamineUI(
                                        coupon: coupon,
                                        discounts: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel
                                            .discountData[widget.allKindOfSaleDataModel.modules[index].id] ??
                                            [],
                                        slabList: widget.allKindOfSaleDataModel.slabsList ?? [],
                                        totalSaleData: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData,
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),

                          ///total price
                          Consumer(
                            builder: (BuildContext context, WidgetRef ref, Widget? child) {
                              bool couponVisible = ref.watch(visibleCoupon);
                              return TotalDiscountExamineUI(
                                  totalSaleData: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData,
                                  discounts: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel
                                      .discountData[widget.allKindOfSaleDataModel.modules[index].id] ??
                                      [],
                                  coupon: couponVisible ? widget.allKindOfSaleDataModel.coupon : null,
                                  totalSalesValue: totalValueForThisModule,
                                  totalSalesVolume: totalVolumeForThisModule,
                                  module: widget.allKindOfSaleDataModel.modules[index]
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                }),
              );
            }),

            3.h.verticalSpacing,
            Column(
              children: [
                //==================================== qc & print ================================
                Builder(builder: (context) {
                  if (widget.allKindOfSaleDataModel.saleType == SaleType.delivery) {
                    return Consumer(builder: (context, ref, _) {
                      AsyncValue<QcConfigurationModel> asyncQcConfiguration = ref.watch(qcConfigurationProvider);
                      return asyncQcConfiguration.when(
                          data: (qcConfiguration) {
                            if (!qcConfiguration.qcEnabled) {
                              return Container();
                            }
                            return SubmitButtonGroup(
                              button1Label: "Damage",
                              button1Color: Colors.amber,
                              onButton1Pressed: () {
                                SaleDataModel totalSaleData = widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData;
                                ref.read(maxQCProvider.notifier).state = totalSaleData.price.toDouble();
                                List<SelectedQCInfoModel> list = [];
                                // ref.read(selectedQCInfoListProvider.state).state = [];
                                Map<int, List<SelectedQCInfoModel>> qcData = ref.read(finalQcInfoListProvider);
                                qcData.forEach((key, value) {
                                  list.addAll(value);
                                });
                                ref.read(selectedQCInfoListProvider.state).state = [...list];
                                Navigator.pushNamed(context, QCUI.routeName).then((value) {
                                  if (value != null) {
                                    _salesController.saveToFinalQcInfo(value as List<SelectedQCInfoModel>);
                                  }
                                });
                              },
                            );
                          },
                          error: (error, _) => Container(),
                          loading: () => Container());
                    });
                  }
                  return Container();
                }),

                1.h.verticalSpacing,
                if (widget.allKindOfSaleDataModel.saleType != SaleType.delivery)
                  Consumer(
                    builder: (context, ref, child) {
                      bool couponVisible = ref.watch(visibleCoupon);
                      if (couponVisible == false) {
                        return SubmitButtonGroup(
                          button1Label: "Use Coupon",
                          button1Color: greenOlive,
                          onButton1Pressed: () async {
                            if (await CouponService().checkRetailerAlreadyUseCoupon(retailer: widget.allKindOfSaleDataModel.retailer) == true) {
                              _alerts.customDialog(type: AlertType.warning, description: "This outlet already used a coupon code");
                            } else {
                              couponDialogue();
                            }
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                1.h.verticalSpacing,
                Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    AsyncValue<bool> asyncAlreadySalesSubmit = ref.watch(salesSubmittedProvider);
                    return asyncAlreadySalesSubmit.when(
                        data: (alreadySalesSubmitted){
                          return SubmitButtonGroup(
                            button1Label: "Save",
                            button1Color: alreadySalesSubmitted? primary : darkGreen,
                            onButton1Pressed:  () {
                              if(!alreadySalesSubmitted) {
                                num? discountAmount = ref.read(couponDiscountProvider);

                                SaleController(context: context, ref: ref).onPrint(
                                  widget.allKindOfSaleDataModel,
                                  discountAmount,
                                );
                              }
                            },
                          );
                          // return SubmitButtonGroup(
                          //   button1Label: "Save",
                          //   button1Color: primary,
                          //   onButton1Pressed: () {
                          //     num? discountAmount = ref.read(couponDiscountProvider);
                          //
                          //     SaleController(context: context, ref: ref).onPrint(
                          //       widget.allKindOfSaleDataModel,
                          //       discountAmount,
                          //     );
                          //   },
                          // );
                        },
                        error: (error, _) {
                          debugPrint(error.toString());
                          return Container();
                        },
                        loading: ()=>Center(child: CircularProgressIndicator(),)
                    );
                  },
                ),
                // 1.h.verticalSpacing,
                //
                // // =================== survey ==========================
                // Builder(builder: (context) {
                //   if (widget.allKindOfSaleDataModel.saleType == SaleType.preorder) {
                //     return Consumer(builder: (context, ref, _) {
                //       AsyncValue<List<SurveyModel>> surveyList = ref.watch(surveyListProvider(widget.allKindOfSaleDataModel.retailer));
                //       return surveyList.when(
                //           data: (list) {
                //             if (list.isNotEmpty) {
                //               return SubmitButtonGroup(
                //                 button1Label: "Survey",
                //                 button1Color: primaryBlue,
                //                 onButton1Pressed: () async {
                //                   for (var surveyModel in list) {
                //                     await Navigator.pushNamed(context, SurveyUI.routeName, arguments: {
                //                       'retailerId': widget.allKindOfSaleDataModel.retailer.id,
                //                       'surveyModel': surveyModel,
                //                       'retailer': widget.allKindOfSaleDataModel.retailer,
                //                     }).then((value) {
                //                       ref.refresh(surveyListProvider(widget.allKindOfSaleDataModel.retailer));
                //                     });
                //                   }
                //                 },
                //               );
                //             } else {
                //               return const SizedBox();
                //             }
                //           },
                //           error: (error, stack) => const SizedBox(),
                //           loading: () => const SizedBox());
                //     });
                //   }
                //   return Container();
                // }),

                SizedBox(height: 2.h),
              ],
            ),
            3.h.verticalSpacing,

            // SizedBox(child: globalWidgets.showInfo(message: 'You can always print later from memo section'))
          ],
        ),
      ),
    );
  }

  TextEditingController couponTextController = TextEditingController();

  void couponDialogue() {
    _alerts.showModalWithWidget(
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
                    couponTextController.clear();
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
            heading("Coupon code"),
            Consumer(builder: (context, ref, _) {
              String lang = ref.watch(languageProvider);
              String hint = "APS100";
              if (lang != "en") {
                hint = "APS100";
              }
              return NormalTextField(
                textEditingController: couponTextController,
                hintText: hint,
                inputType: TextInputType.text,
              );
            }),
            SizedBox(
              width: 42.w,
              child: SubmitButtonGroup(
                button1Label: "Submit",
                onButton1Pressed: () async {
                  String couponText = couponTextController.text;
                  Navigator.of(context).pop();
                  CouponModel? coupon = await _salesController.checkAndApplyCouponCode(
                    coupon: couponText,
                    salesData: widget.allKindOfSaleDataModel,
                  );
                  couponTextController.clear();
                  if (coupon != null) {
                    widget.allKindOfSaleDataModel.coupon = coupon;

                    SaleDataModel discountSaleData = ref.watch(totalDiscountCalculationProvider(
                        widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.discountData[widget.allKindOfSaleDataModel.modules[0].id] ??
                            []));
                    num slabPromotionsDiscount = ref.watch(slabPromotionDiscount);

                    ref.read(couponDiscountProvider.notifier).state = CouponService().getCouponDiscountAmount(
                      discountSaleData: discountSaleData,
                      slabPromotionsDiscount: slabPromotionsDiscount,
                      totalSaleData: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData,
                      coupon: coupon,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}