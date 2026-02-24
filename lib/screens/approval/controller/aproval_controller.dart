import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/tsm_api.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/leave_movement_management_model_tsm.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/route_change_model_tsm.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';

class ApprovalController {
  BuildContext context;
  WidgetRef ref;
  late Alerts alerts;
  ApprovalController({required this.context, required this.ref}):alerts = Alerts(context: context);

  submitOrRejectChangeRouteRequest(ChangeRouteTSMModel changeRouteTSMModel, int status)async{
    alerts.floatingLoading();
    ReturnedDataModel returnedDataModel = await TSMAPI().submitApproveOrRejectChangeRouteRequest(changeRouteTSMModel, status);
    navigatorKey.currentState?.pop();
    if(returnedDataModel.status == ReturnedStatus.success){
      alerts.customDialog(type: AlertType.success, description: "Your submission is successfully done",
          onTap1: (){
            ref.refresh(getSrChangeRouteListForTSMProvider);
            navigatorKey.currentState?.pop();
            navigatorKey.currentState?.pop();
          }
      );
    }
    else {
      alerts.customDialog(type: AlertType.warning, description: returnedDataModel.errorMessage,
      );
    }
  }
  submitOrRejectLeaveMovementRequest(LeaveMovementManagementModelForTSM leaveMovementManagementModelForTSM, String type, int status, [String? tada])async{
    alerts.floatingLoading();
    ReturnedDataModel returnedDataModel = await TSMAPI().submitApproveOrRejectLeaveMovementRequest(leaveMovementManagementModelForTSM, type, status, tada);
    navigatorKey.currentState?.pop();
    if(returnedDataModel.status == ReturnedStatus.success){
      alerts.customDialog(type: AlertType.success, description: "Your submission is successfully done",
          onTap1: (){
        ref.refresh(getSrLeaveMovementListForTSMProvider);
            navigatorKey.currentState?.pop();
            navigatorKey.currentState?.pop();
          }
      );
    }
    else {
      alerts.customDialog(type: AlertType.warning, description: returnedDataModel.errorMessage,
      );
    }
  }

  String statusCheck(int statusKey){
    String status = "Pending";
    if(statusKey == 1){
      status = "Approved";
    }
    else if(statusKey == 2){
      status = "Rejected";
    }
    return status;
  }
  Color setStatusColor(int statusKey){
    Color color = yellow;
    if(statusKey == 1){
      color = primary;
    }
    else if(statusKey == 2){
      color = primaryRed;
    }
    return color;
  }
}