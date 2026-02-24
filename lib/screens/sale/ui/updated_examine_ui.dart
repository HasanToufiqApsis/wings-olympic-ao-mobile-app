import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/reusable_widgets/sales_widget/examine_table_header.dart';
import 'package:wings_olympic_sr/screens/sale/ui/updated_discount_examin_ui.dart';
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
import '../../../reusable_widgets/sales_widget/examine_total_row.dart';
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
import 'discount_examin_ui.dart' hide TotalDiscountExamineUI;
import 'examine_title_tab.dart';
import 'sku_case_piece_show_widget.dart';

class UpdatedExamineUI extends ConsumerStatefulWidget {
  final AllKindOfSaleDataModel allKindOfSaleDataModel;

  UpdatedExamineUI({required this.allKindOfSaleDataModel});

  static const routeName = "/examine";

  @override
  _ExamineUIState createState() => _ExamineUIState();
}

class _ExamineUIState extends ConsumerState<UpdatedExamineUI> {
  final GlobalWidgets globalWidgets = GlobalWidgets();
  final TextEditingController couponTextController = TextEditingController();
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
      onWillPop: () async => true,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          children: [
            const SalesDateWidget(removeExtraPadding: true),
            2.h.verticalSpacing,
            _buildModuleList(),
            _buildGrandTotal(),
            3.h.verticalSpacing,
            _buildBottomActions(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: _getAppBarTitle(widget.allKindOfSaleDataModel.saleType),
      titleImage: "pre_order_button.png",
      onLeadingIconPressed: () {
        Alerts(context: context).customDialog(
            message: "Are you sure?",
            twoButtons: true,
            onTap1: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            onTap2: () => Navigator.of(context).pop());
      },
    );
  }

  Widget _buildModuleList() {
    return Consumer(builder: (context, ref, _) {
      return Column(
        children: widget.allKindOfSaleDataModel.modules.map((module) {
          final products = widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.preorderData[module.id] ?? [];

          if (products.isEmpty) return const SizedBox();

          int totalVolume = 0;
          num totalValue = 0;
          for (var val in products) {
            totalVolume += val.preorderData?.qty ?? 0;
            totalValue += val.preorderData?.price ?? 0;
          }

          return _ModuleItemView(
            module: module,
            products: products,
            allKindOfSaleDataModel: widget.allKindOfSaleDataModel,
            totalVolume: totalVolume,
            totalValue: totalValue,
          );
        }).toList(),
      );
    });
  }

  Widget _buildGrandTotal() {
    return Consumer(
      builder: (context, ref, child) {
        bool couponVisible = ref.watch(visibleCoupon);
        return TotalDiscountExamineUI(
          totalSaleData: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData,
          discounts: widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.discountData[widget.allKindOfSaleDataModel.modules[0].id] ?? [],
          coupon: couponVisible ? widget.allKindOfSaleDataModel.coupon : null,
          slabWise: false,
        );
      },
    );
  }

  Widget _buildBottomActions() {
    return Column(
      children: [
        if (widget.allKindOfSaleDataModel.saleType == SaleType.delivery) _buildDamageButton(),
        1.h.verticalSpacing,
        // if (widget.allKindOfSaleDataModel.saleType != SaleType.delivery) _buildCouponButton(),
        // 1.h.verticalSpacing,
        _buildSaveButton(),
        // 1.h.verticalSpacing,
        // if (widget.allKindOfSaleDataModel.saleType == SaleType.preorder) _buildSurveyButton(),
      ],
    );
  }

  Widget _buildDamageButton() {
    return Consumer(builder: (context, ref, _) {
      return ref.watch(qcConfigurationProvider).when(
        data: (qcConfig) {
          if (!qcConfig.qcEnabled) return Container();
          return SubmitButtonGroup(
            button1Label: "Damage",
            button1Color: Colors.amber,
            onButton1Pressed: () {
              SaleDataModel totalSaleData = widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData;
              ref.read(maxQCProvider.notifier).state = totalSaleData.price.toDouble();
              List<SelectedQCInfoModel> list = [];
              ref.read(finalQcInfoListProvider).forEach((key, value) => list.addAll(value));
              ref.read(selectedQCInfoListProvider.state).state = [...list];

              Navigator.pushNamed(context, QCUI.routeName).then((value) {
                if (value != null) {
                  _salesController.saveToFinalQcInfo(value as List<SelectedQCInfoModel>);
                }
              });
            },
          );
        },
        error: (_, __) => Container(),
        loading: () => Container(),
      );
    });
  }

  Widget _buildCouponButton() {
    return Consumer(builder: (context, ref, child) {
      if (ref.watch(visibleCoupon)) return const SizedBox();
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
    });
  }

  Widget _buildSaveButton() {
    // return Consumer(builder: (context, ref, _) {
    //   return SubmitButtonGroup(
    //     button1Label: "Save",
    //     button1Color: primary,
    //     onButton1Pressed: () {
    //
    //     },
    //   );
    // });

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AsyncValue<bool> asyncAlreadySalesSubmit = ref.watch(salesSubmittedProvider);
        return asyncAlreadySalesSubmit.when(
            data: (alreadySalesSubmitted){
              return SubmitButtonGroup(
                button1Label: "Save",
                button1Color: alreadySalesSubmitted? lightMediumGrey : primary,
                onButton1Pressed:  () {
                  if(!alreadySalesSubmitted) {
                    num? discountAmount = ref.read(couponDiscountProvider);
                    SaleController(context: context, ref: ref).onPrint(widget.allKindOfSaleDataModel, discountAmount);
                  }
                },
              );
            },
            error: (error, _) {
              debugPrint(error.toString());
              return Container();
            },
            loading: ()=>Center(child: CircularProgressIndicator(),)
        );
      },
    );
  }

  Widget _buildSurveyButton() {
    return Consumer(builder: (context, ref, _) {
      return ref.watch(surveyListProvider(widget.allKindOfSaleDataModel.retailer)).when(
        data: (list) {
          if (list.isEmpty) return const SizedBox();
          return SubmitButtonGroup(
            button1Label: "Survey",
            button1Color: primaryBlue,
            onButton1Pressed: () async {
              for (var surveyModel in list) {
                await Navigator.pushNamed(context, SurveyUI.routeName, arguments: {
                  'retailerId': widget.allKindOfSaleDataModel.retailer.id,
                  'surveyModel': surveyModel,
                  'retailer': widget.allKindOfSaleDataModel.retailer,
                });
                ref.refresh(surveyListProvider(widget.allKindOfSaleDataModel.retailer));
              }
            },
          );
        },
        error: (_, __) => const SizedBox(),
        loading: () => const SizedBox(),
      );
    });
  }

  void couponDialogue() {
    _alerts.showModalWithWidget(
      backgroundColor: scaffoldBGColor,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  couponTextController.clear();
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: 100.circularRadius, color: primary),
                  padding: const EdgeInsets.all(3),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
            heading("Coupon code"),
            Consumer(builder: (context, ref, _) {
              return NormalTextField(
                textEditingController: couponTextController,
                hintText: ref.watch(languageProvider) != "en" ? "APS100" : "APS100",
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
                        widget.allKindOfSaleDataModel.salesPreorderDiscountDataModel.discountData[widget.allKindOfSaleDataModel.modules[0].id] ?? []));
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

  String _getAppBarTitle(SaleType saleType) {
    switch (saleType) {
      case SaleType.preorder:
        return "Preorder";
      case SaleType.delivery:
        return "Delivery";
      case SaleType.spotSale:
        return "Sale";
    }
  }
}

class _ModuleItemView extends StatelessWidget {
  final dynamic module;
  final List<ProductDetailsModel> products;
  final AllKindOfSaleDataModel allKindOfSaleDataModel;
  final int totalVolume;
  final num totalValue;

  const _ModuleItemView({
    required this.module,
    required this.products,
    required this.allKindOfSaleDataModel,
    required this.totalVolume,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExamineTitleTab(module: module),
          ExamineTableHeader(),
          Container(
            color: Colors.white,
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: products.length,
                itemBuilder: (context, index) => _buildProductRow(products[index])),
          ),
          _buildTotalWithDamageSettlement(),
          UpdatedDiscountExamineUI(
            discounts: allKindOfSaleDataModel.salesPreorderDiscountDataModel.discountData[module.id] ?? [],
            module: module,
          ),
          _buildCouponSection(),
          _buildAutoAppliedCoupon(),
          Consumer(builder: (context, ref, _) {
            bool couponVisible = ref.watch(visibleCoupon);
            return TotalDiscountExamineUI(
              totalSaleData: allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData,
              discounts: allKindOfSaleDataModel.salesPreorderDiscountDataModel.discountData[module.id] ?? [],
              coupon: couponVisible ? allKindOfSaleDataModel.coupon : null,
              totalSalesValue: totalValue,
              totalSalesVolume: totalVolume,
              module: module,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProductRow(ProductDetailsModel product) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      child: Row(
        children: [
          Expanded(child: LangText(product.shortName, style: TextStyle(fontSize: smallFontSize, color: grey))),
          Expanded(
            child: Center(
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
  }

  Widget _buildTotalWithDamageSettlement() {
    return Consumer(builder: (context, ref, _) {
      Map<int, List<SelectedQCInfoModel>> qcByModule = ref.watch(finalQcInfoListProvider);
      return FutureBuilder(
        future: PriceServices().calculateTotalPriceForQc(qcByModule[module.id] ?? []),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          double price = snapshot.data as double;

          return Column(
            children: [
              if (qcByModule.containsKey(module.id))
                Container(
                  width: 100.w,
                  height: 4.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: LangText('Damage settlement', style: TextStyle(fontSize: smallFontSize, color: Colors.red))),
                      Expanded(child: Center(child: LangText("--", style: TextStyle(fontSize: smallFontSize, color: Colors.red)))),
                      Expanded(child: LangText(price.toStringAsFixed(2), isNumber: true, textAlign: TextAlign.end, style: TextStyle(fontSize: smallFontSize, color: Colors.red))),
                    ],
                  ),
                ),
              ExamineTotalRow(
                price: totalValue.toStringAsFixed(2),
                totalVolume: totalVolume,
                unitWiseTotalQty: allKindOfSaleDataModel.salesPreorderDiscountDataModel.unitWiseTotalQty,
              ),
              // Container(
              //   width: 100.w,
              //   height: 4.h,
              //   padding: EdgeInsets.symmetric(horizontal: 2.w),
              //   color: primary,
              //   child: Row(
              //     children: [
              //       Expanded(child: LangText('Total', style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white))),
              //       Expanded(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: allKindOfSaleDataModel.salesPreorderDiscountDataModel.unitWiseTotalQty.entries
              //               .map((e) => UnitWiseCountWidget(
              //             unitName: CasePieceTypeUtils.toStr(e.key),
              //             count: totalVolume,
              //             qtyTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              //             unitTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              //           ))
              //               .toList(),
              //         ),
              //       ),
              //       Expanded(
              //         child: LangText(
              //           totalValue.toStringAsFixed(2),
              //           isNumber: true,
              //           textAlign: TextAlign.end,
              //           style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          );
        },
      );
    });
  }

  Widget _buildCouponSection() {
    return Consumer(builder: (context, ref, _) {
      if (!ref.watch(visibleCoupon)) return const SizedBox();
      return CouponExamineUI(
        coupon: allKindOfSaleDataModel.coupon!,
        discounts: allKindOfSaleDataModel.salesPreorderDiscountDataModel.discountData[module.id] ?? [],
        slabList: allKindOfSaleDataModel.slabsList ?? [],
        totalSaleData: allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData,
      );
    });
  }

  Widget _buildAutoAppliedCoupon() {
    return FutureBuilder(
      future: CouponService().checkRetailerCouponCode(retailer: allKindOfSaleDataModel.retailer),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) return const SizedBox();
        return FutureBuilder(
          future: CouponService().getCouponFromCouponCode(couponCode: snapshot.data!["code"]),
          builder: (context, snap) {
            if (!snap.hasData || snap.data == null) return const SizedBox();
            return CouponExamineUI(
              coupon: snap.data!,
              discounts: allKindOfSaleDataModel.salesPreorderDiscountDataModel.discountData[module.id] ?? [],
              slabList: allKindOfSaleDataModel.slabsList ?? [],
              totalSaleData: allKindOfSaleDataModel.salesPreorderDiscountDataModel.totalSaleData,
            );
          },
        );
      },
    );
  }
}