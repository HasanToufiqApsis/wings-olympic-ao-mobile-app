import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import '../services/connectivity_service.dart';
import '../services/ff_services.dart';
import '../services/helper.dart';
import '../services/sync_read_service.dart';
import 'global_http.dart';
import 'links.dart';

class RetailerApi {
  final FFServices _ffServices = FFServices();

  Future<ReturnedDataModel> send(Map jsonData, String? coverImagePath, String? coolerPhotoPath, SrInfoModel srInfo, SendOutletInfoType type, [String? outletId]) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error, errorMessage: internetConnectionErrorMessage);
    try {
      bool isOnline = await ConnectivityService().checkInternet();
      if (isOnline) {
        String endPoint = type == SendOutletInfoType.create?  Links.retailerUrl : "${Links.outletEditUrl}$outletId";
        String urlString = Links.baseUrl + endPoint;// Links.retailerUrl;
        print(urlString);
        Uri url = Uri.parse(urlString);
        Map<String, String> header = {'Accept': 'application/json', 'Content-Type': 'application/json', 'Authorization': "Bearer ${srInfo.accessToken}", 'refreshToken': srInfo.refreshToken};
        String methodName =  type == SendOutletInfoType.create? "POST" : "PUT";
        var req = http.MultipartRequest(methodName, url); // "POST"
        req.headers.addAll(header);
        if (coverImagePath != null) {
          if(!coverImagePath.substring(0,4).contains("http")){
            req.files.add(await http.MultipartFile.fromPath("outlet_cover_image", coverImagePath));
          }
        }
        if (coolerPhotoPath != null) {
          if(!coolerPhotoPath.substring(0,4).contains("http")){
            req.files.add(await http.MultipartFile.fromPath("outlet_cooler_image", coolerPhotoPath));
          }
        }

        req.fields["json_data"] = jsonEncode(jsonData);
        // log(jsonEncode(jsonData));
        final xx = jsonEncode(jsonData);
        log('dhor => ${xx.runtimeType} $xx');
        var response = await req.send();
        String responseStr = await response.stream.bytesToString();
        log("Response Code ${response.statusCode}");
        log('$urlString -> ${response.statusCode} -> $responseStr -> payload ${jsonData} -> response -> ${jsonDecode(responseStr)}');
      //   print("create new request");
      // print(responseStr);

        if (Helper.checkStatusCode(response.statusCode)) {
          Map info = jsonDecode(responseStr);
          if (info["success"] == true) {
            returnedDataModel.status = ReturnedStatus.success;
            returnedDataModel.data = info["data"];
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside send RetailerApi catch block $e $s");
    }

    return returnedDataModel;
  }

  Future<ReturnedDataModel> bulkDisable(List outletCodes)async{
    ReturnedDataModel returned = ReturnedDataModel(status: ReturnedStatus.error, errorMessage: internetConnectionErrorMessage);
    try{
      bool isOnline = await ConnectivityService().checkInternet();
      SrInfoModel? srInfo = await _ffServices.getSrInfo();
      if (isOnline && srInfo!=null) {
        String urlString = Links.baseUrl + Links.bulkDisableUrl;
        Uri url = Uri.parse(urlString);

        Map<String,String> header = {'Accept': 'application/json', 'Content-Type': 'application/json', 'Authorization': "Bearer ${srInfo.accessToken}", 'refreshToken': srInfo.refreshToken};

        Map payload = {
          "outlet_codes":outletCodes
        };
        var response = await http.put(url,body: jsonEncode(payload), headers: header);
        if(Helper.checkStatusCode(response.statusCode)){
          returned.status = ReturnedStatus.success;
        }
      }
    }catch(e){
      Helper.dPrint("inside bulkDisable retailerApi catch block $e");
    }
    return returned;
  }

  Future<ReturnedDataModel> getOutletImage({required String imageName}) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel? sr = await SyncReadService().getSrInfo();
      String url = Links.getImageUrl(imageName: imageName);
      returnedDataModel = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return returnedDataModel;
  }
}
