import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../api/global_http.dart';
import '../../../api/links.dart';
import '../../../constants/enum.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../services/sync_read_service.dart';

class AwsService{
  final SyncReadService syncReadService = SyncReadService();

  Future<ReturnedDataModel> sendAwsStockDataToApi(List<Map> payload)async{
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try{
      SrInfoModel srInfo = await syncReadService.getSrInfo();
      returnedDataModel = await GlobalHttp(
          httpType: HttpType.post,
          uri: '${Links.baseUrl}${Links.awsStockUrl}',
          accessToken: srInfo.accessToken,
          refreshToken: srInfo.refreshToken,
          body: jsonEncode(payload))
          .fetch();
    }
    catch(e,s){
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return returnedDataModel;
  }
}