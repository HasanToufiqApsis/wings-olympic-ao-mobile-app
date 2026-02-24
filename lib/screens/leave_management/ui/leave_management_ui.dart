import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';

import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../calender/ui/leave_calender_ui.dart';
import '../controller/leave_controller.dart';
import 'leave_ui.dart';

class LeaveManagementUI extends ConsumerStatefulWidget {
  const LeaveManagementUI({Key? key}) : super(key: key);
  static const routeName = "leave_management_ui";
  @override
  ConsumerState<LeaveManagementUI> createState() => _LeaveManagementUIState();
}

class _LeaveManagementUIState extends ConsumerState<LeaveManagementUI> {
  final _appBarTitle = DashboardBtnNames.leaveManagement;
  late LeaveController leaveController;

  @override
  void initState() {
    super.initState();
    leaveController = LeaveController(context: context, ref: ref);

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
        titleImage: "leave_management.png",
        showLeading: true,
        centerTitle: true,
        onLeadingIconPressed: (){
          leaveController.refreshState();
          navigatorKey.currentState?.pop();
        },
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
        actions: [
          // InkResponse(
          //   onTap: () {
          //     navigatorKey.currentState?.pushNamed(LeaveCalenderUi.routeName);
          //   },
          //   child: const Icon(Icons.calendar_month_outlined, color: Colors.white,),
          // ),
          const SizedBox(width: 18),
        ],
      ),
      body: Consumer(
          builder: (context,ref,_){
            bool internet = ref.watch(internetConnectivityProvider);
            LeaveManagementType leaveManagementType = ref.watch(selectedLeaveManagementTypeProvider);
            if(!internet){
              return Column(
                children: [
                  Image.asset("assets/no_internet.png"),
                  LangText("No internet"),
                ],
              );
            }
            return const LeaveUI();
          }
      ),
    );
  }

}
