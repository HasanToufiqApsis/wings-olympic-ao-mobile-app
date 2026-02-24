import 'package:flutter/foundation.dart';
import 'package:wings_olympic_sr/constants/sync_global.dart';
import 'package:wings_olympic_sr/services/sync_service.dart';

class DayCloseService {
  final _syncService = SyncService();

  Future closeAllServiceForToday() async {
    await _syncService.checkSyncVariable();
    try {
      syncObj['salesSubmitted'] = true;
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    await _syncService.writeSync();
  }

  Future resetAllServiceForToday() async {
    await _syncService.checkSyncVariable();
    try {
      syncObj['salesSubmitted'] = false;
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    await _syncService.writeSync();
  }

  Future<bool> checkServiceStatusForToday() async {
    bool enable = false;
    await _syncService.checkSyncVariable();
    try {
      if(syncObj.containsKey('salesSubmitted')) {
        enable = syncObj['salesSubmitted'] ?? false;
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return enable;
  }
}