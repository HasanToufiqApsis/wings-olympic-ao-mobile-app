import 'dart:convert';

import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../models/leave_movement_management_model_tsm.dart';
import '../models/returned_data_model.dart';
import '../models/route_change_model_tsm.dart';
import '../models/sr_info_model.dart';
import '../services/helper.dart';
import '../services/sync_read_service.dart';
import 'global_http.dart';
import 'links.dart';

class TSMAPI {
  Future<List<ChangeRouteTSMModel>> getTSMChangeRouteList()async{
    List<ChangeRouteTSMModel> list = [];
    try {
      SrInfoModel sr = await SyncReadService().getSrInfo();
      ReturnedDataModel returnedDataModel = await GlobalHttp(uri: "${Links.baseUrl}${Links.getRouteChangeRequestTSMUrl}?depIds=${sr.depId}&date=${apiDateFormat.format(DateTime.now())}", httpType: HttpType.get, accessToken: sr.accessToken, refreshToken: sr.refreshToken).fetch();
      if(returnedDataModel.status == ReturnedStatus.success){ // ${apiDateFormat.format(DateTime.now())}
        if(returnedDataModel.data.containsKey("data")){
          for(Map assetMap in returnedDataModel.data["data"]){
            list.add(ChangeRouteTSMModel.fromJson(assetMap));
          }
        }
      }
    }
    catch(e,s){
      Helper.dPrint("inside TSMAPI getTSMChangeRouteList $e $s");
    }
    return list;
  }

  Future<ReturnedDataModel> submitApproveOrRejectChangeRouteRequest(ChangeRouteTSMModel changeRouteTSMModel, int status)async{
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try{
      SrInfoModel sr = await SyncReadService().getSrInfo();
      Map payload = {
        "change_request_id":changeRouteTSMModel.changeRequestId,
        "status":status
      };
      returnedDataModel = await GlobalHttp(uri: "${Links.baseUrl}${Links.getRouteChangeRequestTSMUrl}", httpType: HttpType.patch, body: jsonEncode(payload), accessToken: sr.accessToken, refreshToken: sr.refreshToken).fetch();

    }
    catch(e,s){
      Helper.dPrint("inside TSMAPI submitApproveOrRejectChangeRouteRequest $e $s");
    }
    return returnedDataModel;
  }

  Future<List<LeaveMovementManagementModelForTSM>> getTSMLeaveMovementReqList()async{
    List<LeaveMovementManagementModelForTSM> list = [];
    try {
      SrInfoModel sr = await SyncReadService().getSrInfo();
      String salesDate = await SyncReadService().getSalesDate();
      ReturnedDataModel returnedDataModel = await GlobalHttp(uri: "${Links.baseUrl}${Links.getLeaveMovementRequestTSMUrl(depIds: sr.depIds??'', startDate: salesDate, endDate: salesDate)}", httpType: HttpType.get, accessToken: sr.accessToken, refreshToken: sr.refreshToken).fetch();
      if(returnedDataModel.status == ReturnedStatus.success){ // ${apiDateFormat.format(DateTime.now())}
        if(returnedDataModel.data.containsKey("data")){
          for(Map assetMap in returnedDataModel.data["data"]){
            list.add(LeaveMovementManagementModelForTSM.fromJson(assetMap));
          }
        }
      }
    }
    catch(e,s){
      Helper.dPrint("inside TSMAPI getTSMLeaveMovementReqList $e $s");
    }
    return list;
  }
  Future<ReturnedDataModel> submitApproveOrRejectLeaveMovementRequest(LeaveMovementManagementModelForTSM leaveMovementManagementModelForTSM,String actionType, int status, [String? tada])async{
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try{
      SrInfoModel sr = await SyncReadService().getSrInfo();
      Map payload = {
        "status":status
      };
      if(tada != null){
        payload["ta_da"] = int.parse(tada);
      }
      print(payload);
      returnedDataModel = await GlobalHttp(uri: "${Links.baseUrl}${Links.approveRejectTSMUrl}/$actionType/${leaveMovementManagementModelForTSM.id}", httpType: HttpType.patch, body: jsonEncode(payload), accessToken: sr.accessToken, refreshToken: sr.refreshToken).fetch();

    }
    catch(e,s){
      Helper.dPrint("inside TSMAPI submitApproveOrRejectChangeRouteRequest $e $s");
    }
    return returnedDataModel;
  }
}