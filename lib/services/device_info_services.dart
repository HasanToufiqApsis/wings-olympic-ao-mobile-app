import 'dart:convert';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:wings_olympic_sr/services/helper.dart';

import '../api/global_http.dart';
import '../api/links.dart';
import '../constants/constant_keys.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import 'ff_services.dart';
import 'sync_service.dart';

class DeviceInfoService {
  static final DeviceInfoService _phoneInfoService = DeviceInfoService.internal();
  factory DeviceInfoService() => _phoneInfoService;
  DeviceInfoService.internal();

  final SyncService _syncService = SyncService();
  final FFServices _ffServices = FFServices();


  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<AndroidDeviceInfo> getAndroidInfo() async {
    return await _deviceInfo.androidInfo;
  }

  Future<Map> getDeviceLog() async {
    Map deviceLog = {};
    _syncService.checkSyncVariable();
    SrInfoModel? _srInfo = await _ffServices.getSrInfo();
    String _salesDate  = await _ffServices.getSalesDate();

    AndroidDeviceInfo androidInfo = await getAndroidInfo();

    deviceLog = {
      deviceLogSbuIdKey: _srInfo!.sbuId,
      deviceLogDateKey: _salesDate,
      deviceLogFFIdKey: _srInfo.ffId,
      deviceLogDepIdKey: _srInfo.depId,
      deviceLogSectionIdKey: _srInfo.sectionId,
      deviceLogDeviceBrandKey: androidInfo.model,
      deviceLogDeviceModelKey: androidInfo.brand,
      deviceLogDeviceOsKey: androidInfo.version.sdkInt,
      deviceLogDeviceImeiKey: androidInfo.id
    };

    Helper.dPrint("device info is :: $deviceLog");

    return deviceLog;
  }

  sendDeviceLog() async {
    return;
    Map deviceLog = await getDeviceLog();
    String? token = "";//await FirebaseMessaging.instance.getToken();
    // if (token != null) {
    //   deviceLog['mobile_token'] = token;
    // }
    if (deviceLog.isNotEmpty) {
      SrInfoModel? _srInfo = await _ffServices.getSrInfo();
      ReturnedDataModel returnedDataModel = await GlobalHttp(
          httpType: HttpType.post,
          uri: '${Links.baseUrl}${Links.deviceLogUrl}',
          accessToken: _srInfo!.accessToken,
          refreshToken: _srInfo.refreshToken,
          body: jsonEncode(deviceLog))
          .fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        syncObj[deviceLogSyncKey] = true;
        await SyncService().writeSync(jsonEncode(syncObj));
      }
    }
  }

  sendDeviceInfoIfDeviceInfoIsNotSent()async{
    try{
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(deviceLogSyncKey)) {
        if (syncObj[deviceLogSyncKey] == false) {
          await DeviceInfoService().sendDeviceLog();
        }
      }
    }catch(e){
      print("inside sendDeviceInfoIfDeviceInfoIsNotSent deviceInfoServices catch block $e");
    }
  }
}

