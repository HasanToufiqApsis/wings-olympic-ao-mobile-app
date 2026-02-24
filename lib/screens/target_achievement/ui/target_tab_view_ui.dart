import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/module.dart';
import '../../../models/target/sr_stt_target_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/dashboard_controller.dart';
import 'bcp_tab.dart';
import 'target_achievement_tab.dart';

class TargetTabViewUI extends StatefulWidget {
  const TargetTabViewUI({required this.module,Key? key}) : super(key: key);
  final Module module;
  static const routeName = "/target_ui";
  @override
  _TargetTabViewUIState createState() => _TargetTabViewUIState();
}

class _TargetTabViewUIState extends State<TargetTabViewUI> with TickerProviderStateMixin {
  late TabController tabController;
  GlobalWidgets globalWidgets = GlobalWidgets();
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Target And Achievement",
          titleImage: "summary.png",
          onLeadingIconPressed: () {
            // ref.read(selectedQCInfoListProvider.state).state = [];
            Navigator.pop(context);
          }
      ),

      body: Consumer(
        builder: (context,ref,_) {
          AsyncValue<List> asyncTargetList = ref.watch(targetDetailTabList(widget.module.id));
          return asyncTargetList.when(
              data: (tabList){
                tabController = TabController(length: tabList.length, vsync: this);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: primary.withOpacity(0.2), width: 1.w)
                            )
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TabBar(
                              controller: tabController,
                              isScrollable: true,
                              labelStyle: TextStyle(color: red3),
                              labelColor: Colors.white,
                              indicatorWeight: 0,
                              unselectedLabelColor: grey,
                              indicator: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [red3,red3],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5.sp), topRight: Radius.circular(5.sp))),

                              /// ========= tabs ============
                              tabs: getTabList(tabList)
                            // [
                            //   Padding(
                            //     padding: EdgeInsets.all(5.sp),
                            //     child: LangText(
                            //       "STT",
                            //     ),
                            //   ),
                            //   // Padding(
                            //   //   padding: EdgeInsets.all(5.sp),
                            //   //   child: LangText(
                            //   //     "Memo",
                            //   //   ),
                            //   // ),
                            //   // Padding(
                            //   //   padding: EdgeInsets.all(5.sp),
                            //   //   child: LangText(
                            //   //     "BCP",
                            //   //   ),
                            //   // ),
                            // ]
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: getTabViewUI(widget.module.id, tabList)
                            // [
                            //   Consumer(
                            //       builder: (context,ref,_) {
                            //         AsyncValue<List<SRDetailTargetModel>> asyncSttList = ref.watch(sttByTypeProvider(widget.data.module.id));
                            //         return asyncSttList.when(
                            //             data: (sttList){
                            //               return  ListView.builder(
                            //                   itemCount: sttList.length,
                            //                   itemBuilder: (context, index){
                            //                     return TargetAchievementTabUI(sttData: sttList[index],);
                            //                   }
                            //               );
                            //             },
                            //             error: (error, _)=>Container(),
                            //             loading: ()=>CircularProgressIndicator()
                            //         );
                            //
                            //       }
                            //   ),
                            //
                            //   Center(
                            //     child: LangText(
                            //       "Memo",
                            //     ),
                            //   ),
                            //   Center(
                            //     child: LangText(
                            //       "BCP",
                            //     ),
                            //   ),
                            //   Center(
                            //     child: LangText(
                            //       "BCP",
                            //     ),
                            //   ),
                            // ],
                          )
                      )
                    ],
                  ),
                );
              },
              error: (error, _)=> Container(),
              loading: ()=> const CircularProgressIndicator()
          );

        }
      ),
    );
  }

  List<Widget> getTabList(List tabTitleList){
    List<Widget> list = [];
    for(String tab in tabTitleList){
      list.add(
          Padding(
            padding: EdgeInsets.all(5.sp),
            child: LangText(
              tab,
            ),
          )
      );
    }
    return list;
  }

  List<Widget> getTabViewUI(int moduleId,List tabTitleList){
    List<Widget> tabViewList = [];
    for(String tabView in tabTitleList){
      Map<String, String> mapData = {
        "moduleId": moduleId.toString(),
        "label": tabView.toString()
      };
      tabViewList.add(
        Consumer(
            builder: (context, ref, _){
              AsyncValue<String> asyncType = ref.watch(tabTypeProvider(mapData));
              return asyncType.when(
                  data: (type){
                    if(type.isEmpty){
                      return Center(
                        child: LangText("Nothing to show"),
                      );
                    }
                    if(type == "double" || type == "int"){
                      return getRates(tabView);
                    }
                    else{
                      if(tabView == "STT"){
                        return getSTT();
                      }
                      else if(tabView == "Special Target"){
                        return getSpecialSTT();
                      }
                      else {
                        return getBCP();
                      }
                    }
                  },
                  error: (error, _)=>Container(),
                  loading: ()=>Container()
              );
            }
        )
      );
    }
    return tabViewList;
  }
  Widget getRates(String tabLabel){
    return Consumer(
        builder: (context, ref,_){
          double current = ref.watch(tabAchievementRateProvider(tabLabel));
          double target = ref.watch(tabTargetRateProvider(tabLabel));
          Color mainColor = DashboardController(context: context, ref: ref).getTargetColor(achievement: current, minimumTarget: target);
          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
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
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LangText("Target", style: TextStyle(fontSize: mediumFontSize, fontWeight: FontWeight.bold),),
                        LangText("${target.toStringAsFixed(0)}%", isNumber: true,style: TextStyle(fontSize: mediumFontSize, color: red3),)
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LangText("Achievement", style: TextStyle(fontSize: mediumFontSize, fontWeight: FontWeight.bold),),
                        LangText("${current.toStringAsFixed(0)}%", isNumber: true, style: TextStyle(fontSize: mediumFontSize,color: mainColor),)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
  Widget getSTT(){
    return Consumer(
        builder: (context,ref,_) {
          AsyncValue<List<SRDetailTargetModel>> asyncSttList = ref.watch(sttByTypeProvider(widget.module.id));
          return asyncSttList.when(
              data: (sttList){
                return  ListView.builder(
                    itemCount: sttList.length,
                    itemBuilder: (context, index){
                      return TargetAchievementTabUI(sttData: sttList[index],);
                    }
                );
              },
              error: (error, _)=>Container(),
              loading: ()=>CircularProgressIndicator()
          );

        }
    );
  }
  Widget getSpecialSTT(){
    return Consumer(
        builder: (context,ref,_) {
          AsyncValue<List<SRDetailTargetModel>> asyncSttList = ref.watch(specialSttByTypeProvider(widget.module.id));
          return asyncSttList.when(
              data: (sttList){
                return  ListView.builder(
                    itemCount: sttList.length,
                    itemBuilder: (context, index){
                      return TargetAchievementTabUI(sttData: sttList[index],);
                    }
                );
              },
              error: (error, _)=>Container(),
              loading: ()=>CircularProgressIndicator()
          );

        }
    );
  }
  Widget getBCP(){
    return Consumer(
        builder: (context,ref,_) {
          AsyncValue<List<SRDetailTargetModel>> asyncSttList = ref.watch(bcpByTypeProvider(widget.module.id));
          return asyncSttList.when(
              data: (sttList){
                return  ListView.builder(
                    itemCount: sttList.length,
                    itemBuilder: (context, index){
                      return BCPTargetAchievementTabUI(sttData: sttList[index],);
                    }
                );
              },
              error: (error, _)=>Container(),
              loading: ()=>CircularProgressIndicator()
          );

        }
    );
  }
}
