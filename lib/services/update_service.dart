import 'package:device_info_plus/device_info_plus.dart';

import '../constants/constant_variables.dart';
import '../constants/sync_global.dart';
import 'sync_service.dart';

class UpdateService {
  static final UpdateService _instance = UpdateService._internal();

  factory UpdateService() => _instance;
  UpdateService._internal();

  final SyncService _syncService = SyncService();

  Future<bool> getIsMatchedVersion()async{
    try {
      await _syncService.checkSyncVariable();
      if(syncObj.containsKey("app_version_configurations")){
        if(syncObj["app_version_configurations"].containsKey("version")){
          return appVersionDeviceLog == syncObj["app_version_configurations"]["version"];
        }
      }
    }
    catch(e, s){
      print("inside UpdateService getIsMatchedVersion error: $e, $s");
    }
    return false;
  }

  Future<String?> getAppUpdateUrl()async{
    String? url;
    try{
      await _syncService.checkSyncVariable();
      if(syncObj.containsKey("app_version_configurations")){
        Map appData = syncObj["app_version_configurations"];
        if(appData.isNotEmpty){
          List abis = appData['abi'];
          DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
          AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
          List<String?> supportedAbis = deviceInfo.supportedAbis;
          for(Map abi in abis){
            if(supportedAbis.contains(abi['type'])){
              url = abi['link'];
              break;
            }
          }
          url ??= appData['link'];
        }
      }


    }catch(e){
      print("inside getAppUpdateUrl UpdateServices catch block $e");
    }

    return url;
  }
}