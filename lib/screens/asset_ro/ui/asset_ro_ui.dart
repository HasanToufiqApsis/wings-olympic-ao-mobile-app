import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/sync_global.dart';
import '../../../models/asset_requisition_model.dart';
import '../../../models/previous_requisition.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/asset_ro_controller.dart';
import 'asset_ro_requisition_ui.dart';

class AssetRoUI extends ConsumerStatefulWidget {
  const AssetRoUI({Key? key}) : super(key: key);
  static const routeName = "/asset_ro_ui";

  @override
  ConsumerState<AssetRoUI> createState() => _AssetRoUIState();
}

class _AssetRoUIState extends ConsumerState<AssetRoUI> {
  final _appBarTitle = DashboardBtnNames.asset;
  late AssetRoController assetController;

  @override
  void initState() {
    super.initState();
    assetController = AssetRoController(context: context, ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: _appBarTitle,
          titleImage: "asset.png",
          onLeadingIconPressed: () {
            Navigator.pop(context);
          },
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 2.h, left: 4.w, right: 4.w, top: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: LangText(
                    'Outdoor Asset Requisition',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 45.w,
                  child: SubmitButtonGroup(
                    button1Label: "New Requisition",
                    onButton1Pressed: () {
                      Navigator.pushNamed(context, AssetRoRequisitionUI.routeName);
                    },
                  ),
                )
              ],
            ),
            2.h.verticalSpacing,
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp), topLeft: Radius.circular(5.sp)),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [primary, primaryBlue],
                  ),
                  color: Colors.grey[100]),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: normalFontSize, color: Colors.white, fontWeight: FontWeight.bold),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: LangText(
                          'Date',
                          style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: LangText(
                            'Route',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: LangText(
                          'Outlet name',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: LangText(
                          'Status',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              color: Colors.white,
              child: Consumer(builder: (context, ref, _) {
                String depIds = '';
                if (syncObj.containsKey('userData')) {
                  if (syncObj['userData'].containsKey('dep_ids')) {
                    depIds = syncObj['userData']['dep_ids'];
                  }
                }
                AsyncValue<List<PreviousRequisition>> asyncAssetRequisitionList = ref.watch(getRoRequisitionProvider(depIds));

                return asyncAssetRequisitionList.when(
                    data: (requisitionList) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: requisitionList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var requisition = requisitionList[index];
                          return ListTile(
                            onTap: () {
                              if(requisition.assetStatus == 0) {
                                Navigator.pushNamed(
                                context,
                                AssetRoRequisitionUI.routeName,
                                arguments: requisition,
                              );
                              }
                            },
                            contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    requisitionDateTimeFormat.format(requisition.assetDate ?? DateTime.now()),
                                    style: TextStyle(fontSize: standardFontSize),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      requisition.route ?? '',
                                      style: TextStyle(fontSize: standardFontSize),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    requisition.outletName ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: standardFontSize),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      requisition.assetStatus == 0
                                          ? 'Pending'
                                          : requisition.assetStatus == 1
                                              ? 'Approved'
                                              : 'Rejected',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: standardFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    error: (error, _) => Container(),
                    loading: () => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),);
              }),
            ),

            // Container(
            //   color: Colors.white,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemCount: 5,
            //     itemBuilder: (BuildContext context, int index) {
            //       return ListTile(
            //         onTap: () {},
            //         contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
            //         title: Row(
            //           children: [
            //             Expanded(
            //               flex: 2,
            //               child: Text(
            //                 '2023-05-17',
            //                 style: TextStyle(fontSize: normalFontSize),
            //               ),
            //             ),
            //             Expanded(
            //               flex: 2,
            //               child: Center(
            //                 child: Text(
            //                   'Bordeshi',
            //                   style: TextStyle(fontSize: normalFontSize),
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               flex: 2,
            //               child: Center(
            //                 child: Text(
            //                   'Mayer Doa',
            //                   style: TextStyle(fontSize: normalFontSize),
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               child: Align(
            //                 alignment: Alignment.centerRight,
            //                 child: Text(
            //                   'View',
            //                   style: TextStyle(
            //                     decoration: TextDecoration.underline,
            //                     fontSize: normalFontSize,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),

            // Container(
            //   color: Colors.white,
            //   child: Consumer(
            //       builder: (context,ref,_) {
            //         AsyncValue<List<LeaveMovementManagementModelForTSM>> asyncLeaveMovementList = ref.watch(getSrLeaveMovementListForTSMProvider);
            //         return asyncLeaveMovementList.when(
            //             data: (leaveMomentList){
            //               if(leaveMomentList.isEmpty){
            //                 return Center(
            //                   child: LangText(
            //                       "Nothing to show"
            //                   ),
            //                 );
            //               }
            //               return ListView.builder(
            //                   shrinkWrap: true,
            //                   primary: false,
            //                   itemCount: leaveMomentList.length,
            //                   itemBuilder: (context, index1) {
            //                     return Padding(
            //                       padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           Expanded(
            //                             child: LangText(
            //                               leaveMomentList[index1].rowType,
            //                               style: TextStyle(fontSize: smallFontSize, color: grey),
            //                               // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
            //                             ),
            //                           ),
            //                           Expanded(
            //                             child: LangText(
            //                               leaveMomentList[index1].fieldForceName,
            //                               style: TextStyle(fontSize: smallFontSize, color: grey),
            //                               // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
            //                             ),
            //                           ),
            //                           Expanded(
            //                             child: LangText(
            //                               "${uiDateFormat.format(leaveMomentList[index1].startDate)} - ${uiDateFormat.format(leaveMomentList[index1].endDate)}",
            //                               textAlign: TextAlign.center,
            //                               style: TextStyle(fontSize: smallFontSize, color: grey),
            //                               // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
            //                             ),
            //                           ),
            //                           Expanded(
            //                             child: LangText(
            //                               leaveMomentList[index1].totalDays.toString(),
            //                               textAlign: TextAlign.center,
            //                               style: TextStyle(fontSize: smallFontSize, color: grey),
            //                               // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
            //                             ),
            //                           ),
            //                           Expanded(
            //                             child: InkWell(
            //                               onTap: () {
            //                                 if(leaveMomentList[index1].rowType == "Leave"){
            //                                   Navigator.pushNamed(context, SingleLeave.routeName, arguments: leaveMomentList[index1]);
            //                                 }
            //                                 else{
            //                                   Navigator.pushNamed(context, SingleMovement.routeName, arguments: leaveMomentList[index1]);
            //                                 }
            //                               },
            //                               child: LangText(
            //                                 'view',
            //                                 isNumber: true,
            //                                 textAlign: TextAlign.end,
            //                                 style: TextStyle(fontSize: smallFontSize, color: grey),
            //                               ),
            //                             ),
            //                           )
            //                         ],
            //                       ),
            //                     );
            //                   });
            //             },
            //             error: (error, _)=> Container(),
            //             loading: ()=> const Center(child: CircularProgressIndicator(),)
            //         );
            //
            //       }
            //   ),
            // ),
            Container(
              width: 100.w,
              height: 3.h,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)),
                gradient: const LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [primary, primaryBlue],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
