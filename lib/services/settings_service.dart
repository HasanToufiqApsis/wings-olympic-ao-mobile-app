import 'package:flutter/foundation.dart';

import '../constants/sync_global.dart';
import '../screens/settings/model/edit_reason_model.dart';
import 'sync_service.dart';

class SettingsService {
  final SyncService _syncService = SyncService();

  Future<List<EditReasonModel>> getSaleResetReasons()async{
    List<EditReasonModel> reasons = [];
    try{
      await _syncService.checkSyncVariable();
      if(syncObj.containsKey('sale_submit_config')){
        for(Map<String ,dynamic> item in syncObj["sale_submit_config"]["reasons"]){
          reasons.add(EditReasonModel.fromJson(item));
        }
      }
    }
    catch(e,s){
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return reasons;

  }

  Future<bool> getSaleResetEligibility() async {
    bool enable = false;
    try{
      await _syncService.checkSyncVariable();
      if(syncObj.containsKey('sale_submit_config')){
        enable = syncObj['sale_submit_config']?['resetEnabled']??false;
      }
    }
    catch(e,s){
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return enable;
  }
}