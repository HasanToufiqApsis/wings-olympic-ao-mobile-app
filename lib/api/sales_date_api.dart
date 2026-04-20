import 'dart:convert';

import '../models/sr_info_model.dart';
import '../services/connectivity_service.dart';
import '../services/ff_services.dart';
import 'links.dart';
import 'package:http/http.dart' as http;

class SalesDateApi{
  final FFServices _ffServices = FFServices();
  Future<String?> fetch()async{
    String? date;
    try{
      SrInfoModel? srInfo = await _ffServices.getSrInfo();
      if(srInfo != null){
        String urlString = "${Links.baseUrl}${Links.salesDateUrl}";
        Uri url = Uri.parse(urlString);
        var response = await http.get(url,headers: {
          "Content-Type": "application/json",
          "refreshToken": srInfo.refreshToken, //sr.refreshToken,
          'Authorization':
          'Bearer ${srInfo.accessToken}' //'Bearer ${sr.accessToken}
        });

        if(response.statusCode ==200){
          Map info = jsonDecode(response.body);
          if(info["success"]==true){
            date = info["sales_date"];
          }
        }
      }


    }catch(e){
      print("inside fetch SalesDateApi catch block $e");
    }
    return date;
  }

  Future<bool> checkIfSalesDateMatchesWithSync()async{
    bool match = false;
    try{
      bool isConnected = await ConnectivityService().checkInternet();
      if(isConnected){
        String? salesDate = await fetch();
        // String? salesDate = apiDateFormat.format(DateTime.now());
        print("sate date --------->>>>>>>> =========== ${salesDate}");
        if(salesDate !=null){
          String syncSalesDate = await _ffServices.getSalesDate();
          print("sate date --------->>>>>>>> ${salesDate} :: ${syncSalesDate}");
          match = salesDate==syncSalesDate;
        }else{
          match = true;
        }
      }else{
        match = true;
      }

    }catch(e){
      print("inside checkIfSalesDateMatchesWithSync SalesDateAPi catch block $e");
    }
    return match;
  }
}