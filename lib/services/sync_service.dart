import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../api/sales_date_api.dart';
import '../constants/constant_keys.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import 'before_sale_services/survey_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();

  factory SyncService() => _instance;
  SyncService._internal();

  //create/get a path for sync file storing
  Future<String> getPath() async {
    Directory baseDir = await getApplicationDocumentsDirectory();
    String syncPath = "${baseDir.path}v2/Sync/sync.wings";
    return syncPath;
  }

  //create sync file
  Future<bool> createSyncFile() async {
    try {
      String path = await getPath();
      File sync = File(path);
      bool fileExists = await sync.exists();

      if (!fileExists) {
        await sync.create(recursive: true);
        return true;
      } else {
        return true;
      }
    } catch (e) {
      print("inside createSyncFile catch block $e");
      return false;
    }
  }

  //get sync file
  Future<File?> getSyncFile() async {
    String path = await getPath();
    File sync = File(path);
    if (await sync.exists()) {
      return sync;
    }
  }

  //edit sync file
  Future<bool> writeSync([String? txt]) async {
    try {
      String text = txt??jsonEncode(syncObj);
      bool syncExists = await createSyncFile();
      if (syncExists) {
        log('sync is ----> $txt');
        File? sync = await getSyncFile();
        await sync!.writeAsString(text);
        return true;
      } else {
        return false;
      }
    } catch (e,s) {
      print("writeSync catch block $e,$s");
      return false;
    }
  }

  //get sync file data to an obj
  void printSync() async {
    if (kDebugMode) {
      File? sync = await getSyncFile();
      if (sync != null) {
        String txt = await sync.readAsString();
        if (txt.isNotEmpty) {
          log('sync is ----> $txt');
          syncObj = jsonDecode(txt);
          syncRead = true;
        }
      }
    }
    log('${SurveyService().checkSyncFileDate()}');
  }

  //get sync file data to an obj
  Future<bool> readSync() async {
    File? sync = await getSyncFile();
    if (sync != null) {
      String txt = await sync.readAsString();
      if (txt.isNotEmpty) {
        syncObj = jsonDecode(txt);
        syncRead = true;
        return true;
      }
    }
    return false;
  }



  //get boolean value from sync file if already logged in
  bool checkLoggedIn() {
    return syncObj['logged_in'] == 1;
  }

  //main login checker method
  Future<LoginStatus> checkLogin() async {
    try{

      bool syncExists = await readSync();
      if (syncExists && syncObj.containsKey("userData")) {
        bool currentTime =await SalesDateApi().checkIfSalesDateMatchesWithSync();
        if (currentTime) {
          if (checkLoggedIn()) {
            return LoginStatus.go_to_dashboard_automatically;
          } else {
            return LoginStatus.login_with_sync_file;
          }
        } else {
          return LoginStatus.login_with_sync_and_go_to_pda_upload;
        }
      } else {
        return LoginStatus.login_with_api;
      }
    }catch(e){
      print("inside checkLogin SyncServices catch block $e");
    }
    return LoginStatus.login_with_api;
  }

  Future<bool> checkIdAndPasswordFormSync(String id, String password) async {
    String syncId = syncObj['userData']['username'];
    String syncPassword = syncObj['userData']['password'];
    if (syncId == id && syncPassword == password) {
      syncObj['logged_in'] = 1;
      await writeSync(jsonEncode(syncObj));
      return true;
    } else {
      return false;
    }
  }
  // Future<bool> checkDateFromSyncFile()

  checkSyncVariable() async {
    if (!syncRead) {
      await readSync();
    }
  }

  deleteSync() async {
    (await getSyncFile())?.delete();
  }

  //================================== Expandable methods ====================================

  logoutFromSync() async {
    syncObj['logged_in'] = 0;
    await writeSync(jsonEncode(syncObj));
  }

  //create sales module if not exists
  Future<void> checkIfSalesModuleExists() async {
    try {
      await checkSyncVariable();
      if (!syncObj.containsKey(salesKey)) {
        syncObj[salesKey] = {};
        await writeSync(jsonEncode(syncObj));
      }
    } catch (e) {
      print("inside checkIfSalesModuleExists syncServices catch block $e");
    }
  }

}
