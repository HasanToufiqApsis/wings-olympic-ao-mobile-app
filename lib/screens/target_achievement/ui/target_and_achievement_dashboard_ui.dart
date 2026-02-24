import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_keys.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/sync_global.dart';
import '../../../models/module.dart';
import '../../../models/target/dashboard_target_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../controller/dashboard_controller.dart';
import 'target_tab_view_ui.dart';


class TargetNAchievementUI extends ConsumerStatefulWidget {
  const TargetNAchievementUI({required this.color, required this.module ,Key? key}) : super(key: key); //  required DashboardModuleDataModel this.data
  final Map color;
  final Module module;
  // final DashboardModuleDataModel data;
  @override
  _TargetNAchievementUIState createState() => _TargetNAchievementUIState();
}

class _TargetNAchievementUIState extends ConsumerState<TargetNAchievementUI> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  @override
  Widget build(BuildContext context) {

    return  Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.all(Radius.circular(16)),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LangText(
                      "Target And Achievement",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: mediumFontSize,
                          color: Colors.white
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
              ),
              // AssetService(context).superImage("target_warning.png", folder: 'asset', version: SyncReadService().getAssetVersion('asset'), height: 50.sp)
            ],
          ),


          SizedBox(height: 1.h,),
          Consumer(builder: (context, ref,_){
            AsyncValue<List<DashboardTargetModel>> asyncTargetList = ref.watch(dashboardTargetList(widget.module.id));
            return asyncTargetList.when(
                data: (targetData){
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: targetData.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        return targetWidget(targetData[index]);
                      }
                  );
                },
                error: (error, _)=>Container(),
                loading: ()=>Container()
            );
          }),

          SizedBox(
            width: 100.w,
            // height: 5.h,
            child: Center(
              child: TextButton(
                onPressed: ()async{
                  DashboardController(context: context, ref: ref).refreshTargetProviders(widget.module.id);
                  Navigator.pushNamed(context, TargetTabViewUI.routeName, arguments: {"data": widget.module});
                  print(syncObj[srAchievementKey]);
                },
                child: LangText(
                  "Details", //
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

  }

  double? getAchievements(DashboardTargetModel targetModel){

    switch(targetModel.label){
      // case "Strike Rate":
      //   // strikeRate =  widget.data.strikeRate?.toDouble()??0.0;
      //   return widget.data.strikeRate?.toDouble()??0.0;
      // case "Pre-order":
      //   return widget.data.preorderStrikeRate?.toDouble()??0.0;
      case "STT":
        // sttTotalAchievements = targetModel.current;
        return targetModel.current;
      case "Special Target":
      // sttTotalAchievements = targetModel.current;
        return targetModel.current;
      case "Geo Fencing" :
        // geoFencingTotalAchievements = targetModel.current;
        return targetModel.current;
      case "BCP" :
        return targetModel.current;
      // default:
      //   return 0.0;
    }
  }

  Widget targetWidget(DashboardTargetModel targetModel){
    // print(targetModel.label);
    // print(targetModel.current);
    // print(targetModel.minimumTarget);

    targetModel.current = getAchievements(targetModel)??0.0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(tabAchievementRateProvider(targetModel.label).state).state = targetModel.current;
      ref.read(tabTargetRateProvider(targetModel.label).state).state = targetModel.minimumTarget;
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
                targetModel.label,
                style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),

            Consumer(
              builder: (context,ref,_) {
                double current = targetModel.current;
                // double current = targetModel.current == 0? ref.watch(dashboardCurrentTargetRate("${targetModel.label}_${widget.data.module.id}")) : targetModel.current.toDouble();
                print("target current ${targetModel.label}");
                print(current);
                Color color = DashboardController(context: context, ref: ref).getTargetColor(achievement: current, minimumTarget: targetModel.minimumTarget);

                return Container(
                  height: 2.h,
                  width: 100.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey[200]),
                  child: Stack(
                    children: [
                      Container(
                        height: 2.h,
                        width: ((100.w) - 6.w) * (current/ 100),
                        // width: ((100.w) - 6.w) * (targetModel.current / 100),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
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
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  LangText(
                                    "%",
                                    isNumber: true,
                                    isNum: false,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: smallFontSize,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      targetModel.current <= 15?
                      Positioned(
                        left: double.parse(targetModel.current.toString()).w,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LangText(
                                targetModel.current.toStringAsFixed(0),
                                // "${targetModel.current}%",
                                isNumber: true,
                                isNum: false,
                                style: TextStyle(
                                    color: color,
                                    fontSize: smallFontSize,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              LangText(
                                "%",
                                style: TextStyle(
                                  color: color,
                                  fontSize: smallFontSize,
                                  fontWeight: FontWeight.bold
                              ),)
                            ],
                          ),
                        ),
                      )
                          :
                      Container()

                    ],
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
