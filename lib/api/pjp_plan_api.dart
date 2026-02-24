import 'dart:convert';

import '../constants/enum.dart';
import '../models/asset_install_pull_out_get_model.dart';
import '../models/asset_requisition_model.dart';
import '../models/maintanence_model.dart';
import '../models/previous_requisition.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import '../services/ff_services.dart';
import '../services/helper.dart';
import '../services/sync_read_service.dart';
import 'global_http.dart';
import 'links.dart';

class PjpPlanAPI {
  Future<ReturnedDataModel> getFullMonthPjpPlanAPI({bool forTodayOnly=false, DateTime? startDate, DateTime? endDate}) async {
    // Future<ReturnedDataModel> rejectRequisitionRequisitionAPI(SrInfoModel sr, {required int requisitionId}) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      DateTime now = DateTime.now();
      String salesDate = await FFServices().getSalesDate();
      DateTime salesDateTime = DateTime.parse(salesDate);
      SrInfoModel sr = await SyncReadService().getSrInfo();
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.getPjpPlansUrl(
          startDate: forTodayOnly? DateTime.now() : startDate ?? DateTime(now.year, now.month, 1),
          endDate: forTodayOnly? DateTime.now() : endDate ?? DateTime(now.year, now.month, DateTime(now.year, now.month + 1, 0).day),
          userId: sr.ffId,
          userType: sr.userType,
        )}",
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI submitAssetRequisitionAPI $e $s");
    }
    return returnedDataModel;
  }


  Future<ReturnedDataModel> submitPjpPlanExpAPI({required int id, required String text}) async {
    // Future<ReturnedDataModel> rejectRequisitionRequisitionAPI(SrInfoModel sr, {required int requisitionId}) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      DateTime now = DateTime.now();
      // String salesDate = await FFServices().getSalesDate();
      // DateTime salesDateTime = DateTime.parse(salesDate);
      SrInfoModel sr = await SyncReadService().getSrInfo();
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.updatePjpUrl}",
        httpType: HttpType.patch,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
        body: jsonEncode({
          "pjp_id": id,
          "remark": text
        }),
      ).fetch();
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI submitAssetRequisitionAPI $e $s");
    }
    return returnedDataModel;
  }
}
