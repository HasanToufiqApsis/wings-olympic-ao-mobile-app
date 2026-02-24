import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/target/sr_stt_target_model.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/asset_download/asset_service.dart';
import '../../../services/sync_read_service.dart';
import '../controller/dashboard_controller.dart';


class TargetAchievementTabUI extends ConsumerWidget {
  const TargetAchievementTabUI( {required this.sttData, Key? key}) : super(key: key);
  final SRDetailTargetModel sttData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double achievement = (sttData.achievement * 100) / sttData.target;

    Color mainColor = DashboardController(context: context, ref: ref).getTargetColor(achievement: achievement, minimumTarget: 100);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(color: mainColor, width: 2.sp),
          boxShadow: [
            BoxShadow(
              color: grey.withOpacity(0.2),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
               child: Row(
                 children: [
                   // AssetService(context).superImage('${sttData.imageId}.png', folder: 'SKU', version: SyncReadService().getAssetVersion('SKU'), height: 10.h),
                   SizedBox(width: 2.w,),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         LangText(
                             sttData.name,
                           style: const TextStyle(
                             color: red3,
                             fontWeight: FontWeight.w400,
                           ),
                         ),
                         const SizedBox(height: 4),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             LangText(
                               'Material Code:',
                               style: const TextStyle(
                                 color: Colors.black,
                               ),
                             ),
                             const SizedBox(width: 4),
                             LangText(
                               sttData.materialCode ?? '',
                               style: const TextStyle(
                                 color: red3,
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   )
                 ],
               ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Container(width: 0.1.w,color: Colors.grey,),
              ),
              Container(
                height: 10.h,
                width: 35.w,
                padding: EdgeInsets.only(left: 10.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.crisis_alert, size: normalFontSize,),
                                    LangText(
                                      "Target",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: grey,

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // SizedBox(height: 1.h,),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                child: Row(

                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, size: normalFontSize,),
                                    LangText(
                                      "Achieve",
                                      style: TextStyle(
                                        color: grey,

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                child: Row(

                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, size: normalFontSize,),
                                    LangText(
                                      "Achievement",
                                      style: TextStyle(
                                        color: grey,

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // SizedBox(height: 1.h,),
                            // FittedBox(
                            //   child: LangText(
                            //     "Achievement",
                            //     style: TextStyle(
                            //       color: grey,
                            //
                            //     ),
                            //   ),
                            // ),
                          ],
                        )
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LangText(
                            sttData.target.toString(),
                            style: TextStyle(
                              color: red3,
                            ),
                            isNum: true,
                            isNumber: true,
                          ),

                          LangText(
                            sttData.achievement.toStringAsFixed(2),
                            style: TextStyle(
                              color: red3,

                            ),
                            isNum: true,
                            isNumber: true,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LangText(
                                achievement.toStringAsFixed(0),
                                style: TextStyle(
                                  color: mainColor,

                                ),
                                isNum: false,
                                isNumber: true,
                              ),
                              LangText(
                                "%",
                                style: TextStyle(
                                  color: mainColor,

                                ),
                                isNum: false,
                                isNumber: true,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
