import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/screens/allowance_management/ui/tada_ui.dart';

import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../calender/ui/leave_calender_ui.dart';
import '../controller/allowance_controller.dart';
import 'movement_ui.dart';

class AllowanceManagementUI extends ConsumerStatefulWidget {
  const AllowanceManagementUI({Key? key}) : super(key: key);
  static const routeName = "allowance_management_ui";
  @override
  ConsumerState<AllowanceManagementUI> createState() => _AllowanceManagementUIState();
}

class _AllowanceManagementUIState extends ConsumerState<AllowanceManagementUI> {
  final _appBarTitle = DashboardBtnNames.allowance;
  late AllowanceController leaveController;

  @override
  void initState() {
    super.initState();
    leaveController = AllowanceController(context: context, ref: ref);

  }

  @override
  void dispose() {
    super.dispose();
    leaveController.refreshState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _appBarTitle,
        titleImage: "allowance.png",
        showLeading: true,
        centerTitle: true,
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
        onLeadingIconPressed: (){
          leaveController.refreshState();
          navigatorKey.currentState?.pop();
        },
        actions: [
          InkResponse(
            onTap: () {
              navigatorKey.currentState?.pushNamed(LeaveCalenderUi.routeName);
            },
            child: const Icon(Icons.calendar_month_outlined, color: Colors.white,),
          ),
          const SizedBox(width: 18),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Consumer(
              builder: (context,ref,_) {
                LeaveManagementType leaveManagementType = ref.watch(selectedLeaveManagementTypeProvider);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                            value: LeaveManagementType.movement,
                            groupValue: leaveManagementType,
                            onChanged: (value){
                              leaveController.refreshState();
                              ref.read(selectedLeaveManagementTypeProvider.notifier).state = value!;
                            }
                        ),
                        LangText("Movement")
                      ],
                    ),
                    SizedBox(width: 2.w,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                            value: LeaveManagementType.tada,
                            groupValue: leaveManagementType,
                            onChanged: (value){
                              leaveController.refreshState();
                              ref.read(selectedLeaveManagementTypeProvider.notifier).state = value!;
                            }
                        ),
                        LangText("TA/DA")
                      ],
                    )
                  ],
                );
              }
            ),
          ),
          SizedBox(height: 0.h,),
          Expanded(
            child: Consumer(
                builder: (context,ref,_){
                  bool internet = ref.watch(internetConnectivityProvider);
                  LeaveManagementType leaveManagementType = ref.watch(selectedLeaveManagementTypeProvider);
                 ///TODO:: Need to change later
                  /*if(!internet){
                    return Column(
                      children: [
                        Image.asset("assets/no_internet.png"),
                        LangText("No internet"),
                      ],
                    );
                  }*/

                  if(leaveManagementType == LeaveManagementType.movement){
                    return const MovementUI();
                  }
                  else {
                    return const TaDaUI();
                  }
                }
            ),
          )
        ],
      ),
    );
  }

}
