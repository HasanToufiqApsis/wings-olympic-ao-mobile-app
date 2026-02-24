import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/string_extension.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import 'case_piece_ui.dart';

class PreorderCategoryFilterButtons extends ConsumerWidget {
  const PreorderCategoryFilterButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<PreorderCategoryFilterButtonType>> asyncPreorderFilter = ref.watch(preorderFilterModelProvider);
    PreorderCategoryFilterButtonType type = ref.watch(selectedPreorderFilterTypeProvider);
    OutletSaleStatus geoFencingStatus = ref.watch(outletSaleStatusProvider);
    return asyncPreorderFilter.when(
        data: (preorderFilter) {
          if (preorderFilter.isNotEmpty && geoFencingStatus==OutletSaleStatus.showSkus) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: preorderFilter.map((e) =>InkWell(
                onTap: (){

                },
                child: CheckboxListTile(
                  title: LangText(e.name.capitalizeFirstLetter),
                  value: type == e,
                  onChanged: (v) {
                    ref.read(selectedPreorderFilterTypeProvider.notifier).state = e;
                  },
                ),
                // child: Padding(
                //   padding:  EdgeInsets.only(right: 10.sp),
                //   child: Container(
                //     height: 3.h,
                //     // width: 18.w,
                //     decoration: BoxDecoration(
                //         gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,  colors:type!=e?[primaryGrey,primaryGrey]: [primaryGreen, blue3]),
                //         // color: type!=e? primaryGrey : primaryGreen,
                //         borderRadius: BorderRadius.circular(5.sp),
                //         border: Border.all(color: primaryGreen)
                //     ),
                //     padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                //     child: Center(
                //       child: Text(
                //         e.name.toUpperCase(),
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             color: type!=e? Colors.black : Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 9.sp
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ) ).toList(),
              // children: [
              //   // CasePieceUI(selectUnitAutoDisposeProvider: selectedUnitProvider,),
              //   // Padding(
              //   //   padding: EdgeInsets.only(right: 10.sp),
              //   //   child: Container(
              //   //     alignment: Alignment.centerRight,
              //   //     child: Container(
              //   //       decoration: BoxDecoration(
              //   //         borderRadius: BorderRadius.circular(5.sp),
              //   //         gradient: LinearGradient(
              //   //           begin: Alignment.topCenter,
              //   //           end: Alignment.bottomCenter,
              //   //           colors: [primaryGreen, primaryBlue],
              //   //         ),
              //   //       ),
              //   //       child: DropdownButton<PreorderCategoryFilterButtonType>(
              //   //         value: type,
              //   //         icon: const Icon(
              //   //           Icons.arrow_drop_down_outlined,
              //   //           color: Colors.white,
              //   //         ),
              //   //         iconSize: 24,
              //   //         // elevation: 16,
              //   //         selectedItemBuilder: (context) => preorderFilter
              //   //             .map<Widget>((e) => Align(
              //   //                 alignment: Alignment.center,
              //   //                 child: Padding(
              //   //                     padding: EdgeInsets.symmetric(horizontal: 1.w),
              //   //                     child: LangText(
              //   //                       e.name.toString().toUpperCase(),
              //   //                       style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold),
              //   //                     ))))
              //   //             .toList(),
              //   //         underline: Container(
              //   //           height: 0,
              //   //           color: Colors.transparent,
              //   //         ),
              //   //         onChanged: (newValue) {
              //   //           if (newValue != null) {
              //   //             ref.read(selectedPreorderFilterTypeProvider.notifier).state = newValue;
              //   //           }
              //   //         },
              //   //         items: preorderFilter.map((item) {
              //   //           return DropdownMenuItem(
              //   //             value: item,
              //   //             child: Padding(
              //   //               padding: EdgeInsets.symmetric(horizontal: 1.w),
              //   //               child: LangText(
              //   //                 item.name.toString().toUpperCase(),
              //   //                 style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
              //   //               ),
              //   //             ),
              //   //           );
              //   //         }).toList(),
              //   //       ),
              //   //     ),
              //   //   ),
              //   // ),
              // ],
            );
            return Padding(
              padding:  EdgeInsets.only(left: 10.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: preorderFilter.map((e) =>InkWell(
                  onTap: (){
                    ref.read(selectedPreorderFilterTypeProvider.notifier).state = e;
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(right: 10.sp),
                    child: Container(
                      height: 3.h,
                      // width: 18.w,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,  colors:type!=e?[primaryGrey,primaryGrey]: [primary, red3]),
                          // color: type!=e? primaryGrey : primaryGreen,
                          borderRadius: BorderRadius.circular(5.sp),
                          border: Border.all(color: primary)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                      child: Center(
                        child: Text(
                         e.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: type!=e? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9.sp
                          ),
                        ),
                      ),
                    ),
                  ),
                ) ).toList(),
                // children: [
                //   // CasePieceUI(selectUnitAutoDisposeProvider: selectedUnitProvider,),
                //   // Padding(
                //   //   padding: EdgeInsets.only(right: 10.sp),
                //   //   child: Container(
                //   //     alignment: Alignment.centerRight,
                //   //     child: Container(
                //   //       decoration: BoxDecoration(
                //   //         borderRadius: BorderRadius.circular(5.sp),
                //   //         gradient: LinearGradient(
                //   //           begin: Alignment.topCenter,
                //   //           end: Alignment.bottomCenter,
                //   //           colors: [primaryGreen, primaryBlue],
                //   //         ),
                //   //       ),
                //   //       child: DropdownButton<PreorderCategoryFilterButtonType>(
                //   //         value: type,
                //   //         icon: const Icon(
                //   //           Icons.arrow_drop_down_outlined,
                //   //           color: Colors.white,
                //   //         ),
                //   //         iconSize: 24,
                //   //         // elevation: 16,
                //   //         selectedItemBuilder: (context) => preorderFilter
                //   //             .map<Widget>((e) => Align(
                //   //                 alignment: Alignment.center,
                //   //                 child: Padding(
                //   //                     padding: EdgeInsets.symmetric(horizontal: 1.w),
                //   //                     child: LangText(
                //   //                       e.name.toString().toUpperCase(),
                //   //                       style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold),
                //   //                     ))))
                //   //             .toList(),
                //   //         underline: Container(
                //   //           height: 0,
                //   //           color: Colors.transparent,
                //   //         ),
                //   //         onChanged: (newValue) {
                //   //           if (newValue != null) {
                //   //             ref.read(selectedPreorderFilterTypeProvider.notifier).state = newValue;
                //   //           }
                //   //         },
                //   //         items: preorderFilter.map((item) {
                //   //           return DropdownMenuItem(
                //   //             value: item,
                //   //             child: Padding(
                //   //               padding: EdgeInsets.symmetric(horizontal: 1.w),
                //   //               child: LangText(
                //   //                 item.name.toString().toUpperCase(),
                //   //                 style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
                //   //               ),
                //   //             ),
                //   //           );
                //   //         }).toList(),
                //   //       ),
                //   //     ),
                //   //   ),
                //   // ),
                // ],
              ),
            );
          }
          return Container();
        },
        error: (e, s) => Container(),
        loading: () => Container());
  }
}
