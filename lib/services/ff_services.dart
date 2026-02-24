import 'package:wings_olympic_sr/services/sync_service.dart';

import '../constants/constant_keys.dart';
import '../constants/sync_global.dart';
import '../models/sr_info_model.dart';
import 'shared_storage_services.dart';

class FFServices{

  final SyncService _syncService = SyncService();
  //===============SR info=============
  Future<SrInfoModel?> getSrInfo() async {
    try{
      await _syncService.checkSyncVariable();
      return SrInfoModel.fromJson(syncObj["userData"]);
    }
    catch(e,s){
      print("inside FFServices getSrInfo $e, $s");
    }
    return null;
  }

  //===============Sales Date ===========
  Future<String> getSalesDate() async {
    await _syncService.checkSyncVariable();
    return syncObj['date'];
  }

  Future<String> getUsernameFromLocal()async{
    String username = "";
    try{
      username = await LocalStorageHelper.read(localStorageUsernameKey)??"";
    }catch(e){
      print("inside getUsernameFromLocal ffServices catch block $e");
    }
    return username;
  }


  Future<void> setUsernameToLocal()async{
    await _syncService.checkSyncVariable();
    String? username = syncObj["userData"]?["username"];
    if(username!=null){
      await LocalStorageHelper.save(localStorageUsernameKey, username);
    }
  }
}