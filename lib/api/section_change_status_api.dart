import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/enum.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import '../services/helper.dart';
import 'links.dart';

class SectionChangeStatusApi {
 static Future<ReturnedDataModel> fetch(SrInfoModel srInfo) async {
    ReturnedDataModel returned = ReturnedDataModel(status: ReturnedStatus.error);
    try {
      String urlString = Links.baseUrl + Links.sectionChangeStatusUrl(srInfo.ffId);
      var response = await http
          .get(Uri.parse(urlString), headers: {'Accept': 'application/json', 'Content-Type': 'application/json', 'Authorization': "Bearer ${srInfo.accessToken}", "refreshToken": srInfo.refreshToken});
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var info = jsonDecode(response.body);
        if (info.containsKey("data")) {
          returned.data = info["data"];
          returned.errorMessage = info['message'];
          switch (info["data"]) {
            case "N/A":
              returned.status = ReturnedStatus.error;
              break;
            case "Pending":
              returned.status = ReturnedStatus.info;
              break;
            case 'Rejected':
              returned.status = ReturnedStatus.warning;
              break;
            case "Approved":
              returned.status = ReturnedStatus.success;
          }
        }
      }
    } catch (e) {
      Helper.dPrint("inside fetch SectionChangeStatusApi catch block $e");
    }
    return returned;
  }
}
