import 'dart:convert';

import '../constants/enum.dart';
import '../models/asset_install_pull_out_get_model.dart';
import '../models/asset_requisition_model.dart';
import '../models/maintanence_model.dart';
import '../models/previous_requisition.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import '../services/helper.dart';
import '../services/sync_read_service.dart';
import 'global_http.dart';
import 'links.dart';

class AssetManagementAPI {
  Future<ReturnedDataModel> submitAssetRequisitionAPI(
      Map payload, SrInfoModel sr) async {
    ReturnedDataModel returnedDataModel =
        ReturnedDataModel(status: ReturnedStatus.error);
    try {
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.submitAssetRequisitionDataUrl}",
        httpType: HttpType.post,
        body: jsonEncode(payload),
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI submitAssetRequisitionAPI $e $s");
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> acceptRequisitionAPI(
      Map payload, SrInfoModel sr) async {
    ReturnedDataModel returnedDataModel =
        ReturnedDataModel(status: ReturnedStatus.error);
    try {
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.approveAssetRequisitionRoDataUrl}",
        httpType: HttpType.post,
        body: jsonEncode(payload),
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI submitAssetRequisitionAPI $e $s");
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> acceptCreatedRequisitionAPI(
      Map payload, SrInfoModel sr) async {
    ReturnedDataModel returnedDataModel =
        ReturnedDataModel(status: ReturnedStatus.error);
    try {
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.approveCreatedAssetRequisitionRoDataUrl}",
        httpType: HttpType.post,
        body: jsonEncode(payload),
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI submitAssetRequisitionAPI $e $s");
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> rejectRequisitionRequisitionAPI(SrInfoModel sr,
      {required int requisitionId}) async {
    ReturnedDataModel returnedDataModel =
        ReturnedDataModel(status: ReturnedStatus.error);
    try {
      returnedDataModel = await GlobalHttp(
        uri:
            "${Links.baseUrl}${Links.rejectRequisitionRoDataUrl}$requisitionId",
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

  Future<ReturnedDataModel> submitAssetInstallationAPI(
      Map payload, SrInfoModel sr) async {
    ReturnedDataModel returnedDataModel =
        ReturnedDataModel(status: ReturnedStatus.error);
    try {
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.submitAssetInstallationDataUrl}",
        httpType: HttpType.post,
        body: jsonEncode(payload),
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI submitAssetInstallationAPI $e $s");
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> submitAssetPullOutAPI(
      Map payload, SrInfoModel sr) async {
    ReturnedDataModel returnedDataModel =
        ReturnedDataModel(status: ReturnedStatus.error);
    try {
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.submitAssetPullOutDataUrl}",
        httpType: HttpType.post,
        body: jsonEncode(payload),
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint("inside AssetManagementAPI submitAssetPullOutAPI $e $s");
    }
    return returnedDataModel;
  }

  Future<List<AssetRequisitionModel>> getAssetRequisitionByOutletId(
      int outletId) async {
    List<AssetRequisitionModel> list = [];
    try {
      SrInfoModel sr = await SyncReadService().getSrInfo();
      ReturnedDataModel returnedDataModel = await GlobalHttp(
        uri:
            "${Links.baseUrl}${Links.getAssetRequisitionDataForInstallationUrl}$outletId",
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        if (returnedDataModel.data.containsKey("asset_list")) {
          for (Map assetMap in returnedDataModel.data["asset_list"]) {
            list.add(AssetRequisitionModel.fromJson(assetMap));
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI getAssetRequisitionByOutletId $e $s");
    }
    return list;
  }

  Future<List<int>> getTSMRetailerList(
    AssetInstallPullOutGetModel data,
  ) async {
    List<int> list = [];
    try {
      SrInfoModel sr = await SyncReadService().getSrInfo();
      ReturnedDataModel returnedDataModel = await GlobalHttp(
        uri:
            "${Links.baseUrl}${Links.getInstallPullOutRetailers(depIds: sr.depIds ?? '', activity: data.activity, assetType: data.assetType.id)}",
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        if (returnedDataModel.data.containsKey("data")) {
          list = returnedDataModel.data['data'].cast<int>();
        }
      }
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI getAssetRequisitionByOutletId $e $s");
    }
    return list;
  }

  Future<List<PreviousRequisition>> getRoAssetRequisitions(String depId) async {
    List<PreviousRequisition> list = [];
    try {
      SrInfoModel sr = await SyncReadService().getSrInfo();
      ReturnedDataModel returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.roAllRequisitionUrl(depId)}",
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        if (returnedDataModel.data.containsKey("data")) {
          for (Map<String, dynamic> assetMap
              in returnedDataModel.data["data"]) {
            list.add(PreviousRequisition.fromJson(assetMap));
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI getAssetRequisitionByOutletId $e $s");
    }
    return list;
  }

  Future<List<AssetPullOutModel>> getAssetPullInByOutletCode(
      String outletCode) async {
    List<AssetPullOutModel> list = [];
    try {
      SrInfoModel sr = await SyncReadService().getSrInfo();
      ReturnedDataModel returnedDataModel = await GlobalHttp(
        uri:
            "${Links.baseUrl}${Links.getAssetPullInDataForInstallationUrl}$outletCode",
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        if (returnedDataModel.data.containsKey("asset_list")) {
          for (Map assetMap in returnedDataModel.data["asset_list"]) {
            list.add(AssetPullOutModel.fromJson(assetMap));
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI getAssetPullInByOutletCode $e $s");
    }
    return list;
  }

  Future<List<MaintenanceModel>> assetMaintenanceList() async {
    List<MaintenanceModel> list = [];
    try {
      SrInfoModel sr = await SyncReadService().getSrInfo();
      ReturnedDataModel returnedDataModel = await GlobalHttp(
        uri:
            "${Links.baseUrl}${Links.maintenanceTasksListUrl(userId: sr.ffId.toString())}",
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        if (returnedDataModel.data.containsKey("data")) {
          for (Map<String, dynamic> assetMap
              in returnedDataModel.data["data"]) {
            list.add(MaintenanceModel.fromJson(assetMap));
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI getAssetPullInByOutletCode $e $s");
    }
    return list;
  }

  Future<ReturnedDataModel> maintenanceCompleteAPI(
      Map payload, SrInfoModel sr) async {
    ReturnedDataModel returnedDataModel =
        ReturnedDataModel(status: ReturnedStatus.error);
    try {
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.maintenanceCompleteUrl}",
        httpType: HttpType.post,
        body: jsonEncode(payload),
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint(
          "inside AssetManagementAPI submitAssetInstallationAPI $e $s");
    }
    return returnedDataModel;
  }
}
