import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import '../services/encryption_services.dart';
import '../services/sync_read_service.dart';
import 'global_http.dart';
import 'links.dart';

class LogInAPI {
  ///login api http call
  Future<ReturnedDataModel> fetchLoginInfo(String username, String password) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try {
      print('\nurl is:: ${Uri.parse('${Links.baseUrl}${Links.logInAssets}')}');
      Map payload = {
        "username": username,
        "password": password,
        "version": appVersionDeviceLog,
        "app_type": 53,
      };

      Response res = await post(
        Uri.parse('${Links.baseUrl}${Links.logInAssets}'),
        body: jsonEncode(payload),
        headers: {"Content-Type": "application/json"},
      );
      Map result = jsonDecode(res.body);
      print('---------------------->');
      print('\nurl is:: ${Uri.parse('${Links.baseUrl}${Links.logInAssets}')}--->\nPayload is::${jsonEncode(payload)}\nbody is:>: ${res.body}');
      if (res.statusCode == 201) {
        if (result['success'] == true) {
          Map data = result['data'];
          ReturnedDataModel syncDataModel = ReturnedDataModel(status: ReturnedStatus.success);
          if (syncDataModel.status == ReturnedStatus.success) {
            // ReturnedDataModel syncFileData = ReturnedDataModel(status: ReturnedStatus.success, data: dummyData);
            ReturnedDataModel syncFileData = await fetchSyncFile(data, password);
            // syncDataModel.data = {'user_data': data};
            if (syncFileData.status == ReturnedStatus.success) {
              returnedDataModel.status = ReturnedStatus.success;
              returnedDataModel.data = syncFileData.data;
            }
            returnedDataModel.errorMessage = syncFileData.errorMessage;
            return returnedDataModel;
          }
        }
      }
      returnedDataModel.errorMessage = result['message'];

      return returnedDataModel;
    } catch (e, s) {
      print('inside log in api error: $s');
      returnedDataModel.errorMessage = e.toString();
      return returnedDataModel;
    }
  }

  /// api calling sync file
  Future<ReturnedDataModel> fetchSyncFile(Map useData, String password) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try {
      final body = jsonEncode(<String, dynamic>{
        "ff_id": useData["ff_id"],
        "user_type": useData["user_type"],
        "password": password,
        "version": appVersionDeviceLog,
      });
      Response res = await post(
        Uri.parse('${Links.baseUrl}${Links.syncAssets}'),
        body: body,
        headers: {'Accept': 'application/json', "Content-Type": "application/json", 'refreshToken': useData['refreshToken'], 'Authorization': "Bearer ${useData['accessToken']}"},
      );
      print('link is:: ${Uri.parse('${Links.baseUrl}${Links.syncAssets}')}\nbody is :${jsonEncode(body)}'
          '\nresponse >> is ${res.body}');
      if (res.statusCode == 201) {
        try {
          String? decryptedSync = EncryptionServices().decrypt(res.body);
          if (decryptedSync != null) {
            Map syncResult = jsonDecode(decryptedSync);
            // print(syncResult);
            if (syncResult["success"]) {
              returnedDataModel.status = ReturnedStatus.success;

              returnedDataModel.data = syncResult["data"];
            }
          }
        } catch (e, s) {
          returnedDataModel.errorMessage = jsonDecode(res.body)['message'];
          print("sync decryption error $e $s");
        }
        returnedDataModel.errorMessage = jsonDecode(res.body)['message'];
      }
    } catch (e, t) {
      print('inside log in sync file api error: $e');
      print('inside log in sync file api error: $t');
      returnedDataModel.errorMessage = e.toString();
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> fetchSyncFileWithRout({required Map useData, required String password, required num routId, required num sectionId}) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try {
      Map body=<String, dynamic>{
        "ff_id": useData["ff_id"].toString(),
        "route_id": routId.toString(),
        "section_id": sectionId.toString(),
        "user_type": useData["user_type"].toString(),
        "password": password,
      };

      log('sync file payload::: $body');

      Response res = await post(
        Uri.parse('${Links.baseUrl}${Links.syncAssets}'),
        body: body,

        //{requested_section_id: 914, section_code: 82-327-1448, section_config_id: 1448, route_id: 327}
        //{requested_section_id: 914, section_code: 82-327-1448, section_config_id: 1448, route_id: 327}
        headers: {'Accept': 'application/json', 'refreshToken': useData['refreshToken'], 'Authorization': "Bearer ${useData['accessToken']}"},
      );
      log('sync api response----> ${body}');
      log('sync api response----> ${res.body}');
      if (res.statusCode == 201) {
        try {
          String? decryptedSync = EncryptionServices().decrypt(res.body);
          if (decryptedSync != null) {
            Map syncResult = jsonDecode(decryptedSync);
            // print(syncResult);
            if (syncResult["success"]) {
              returnedDataModel.status = ReturnedStatus.success;

              returnedDataModel.data = syncResult["data"];
            }
          }
        } catch (e, s) {
          print("sync decryption error $e $s");
        }
      }
    } catch (e, t) {
      print('inside log in sync file api error: $e $t');
      returnedDataModel.errorMessage = e.toString();
    }
    return returnedDataModel;
  }


  ///update password
  Future<ReturnedDataModel> updatePassword(String oldPassword, String newPassword) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try {
      print('\nurl is:: ${Uri.parse('${Links.baseUrl}${Links.updatePassword}')}');

      SrInfoModel srInfo = await SyncReadService().getSrInfo();

      Map payload = {
        "user_id": srInfo.ffId,
        "user_type": srInfo.userType,
        "password":oldPassword,
        "newpassword":newPassword,
      };

      returnedDataModel = await GlobalHttp(
        httpType: HttpType.post,
        uri: '${Links.baseUrl}${Links.updatePassword}',
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
        body: jsonEncode(payload),
      ).fetch();



      return returnedDataModel;
    } catch (e, s) {
      print('inside log in api error: $s');
      returnedDataModel.errorMessage = e.toString();
      return returnedDataModel;
    }
  }
}
