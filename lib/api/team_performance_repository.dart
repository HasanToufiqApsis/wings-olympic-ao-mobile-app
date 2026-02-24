import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/enum.dart';
import '../models/dsr_model.dart';
import '../models/returned_data_model.dart';
import '../services/sync_read_service.dart';
import 'global_http.dart';
import 'links.dart';

class TeamPerformanceRepository {
  final _syncReadService = SyncReadService();
  Future<ReturnedDataModel> getDsrWisePerformanceData() async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try {
      final saleDate = await _syncReadService.getSalesDate();
      final srInfo = await _syncReadService.getSrInfo();
      final sbuIds =  (jsonDecode(srInfo.sbuId) as List).join(",");
      // final ffIds = dsrList.map((e) => e.id).join(',');

      returnedDataModel = await GlobalHttp(
        uri: Links.baseUrl+Links.getTeamPerformanceUrl(depIds: srInfo.depIds ?? '', date: saleDate, sbuIds: sbuIds),
        httpType: HttpType.get,
        refreshToken: srInfo.refreshToken,
        accessToken: srInfo.accessToken,
      ).fetch();
      log("team performance data: ${returnedDataModel.status} ${returnedDataModel.data}");
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    return returnedDataModel;
  }
}
