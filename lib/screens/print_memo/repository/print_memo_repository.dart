import '../../../api/global_http.dart';
import '../../../api/links.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../services/ff_services.dart';
import '../../../services/helper.dart';
import '../../../services/sync_read_service.dart';
import '../model/load_summary_model.dart';

class PrintMemoRepository {
  Future<ReturnedDataModel> getLoadSummary({required String date}) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel sr = await SyncReadService().getSrInfo();
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.getLoadSummary(sr.depId ?? 0, date)}",
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

  Future<ReturnedDataModel> getLoadSummaryDetails({
    required LoadSummaryModel loadSummary,
    required DateTime date,
  }) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel sr = await SyncReadService().getSrInfo();
      returnedDataModel = await GlobalHttp(
        uri:
            "${Links.baseUrl}${Links.getLoadSummaryDetails(vehicleId: loadSummary.vehicleId ?? 0, depId: loadSummary.depId ?? 0, date: loadSummary.date ?? '', selectedDate: apiDateFormat.format(date))}",
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

  Future<ReturnedDataModel> getDeliveryOutletData(String date) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel? srInfoModel = await SyncReadService().getSrInfo();
      String url =
          "${Links.baseUrl}${Links.preorderPrintMemoRetailerUrl}/${srInfoModel.ffId}/$date";
      returnedDataModel = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
        accessToken: srInfoModel.accessToken,
        refreshToken: srInfoModel.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI submitAssetRequisitionAPI $e $s");
    }
    return returnedDataModel;
  }
}
