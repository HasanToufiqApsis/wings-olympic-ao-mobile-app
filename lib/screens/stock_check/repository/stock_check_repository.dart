import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../api/global_http.dart';
import '../../../api/links.dart';
import '../../../constants/enum.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../services/sync_read_service.dart';

class CheckStockRepository {

  Future<ReturnedDataModel> getUpdatedMaxLimitForPreorder() async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel? sr = await SyncReadService().getSrInfo();
      String url =
          "${Links.baseUrl}${Links.getMaxLimitForPreorder(
        sbuId: sr.sbuId.replaceAll('[', '').replaceAll(']', ''),
        depId: sr.depId ?? 0,
        routeId: sr.sectionId ?? 0,)}";
      returnedDataModel = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> submitStockImage({required Map payLoad}) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel? sr = await SyncReadService().getSrInfo();
      String url = "${Links.baseUrl}${Links.submitStockImage}";
      returnedDataModel = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
        body: jsonEncode(payLoad),
      ).fetch();
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return returnedDataModel;
  }
}
