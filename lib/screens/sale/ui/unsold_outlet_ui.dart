import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/general_id_slug_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../controller/sale_controller.dart';

// class UnsoldOutletUI extends StatelessWidget {
//   const UnsoldOutletUI({Key? key}) : super(key: key);
//   // final VoidCallback onCallStart;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 3.h, left: 7.5.w, right: 7.5.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//
//           // Padding(
//           //   padding: EdgeInsets.only(left: 40.w, bottom: 1.h),
//           //   child: SizedBox(
//           //     height: 30.sp,
//           //     width: 30.sp,
//           //     child: Image.asset(
//           //       'assets/sell_out_of_selected_outlet_icon.png',
//           //     ),
//           //   ),
//           // ),
//
//           Icon(Icons.warning_amber_rounded, size: 56, color: yellow,),
//           8.verticalSpacing,
//           Center(
//             child: LangText(
//               "Why don't you want to take preorder from this outlet?",
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: primary,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 13,
//                 fontFamily: 'NotoSansBengali',
//               ),
//             ),
//           ),
//           SizedBox(height: 5.h),
//           Consumer(
//               builder: (context,ref, _){
//                 AsyncValue<List<GeneralIdSlugModel>> asyncButtonList = ref.watch(unsoldOutletListProvider);
//                 return asyncButtonList.when(
//                     data: (buttonList){
//                       return  ListView.builder(
//                           itemCount: buttonList.length,
//                           shrinkWrap: true,
//                           itemBuilder: (context, index){
//                             return SubmitButtonGroup(
//                               twoButtons: false,
//                               button1Label: buttonList[index].slug,
//                               button1Color: red3.withValues(alpha: index % 2 == 0 ? 1.0 : .8),
//                               onButton1Pressed:(){
//                                 SaleController(context: context, ref: ref).onUnsoldButtonPressed(buttonList[index]);
//                               },
//                             );
//                           }
//                       );
//
//                     },
//                     error: (error, _){
//                       return Container();
//                     },
//                     loading: (){
//                       return const Center(child: CircularProgressIndicator(),);
//                     }
//                 );
//               }
//           )
//
//         ],
//       ),
//     );
//   }
// }

class UnsoldOutletUI extends StatelessWidget {
  const UnsoldOutletUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              size: 40,
              color: Colors.orange[700],
            ),
          ),
          const SizedBox(height: 16),
          LangText(
            "Why don't you want to take preorder from this outlet?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w700,
              fontSize: 16,
              fontFamily: 'NotoSansBengali',
            ),
          ),
          const SizedBox(height: 24),
          Consumer(
            builder: (context, ref, _) {
              AsyncValue<List<GeneralIdSlugModel>> asyncButtonList =
              ref.watch(unsoldOutletListProvider);
              return asyncButtonList.when(
                data: (buttonList) {
                  return ListView.separated(
                    itemCount: buttonList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildReasonButton(
                        label: buttonList[index].slug ?? '',
                        onTap: () {
                          SaleController(context: context, ref: ref)
                              .onUnsoldButtonPressed(buttonList[index]);
                        },
                      );
                    },
                  );
                },
                error: (error, _) {
                  return const SizedBox();
                },
                loading: () {
                  return Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red[700],
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildReasonButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.04),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withOpacity(0.1)),
          ),
          alignment: Alignment.center,
          child: LangText(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.red[800],
            ),
          ),
        ),
      ),
    );
  }
}