import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/sales/formatted_sales_preorder_discount_data_model.dart';
import '../../../models/slab_promotion_selection_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';

class SlabDiscountExamineUI extends StatelessWidget {
  const SlabDiscountExamineUI({
    Key? key,
    required this.slabList,
  }) : super(key: key);

  final List<List<SlabDiscountModel>> slabList;

  @override
  Widget build(BuildContext context) {
    if (slabList.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: secondaryBlue,
          child: ListView.builder(
            itemCount: slabList.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 0.5.h),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, parentIndex) {
              if(slabList[parentIndex].isEmpty){
                return const SizedBox();
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: slabList[parentIndex].length,
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, childIndex) {
                  var val = slabList[parentIndex][childIndex];

                  return Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {

                    List<int> beforeSelectedSlabPromotionList = ref.watch(beforeSelectedSlabPromotion);
                    // if(!beforeSelectedSlabPromotionList.contains(val.id)){
                    //   return const SizedBox();
                    // }
                    return Container(
                      color: parentIndex % 2 == 0 ? Colors.white : null,
                      padding: EdgeInsets.symmetric(vertical: 0.5.h),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                2.w.horizontalSpacing,
                                Expanded(
                                  flex: 4,
                                  child: LangText(
                                    '${val.label}',
                                    style: TextStyle(fontSize: smallFontSize, color: grey),
                                  ),
                                ),
                                Expanded(
                                  child: LangText(
                                    '${val.discountAmount}',
                                    isNumber: true,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: smallFontSize, color: grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Icon(
                                Icons.check_box,
                                color: primary,
                                size: mediumFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },);
                  // return Consumer(
                  //   builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  //     List<SlabPromotionSelectionModel> slabPromotions = ref.watch(selectedSlabPromotion);
                  //     int ind = slabPromotions.indexWhere((element) => element.slabGroupId == val.slabGroupId);
                  //     // if(ind==-1){
                  //     //   return const SizedBox();
                  //     // }
                  //     return InkWell(
                  //       onTap: () {
                  //         SaleController sc = SaleController(context: context, ref: ref);
                  //         sc.selectSlabPromotion(
                  //           slabGroupId: 76,
                  //           promotionId: val.id ?? 0,
                  //         );
                  //       },
                  //       child: Container(
                  //         color: parentIndex % 2 == 0 ? Colors.white : null,
                  //         padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  //         child: Row(
                  //           children: [
                  //             Expanded(
                  //               flex: 3,
                  //               child: Row(
                  //                 children: [
                  //                   2.w.horizontalSpacing,
                  //                   Expanded(
                  //                     flex: 4,
                  //                     child: LangText(
                  //                       '${val.label}',
                  //                       style: TextStyle(fontSize: smallFontSize, color: grey),
                  //                     ),
                  //                   ),
                  //                   Expanded(
                  //                     child: LangText(
                  //                       '${val.discountAmount}',
                  //                       isNumber: true,
                  //                       textAlign: TextAlign.end,
                  //                       style: TextStyle(fontSize: smallFontSize, color: grey),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             Expanded(
                  //               child: Center(
                  //                 child: Icon(
                  //                         Icons.check_box,
                  //                         color: primaryGreen,
                  //                         size: mediumFontSize,
                  //                       ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
