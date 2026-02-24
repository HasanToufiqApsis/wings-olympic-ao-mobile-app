import 'dart:convert';

import '../constants/enum.dart';
import '../models/bill/bill_data_model.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import '../services/helper.dart';
import '../services/sync_read_service.dart';
import 'global_http.dart';
import 'links.dart';

class BillAPI {
  Future<ReturnedDataModel> billDisburseAPI(int id)async{
    SrInfoModel sr = await SyncReadService().getSrInfo();
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try{
      returnedDataModel = await GlobalHttp(uri: "${Links.baseUrl}${Links.billDisburse(id)}", httpType: HttpType.patchWithoutFile, accessToken: sr.accessToken, refreshToken: sr.refreshToken).fetch();
    }
    catch(e,s){
      Helper.dPrint("inside AssetManagementAPI submitAssetRequisitionAPI $e $s");
    }
    return returnedDataModel;
  }

  Future<List<BillDataModel>> billListAPI()async{
    SrInfoModel sr = await SyncReadService().getSrInfo();
    List<BillDataModel> list= [];
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try{
      returnedDataModel = await GlobalHttp(uri: "${Links.baseUrl}${Links.billListUrl(sr.depIds.toString())}", httpType: HttpType.get, accessToken: sr.accessToken,
          refreshToken: sr
          .refreshToken)
          .fetch();

      if(returnedDataModel.status == ReturnedStatus.success){
        if(returnedDataModel.data.containsKey("data")){
          for(Map<String, dynamic> assetMap in returnedDataModel.data["data"]){
            list.add(BillDataModel.fromJson(assetMap));
          }
        }
      }
    }
    catch(e,s){
      Helper.dPrint("inside AssetManagementAPI submitAssetRequisitionAPI $e $s");
    }
    return list;
  }
}