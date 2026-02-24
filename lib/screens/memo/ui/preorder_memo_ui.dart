import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/screens/memo/ui/memo_edit_icon_btn.dart';
import 'package:wings_olympic_sr/utils/extensions/decoration_extensions.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/sales/memo_information_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../utils/case_piece_type_utils.dart';
import '../../sale/ui/sku_case_piece_show_widget.dart';
import 'discount_preview_ui.dart';
import 'memo_title_tab.dart';

class PreorderMemoUI extends StatelessWidget {
  final SaleType saleType;
  final Function()? onMemoEdit;

  PreorderMemoUI({Key? key, required this.saleType, required this.onMemoEdit}) : super(key: key);
  final GlobalWidgets globalWidgets = GlobalWidgets();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      String lang = ref.watch(languageProvider);
      String m = 'Preorder';
      if (lang != 'en') {
        m = 'প্রিঅর্ডার';
      }
      // AsyncValue<List<PromotionModel>> asyncPromotions = ref.watch(comboPromotionPerRetailerProvider);
      AsyncValue<List<PreorderMemoInformationModel>> saleData = ref.watch(retailerPreorderRecordProvider(saleType));
      return saleData.when(
          data: (data) {
            return ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.sp), bottomRight: Radius.circular(5.sp)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            offset: const Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    MemoTitleTab(
                                      module: data[index].module,
                                      title: saleType == SaleType.preorder ? 'Pre-order' : 'Sale',
                                      bgc: saleType == SaleType.preorder ? primary : tealBlue,
                                    ),
                                    Expanded(child: const SizedBox()),
                                  ],
                                ),
                              ),
                              MemoEditIconBtn(
                                bgc: Colors.orange,
                                iconColor: Colors.white,
                                onTap: onMemoEdit,
                              ),
                            ],
                          ),

                          /// table header
                          Container(
                            decoration: BoxDecoration(
                              color: saleType == SaleType.preorder ? primary : tealBlue,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                // bottomRight: Radius.circular(10),
                                // bottomLeft: Radius.circular(10),
                              )
                            ),
                            child: DefaultTextStyle(
                              style: TextStyle(fontSize: normalFontSize, color: Colors.white, fontWeight: FontWeight.bold),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    LangText(
                                      'SKU', //SKU
                                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                    ),
                                    LangText(
                                      'Quantity', // Quantity
                                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                    ),
                                    LangText(
                                      'Price', //
                                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          ///sku list
                          ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: data[index].skus.length,
                              itemBuilder: (context, index1) {
                                return Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: LangText(
                                          data[index].skus[index1].shortName,
                                          style: TextStyle(color: red3, fontSize: normalFontSize),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: SKUCasePieceShowWidget(
                                            sku: data[index].skus[index1],
                                            qtyTextStyle: TextStyle(color: red3, fontSize: normalFontSize),
                                            unitTextStyle: TextStyle(color: red3, fontSize: normalFontSize),
                                            showUnitName: true,
                                            qty: data[index].skus[index1].preorderData!.qty,
                                          ),
                                          // child: LangText(
                                          //   data[index]
                                          //       .skus[index1]
                                          //       .preorderData!
                                          //       .qty
                                          //       .toString(),
                                          //   isNumber: true,
                                          //   style: TextStyle(
                                          //       color: blue3,
                                          //       fontSize: normalFontSize),
                                          // ),
                                        ),
                                      ),
                                      Expanded(
                                        child: LangText(
                                          data[index].skus[index1].preorderData!.price.toStringAsFixed(2),
                                          isNumber: true,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(color: red3, fontSize: normalFontSize),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),

                          ///total count
                          Container(
                            width: 100.w,
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            decoration: BoxDecoration(
                              color: saleType == SaleType.preorder ? primary : tealBlue,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: DefaultTextStyle(
                              style: TextStyle(color: Colors.white),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  data[index].totalQcAmount.price != 0.0
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(vertical: 1.h),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              LangText('Total Damage', style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold)),
                                              // Discount & Others (-)
                                              LangText(
                                                (data[index].totalQcAmount.price).toStringAsFixed(2),
                                                isNumber: true,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 1.h),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: LangText('Total',
                                                style: TextStyle(fontSize: normalFontSize, color: Colors.white, fontWeight: FontWeight.bold))),
                                        // Discount & Others (-)
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: data[index].totalCount.entries.map(
                                              (e) {
                                                if (e.value == 0) {
                                                  return const SizedBox();
                                                }
                                                return UnitWiseCountWidget(
                                                  unitName: CasePieceTypeUtils.toStr(e.key),
                                                  count: e.value,
                                                  qtyTextStyle: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                                                  unitTextStyle:
                                                      TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ),

                                        Expanded(
                                          child: LangText(
                                            (data[index].totalPreorderData.price).toStringAsFixed(2),
                                            //  - (data[index].totalDiscount.price + data[index].totalQcAmount.price)
                                            isNumber: true,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    DiscountPreviewUI(
                      discounts: data[index].discounts,
                      totalPrice: data[index].totalPreorderData.price,
                      module: data[index].module,
                      saleType: saleType,
                    ),
                    SizedBox(height: 16),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return 5.h.verticalSpacing;
              },
            );
          },
          error: (e, s) => LangText('$e'),
          loading: () => const CircularProgressIndicator());
    });
  }
}
