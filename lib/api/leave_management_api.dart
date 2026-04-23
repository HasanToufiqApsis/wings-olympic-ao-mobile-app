import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../models/leave_model.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import '../screens/allowance_management/model/created_tada_model.dart';
import '../screens/leave_management/model/selected_vehicle_with_tada.dart';
import '../screens/olympic_tada/model/olympic_da_info.dart';
import '../screens/olympic_tada/model/olympic_tada_entry.dart';
import '../services/Image_service.dart';
import '../services/connectivity_service.dart';
import '../services/helper.dart';
import '../services/sync_read_service.dart';
import 'global_http.dart';
import 'links.dart';

class LeaveManagementAPI {
  SyncReadService syncReadService = SyncReadService();

  Future<LeaveManagementModel> getLeaveData() async {
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      ReturnedDataModel returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}/${Links.getLeaveDataUrl(ffId: sr.ffId)}",
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        LeaveManagementModel leaveModel = LeaveManagementModel.fromJson(
          returnedDataModel.data["data"],
        );
        return leaveModel;
      }
    } catch (e, s) {
      Helper.dPrint("inside LeaveManagementAPI getLeaveData error $e $s");
    }
    return LeaveManagementModel(leaveData: [], leaveTypes: []);
  }

  Future<LeaveManagementModel> getMovementData() async {
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      ReturnedDataModel returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.getMovementDataUrl}${sr.ffId}",
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        LeaveManagementModel leaveModel = LeaveManagementModel.fromJson(
          returnedDataModel.data["data"],
        );
        return leaveModel;
      }
    } catch (e, s) {
      Helper.dPrint("inside LeaveManagementAPI getMovementData error $e $s");
    }
    return LeaveManagementModel(leaveData: [], leaveTypes: []);
  }

  Future<List<CreatedTaDaModel>> getTaDaData() async {
    List<CreatedTaDaModel> finalList = [];
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      ReturnedDataModel returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.getTaDaDataUrl(sr.ffId, sr.userType)}",
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        for (var val in returnedDataModel.data["data"]) {
          final taDaModel = CreatedTaDaModel.fromJson(val);
          finalList.add(taDaModel);
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside LeaveManagementAPI getMovementData error $e $s");
    }
    return finalList;
  }

  Future<ReturnedDataModel> sendLeaveData({
    required LeaveManagementTypes leaveManagementTypes,
    required DateTimeRange dateTimeRange,
    required String reason,
  }) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      Map payload = {
        "dep_id": sr.depId,
        "field_force_id": sr.ffId,
        "leave_type_id": leaveManagementTypes.id,
        "start_date": apiDateFormat.format(dateTimeRange.start),
        "end_date": apiDateFormat.format(dateTimeRange.end),
        "total_days":
            dateTimeRange.end.difference(dateTimeRange.start).inDays + 1,
        "reason": reason,
      };
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.setLeaveDataUrl}",
        httpType: HttpType.post,
        body: jsonEncode(payload),
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint("inside LeaveManagementAPI sendLeaveData error $e $s");
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> sendMovementData({
    required LeaveManagementTypes leaveManagementTypes,
    required DateTime dateTimeRange,
    required String reason,
    required String tada,
    required String imagePath,
  }) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      Map payload = {
        // "dep_id": sr.depId,
        "field_force_id": sr.ffId,
        "movement_type_id": leaveManagementTypes.id,
        "start_date": apiDateFormat.format(dateTimeRange),
        "end_date": apiDateFormat.format(dateTimeRange),
        "ta_da": tada,
        "total_days": 1,
        "reason": reason,
      };
      if (sr.depId != null) {
        payload["dep_id"] = sr.depId;
      }
      log("payload :::: ${jsonEncode(payload)}");
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.setMovementDataUrl}",
        httpType: HttpType.file,
        otherDataWithImage: payload,
        imageHeader: "image",
        // imagePath: imagePath,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint("inside LeaveManagementAPI sendMovementData error $e $s");
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> sendTaDaData({
    required String fromAddress,
    required String toAddress,
    required String contactPerson,
    required String contactNumber,
    required String reason,
    required List<SelectedVehicleWithTaDa> vehicleTaDa,
    required List<SelectedVehicleWithTaDa> otherTaDa,
    required DateTime dateRange,
    required List<String> images,
  }) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      List costList = [];
      for (var vehicle in vehicleTaDa) {
        costList.add({
          "cost_type": "${vehicle.selectedTaDa?.id}",
          "cost": "${vehicle.textEditingController?.text}",
        });
      }
      for (var vehicle in otherTaDa) {
        costList.add({
          "cost_type": "${vehicle.selectedTaDa?.id}",
          "cost": "${vehicle.textEditingController?.text}",
        });
      }

      List<String> imagesNames = [];

      for (var imagePath in images) {
        imagesNames.add(
          "tada/${sr.userType}/${sr.ffId}/${imagePath.split("/").last}",
        );
        await sendManualOverrideImageToServer(File(imagePath), sr);
      }

      Map payload = {
        "user_id": sr.ffId,
        "user_type_id": sr.userType,
        // "start_date": "2023-10-01",
        // "end_date": "2023-10-10",
        "start_date": apiDateFormat.format(dateRange),
        "end_date": apiDateFormat.format(dateRange),
        "from_address": fromAddress,
        "to_address": toAddress,
        "remark": reason,
        "contact_name": contactPerson,
        "contact_no": contactNumber,
        "ta_da_cost": costList,
        "ta_da_image": imagesNames,
      };

      log("payload :::: ${jsonEncode(payload)}");
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.createTaDaDataUrl}",
        httpType: HttpType.post,
        body: jsonEncode(payload),
        // imagePath: imagePath,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint("inside LeaveManagementAPI sendMovementData error $e $s");
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> sendOlympicTaDaData({
    required List<OlympicTaDaEntry> taEntries,
    required OlympicDaInfo daInfo,
    required String remarks,
  }) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      final List<Map<String, dynamic>> travelInfoList =
          <Map<String, dynamic>>[];
      num total = daInfo.amount;
      for (final entry in taEntries) {
        total += entry.amount;
        travelInfoList.add(entry.toTravelInfoJson());
      }

      final List<Map<String, dynamic>> daList = <Map<String, dynamic>>[
        daInfo.toDaJson(),
      ];

      Map payload = {
        "user_id": sr.ffId,
        "user_type_id": sr.userType,
        "total_cost": total,
        "remark": remarks,
        "ta_da_travel_info": travelInfoList,
        "ta_da_da": daList,
      };

      log("payload :::: ${jsonEncode(payload)}");
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.createTaDaDataUrl}",
        httpType: HttpType.post,
        body: jsonEncode(payload),
        // imagePath: imagePath,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint("inside LeaveManagementAPI sendMovementData error $e $s");
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> getMovementForThisData({
    required DateTime dateRange,
  }) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();

      returnedDataModel = await GlobalHttp(
        uri:
            "${Links.baseUrl}${Links.checkTodayMovementDataUrl(sr.ffId, sr.userType, apiDateFormat.format(dateRange))}",
        httpType: HttpType.get,
        // imagePath: imagePath,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint("inside LeaveManagementAPI sendMovementData error $e $s");
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> updateTaDaData({
    required String fromAddress,
    required String toAddress,
    required String contactPerson,
    required String contactNumber,
    required String reason,
    required List<SelectedVehicleWithTaDa> vehicleTaDa,
    required List<SelectedVehicleWithTaDa> otherTaDa,
    required DateTimeRange dateRange,
    required List<String> images,
    required CreatedTaDaModel? tada,
  }) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      List costList = [];
      for (var vehicle in vehicleTaDa) {
        costList.add({
          "cost_type": "${vehicle.selectedTaDa?.id}",
          "cost": "${vehicle.textEditingController?.text}",
        });
      }
      for (var vehicle in otherTaDa) {
        costList.add({
          "cost_type": "${vehicle.selectedTaDa?.id}",
          "cost": "${vehicle.textEditingController?.text}",
        });
      }

      List<String> imagesNames = [];

      for (var imagePath in images) {
        imagesNames.add(
          "tada/${sr.userType}/${sr.ffId}/${imagePath.split("/").last}",
        );
        await sendManualOverrideImageToServer(File(imagePath), sr);
      }

      Map payload = {
        "user_id": sr.ffId,
        "user_type_id": sr.userType,
        // "start_date": "2023-10-01",
        // "end_date": "2023-10-10",
        "start_date": apiDateFormat.format(dateRange.start),
        "end_date": apiDateFormat.format(dateRange.end),
        "from_address": fromAddress,
        "to_address": toAddress,
        "remark": reason,
        "contact_name": contactPerson,
        "contact_no": contactNumber,
        "ta_da_cost": costList,
        "ta_da_image": imagesNames,
      };

      log("payload :::: ${jsonEncode(payload)}");
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.updateTaDaDataUrl(tada?.taDaId ?? 0)}",
        httpType: HttpType.patch,
        body: jsonEncode(payload),
        // imagePath: imagePath,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, s) {
      Helper.dPrint("inside LeaveManagementAPI sendMovementData error $e $s");
    }
    return returnedDataModel;
  }

  Future<void> sendManualOverrideImageToServer(
    File compressedImage,
    SrInfoModel sr,
  ) async {
    if (await ConnectivityService().checkInternet()) {
      String path =
          "tada/${sr.userType}/${sr.ffId}/${compressedImage.path.split("/").last}";
      bool done = await ImageService().sendImage(compressedImage.path, path);
      if (done) {
        if (await compressedImage.exists()) {
          await compressedImage.delete();
        }
      }
    }
  }

  Future<Map> getLeaveCalenderData({required DateTime date}) async {
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      ReturnedDataModel returnedDataModel = await GlobalHttp(
        uri:
            "${Links.baseUrl}${Links.leaveCalenderUrl}?ff_id=${sr.ffId}&month=${date.month}&year=${date.year}",
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        log('x success');
        return returnedDataModel.data['data'];
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return {};
  }

  Future<ReturnedDataModel> sendEditMovementData({
    required int value,
    required LeaveManagementData movement,
  }) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );

    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      Map payload = {"ta_da": value};
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.movementEditUrl}/${movement.id}",
        httpType: HttpType.patch,
        body: jsonEncode(payload),
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();

      return returnedDataModel;
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());

      return ReturnedDataModel(
        status: ReturnedStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  Future<ReturnedDataModel> sendEditFullMovementData({
    required LeaveManagementTypes leaveManagementTypes,
    required DateTime dateTimeRange,
    required String reason,
    required String tada,
    required String imagePath,
    required LeaveManagementData movement,
  }) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );

    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      Map payload = {
        // "field_force_id": sr.ffId,
        "movement_type_id": leaveManagementTypes.id,
        "start_date": apiDateFormat.format(dateTimeRange),
        "end_date": apiDateFormat.format(dateTimeRange),
        "ta_da": tada,
        "total_days": 1,
        "reason": reason,
      };
      returnedDataModel = await GlobalHttp(
        uri: "${Links.baseUrl}${Links.movementEditUrl}/${movement.id}",
        httpType: HttpType.patch,
        body: jsonEncode(payload),
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();

      return returnedDataModel;
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());

      return ReturnedDataModel(
        status: ReturnedStatus.error,
        errorMessage: error.toString(),
      );
    }
  }
}
