import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/change_route_service.dart';
import '../../../services/geo_location_service.dart';
import '../../../services/langugae_pack_service.dart';
import 'approval_list.dart';
import 'leave_list.dart';

class ApprovalDashboardScreen extends ConsumerStatefulWidget {
  static const routeName = "/approval_dashboard";
  const ApprovalDashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ApprovalDashboardScreen> createState() => _ApprovalDashboardScreenState();
}

class _ApprovalDashboardScreenState extends ConsumerState<ApprovalDashboardScreen> {

  final _appBarTitle = DashboardBtnNames.approval;

  @override
  void initState() {
    super.initState();
    LocationService(context).initialize();
    // InternetPopup().initialize(
    //     context: context,
    //     onTapPop: true,
    //     onChange: (value) {
    //       ref.read(internetConnectivityProvider.state).state = value;
    //       if (value) {
    //         readLang();
    //       }
    //     });

  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<SrInfoModel? > asyncSrInfo = ref.watch(userDataProvider);
    return asyncSrInfo.when(
        data: (srInfo){
          return Scaffold(
            // backgroundColor: Colors.white,
            appBar:  CustomAppBar(
                title: _appBarTitle,
                titleImage: "tsm.png",
                onLeadingIconPressed: () {
                  Navigator.pop(context);
                },
              heroTagTitle: _appBarTitle,
              heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
            ),
            body: Column(
              children: [
                Container(
                  width: 100.w,
                  padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(appBarRadius), bottomRight: Radius.circular(appBarRadius)),
                  ),
                  child: Wrap(
                    // mainAxisSize: MainAxisSize.min,
                    children: [

                      getDashboardButton(assetName:"tsm",name: "Approval",onPressed: (){
                        Navigator.pushNamed(context, ApprovalList.routeName);
                      }),

                      getDashboardButton(assetName:"leave_management",name: "Leave & Movement Approval",onPressed: (){
                        Navigator.pushNamed(context, LeaveList.routeName);
                      }),
                      // getDashboardButton(assetName:"leave_management",name: "Movement \nApproval",onPressed: (){
                      //   Navigator.pushNamed(context, MovementList.routeName);
                      // }),

                    ],
                  ),
                ),

              ],
            ),
          );
        },
        error: (error, _) {
          print(error);
          return Container();
        },
        loading: ()=>Center(child: CircularProgressIndicator(),)
    );

  }
  Widget getDashboardButton({required String assetName, required String name, required VoidCallback onPressed}){
    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap:()async{
            bool enabled = await ChangeRouteService().checkIfBreakdownEnabled();
            if(!enabled){
              onPressed();
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Container(
              height: 10.h,
              width: 18.w,
              decoration: BoxDecoration(
                color: secondaryBlue,
                border: Border.all(color: secondaryBlue, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(5.sp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.h),
                  child: Image.asset("assets/${assetName}.png")
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
          child: SizedBox(
            width: 18.w,
            child: Center(
              child: LangText(
                name,
                style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold, color: primaryBlue),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
  readLang() async {
    await LanguagePackService().readLang();
  }
}
