import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/constant_variables.dart';
import '../../../../models/dsr_model.dart';
import '../../../../models/target/dashboard_target_model.dart';
import '../../../../models/target/sr_stt_target_model.dart';
import '../../../../provider/global_provider.dart';
import '../../../../reusable_widgets/global_widgets.dart';
import '../../../../reusable_widgets/language_textbox.dart';
import '../../../target_achievement/controller/dashboard_controller.dart';
import '../../../target_achievement/ui/target_tab_view_ui.dart';
import 'target_tab_view_ui_tsm.dart';

class TargetNAchievementUITsm extends ConsumerStatefulWidget {
  const TargetNAchievementUITsm(
      {required this.color,
      required this.data,
      required this.dsr,
      required this.targetList,
      Key? key})
      : super(key: key);
  final Map color;
  final DashboardTargetModel data;
  final DsrModel dsr;
  final List<SRDetailTargetModel> targetList;

  @override
  TargetNAchievementUIState createState() => TargetNAchievementUIState();
}

class TargetNAchievementUIState extends ConsumerState<TargetNAchievementUITsm> {
  GlobalWidgets globalWidgets = GlobalWidgets();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2.h, left: 4.w, right: 4.w),
      width: 100.w,
      decoration: BoxDecoration(
        border: Border.all(color: primary),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment(2.0, 1.5),
          stops: [0.0, 1.0],
          colors: [Colors.white, Colors.white],
        ),
        // color: Colors.white,
        borderRadius: BorderRadius.circular(5.sp),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // globalWidgets.setHeadings("Targets and Achievements",),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LangText(
                          '${widget.dsr.fullname ?? '-'} (${(widget.dsr.username ?? '-')})',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: mediumFontSize,
                            color: primary,
                          ),
                        ),
                        // LangText(
                        //   " (${widget.module.name})",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: mediumFontSize,
                        //       color: Colors.white
                        //   ),
                        // ),
                      ],
                    ),
                    LangText(
                      widget.dsr.contactNo ?? '_',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // AssetService(context).superImage("target_warning.png", folder: 'asset', version: SyncReadService().getAssetVersion('asset'), height: 50.sp)
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          targetWidget(widget.data),
          SizedBox(
            width: 100.w,
            // height: 5.h,
            child: Center(
              child: TextButton(
                onPressed: () async {
                  // DashboardController(context: context, ref: ref).refreshTargetProviders(widget.module.id);
                  Navigator.pushNamed(context, TargetTabViewUITsm.routeName,
                      arguments: widget.targetList);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LangText(
                      "Details", //
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: primary,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      " >>",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  double? getAchievements(DashboardTargetModel targetModel) {
    switch (targetModel.label) {
      // case "Strike Rate":
      //   strikeRate = widget.data.strikeRate?.toDouble() ?? 0.0;
      //   return widget.data.strikeRate?.toDouble() ?? 0.0;
      // case "Pre-order":
      //   return widget.data.preorderStrikeRate?.toDouble() ?? 0.0;
      case "STT":
        sttTotalAchievements = targetModel.current;
        return targetModel.current;
      case "Geo Fencing":
        geoFencingTotalAchievements = targetModel.current;
        return targetModel.current;
      case "BCP":
        return targetModel.current;
      // case "Total STT":
      //   return widget.data.stt?.toDouble();
      // return targetModel.current;
      // default:
      //   return 0.0;
    }
  }

  Widget targetWidget(DashboardTargetModel targetModel) {
    // print(targetModel.label);
    // print(targetModel.current);
    // print(targetModel.minimumTarget);
    targetModel.current = getAchievements(targetModel) ?? 0.0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(tabAchievementRateProvider(targetModel.label).notifier).state = targetModel.current;
      ref.read(tabTargetRateProvider(targetModel.label).notifier).state = targetModel.minimumTarget;
    });

    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: SizedBox(
        width: 100.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // globalWidgets.setHeadings("STT"),
            Align(
              alignment: Alignment.centerLeft,
              child: LangText(
                targetModel.label == 'STT' ? 'STT' : targetModel.label,
                style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold, color: primary),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),

            Consumer(
              builder: (context, ref, _) {
                // double current = targetModel.current == 0? ref.watch(dashboardCurrentTargetRate("${targetModel.label}_${widget.data.module.id}")) : targetModel.current.toDouble();
                print("target current ${targetModel.label}");
                double current = targetModel.current;
                double minimumTarget = targetModel.minimumTarget;
                if (targetModel.label == "Total STT") {
                  current = targetModel.minimumTarget != 0
                      ? (targetModel.current * 100 / targetModel.minimumTarget)
                      : 0;
                  minimumTarget = 100;
                }
                Color color = DashboardController(context: context, ref: ref)
                    .getTargetColor(achievement: current, minimumTarget: minimumTarget);

                return Container(
                  height: 2.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.sp), color: Colors.grey[200]),
                  child: Stack(
                    children: [
                      Container(
                        height: 2.h,
                        width: ((100.w) - 6.w) * (current / 100),
                        // width: ((100.w) - 6.w) * (targetModel.current / 100),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.sp),
                          color: color,
                          // gradient: LinearGradient(
                          //   begin: Alignment.bottomRight,
                          //   end: Alignment.topRight,
                          //   colors: current >= targetModel.minimumTarget? [darkGreen, green] : [red, lightRed],
                          // ),
                        ),
                        child: Visibility(
                          visible: current > 15,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  LangText(
                                    current.toStringAsFixed(0),
                                    isNumber: true,
                                    isNum: false,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: smallFontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  LangText(
                                    "%",
                                    isNumber: true,
                                    isNum: false,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: smallFontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      current <= 15
                          ? Positioned(
                              left: double.parse(current.toString()).w,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.w),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LangText(
                                      current.toStringAsFixed(0),
                                      // "${targetModel.current}%",
                                      isNumber: true,
                                      isNum: false,
                                      style: TextStyle(
                                          color: color,
                                          fontSize: smallFontSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    LangText(
                                      "%",
                                      style: TextStyle(
                                        color: color,
                                        fontSize: smallFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
