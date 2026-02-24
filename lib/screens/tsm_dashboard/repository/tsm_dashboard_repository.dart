import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';

import '../../../api/global_http.dart';
import '../../../api/links.dart';
import '../../../constants/enum.dart';
import '../../../services/sync_read_service.dart';
import '../models/cpr_radt_cpc.dart';
import '../models/mandatory_focussed.dart';
import '../models/target_vs_achivement.dart';
import '../models/total_and_target_outlet.dart';
import '../models/visited_and_no_order_outlet.dart';

class TsmDashboardRepository {
  final _syncReadService = SyncReadService();

  Future<VisitedAndNoOrderOutlet> getVisitedAndNoOrderOutletData() async {
    try {
      final srInfo = await _syncReadService.getSrInfo();
      final salesDate = await _syncReadService.getSalesDate();
      final url = Links.baseUrl + Links.tsmDashVisitedAndNoOrderOutletUrl(
            srInfo.depIds ?? '',
            salesDate,
            salesDate,
          );

      final returned = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
      ).fetch();

      if (returned.status == ReturnedStatus.success) {
        return VisitedAndNoOrderOutlet.fromJson(returned.data['data']);
      }

    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return VisitedAndNoOrderOutlet(noOrderOutlet: '0', visitedOutlet: '0');
  }

  Future<TotalAndTargetOutlet> getTotalAndTargetOutletData() async {
    try {
      final srInfo = await _syncReadService.getSrInfo();
      final salesDate = await _syncReadService.getSalesDate();
      final url = Links.baseUrl + Links.tsmDashTotalAndTargetOutletUrl;
      final load = {
        "point": srInfo.depIds ?? '',
        "start_date": salesDate,
        "end_date": salesDate,
        "sbu_id": (jsonDecode(srInfo.sbuId) as List).join(","),
      };

      final returned = await GlobalHttp(
        uri: url,
        httpType: HttpType.post,
        body: jsonEncode(load),
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
      ).fetch();

      if (returned.status == ReturnedStatus.success) {
        log('data => ${returned.data['data']}');
        return TotalAndTargetOutlet.fromJson(returned.data['data']);
      }

    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return TotalAndTargetOutlet(
      coolerOutlet: '0',
      target: '0',
      totalOutlet: '0',
      visited: '0',
    );
  }

  Future<TargetVsAchievement> getTargetVsAchievementData() async {
    try {
      final srInfo = await _syncReadService.getSrInfo();
      final salesDate = await _syncReadService.getSalesDate();
      final url = Links.baseUrl + Links.tsmDashTargetVsAchievementUrl(
        srInfo.depIds ?? '',
        salesDate,
        salesDate,
      );

      final returned = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
      ).fetch();

      if (returned.status == ReturnedStatus.success) {
        return TargetVsAchievement.fromJson(returned.data['data']);
      }

    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return TargetVsAchievement();
  }

  Future<CprRadtCpc> getCprRadtCpcData() async {
    try {
      final srInfo = await _syncReadService.getSrInfo();
      final salesDate = await _syncReadService.getSalesDate();
      final url = Links.baseUrl + Links.cprRadtCpcUrl(
        srInfo.depIds ?? '',
        salesDate,
        salesDate,
      );

      final returned = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
      ).fetch();

      if (returned.status == ReturnedStatus.success) {
        return CprRadtCpc.fromJson(returned.data['data']);
      }

    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return CprRadtCpc();
  }

  Future<List<MandatoryFocussed>> getMandatoryAndFocussedData() async {
    final resultList = <MandatoryFocussed>[];

    try {
      final srInfo = await _syncReadService.getSrInfo();
      final salesDate = await _syncReadService.getSalesDate();
      final url = Links.baseUrl + Links.mandatoryAndFocussedUrl(
        srInfo.depIds ?? '',
        salesDate,
        (jsonDecode(srInfo.sbuId) as List).join(","),
      );

      final returned = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
      ).fetch();

      if (returned.status == ReturnedStatus.success) {
        final dataList = returned.data['data']['skuSummary'];
        for (var json in dataList) {
          resultList.add(MandatoryFocussed.fromJson(json));
        }
      }

    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return resultList;
  }
}
