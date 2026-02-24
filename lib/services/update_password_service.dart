import 'dart:convert';

import '../constants/sync_global.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class UpdatePasswordService {

  final SyncService _syncService = SyncService();
  final SyncReadService _syncReadService = SyncReadService();

  Future updatePassword({required String password}) async {
    await _syncService.checkSyncVariable();
    syncObj["userData"]["password"] = password;


    await _syncService.writeSync(jsonEncode(syncObj));
  }

}