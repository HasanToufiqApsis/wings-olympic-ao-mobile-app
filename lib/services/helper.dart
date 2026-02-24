import 'package:flutter/foundation.dart';

import '../constants/constant_keys.dart';

class Helper{
  static dPrint(Object? object){
    if (kDebugMode) {
      print("$object");
    }
  }
  static int? getIdFromIdSlugMap(Map? idSlugMap){
    int? id;
    try{
      if(idSlugMap!=null){
        id= idSlugMap[idKey];
      }
    }catch(e){
      dPrint("inside getIdFromIdSlugMap helper catch block $e");
    }
    return id;
  }

  static bool checkIfUrl(String? url){
    if(url != null){
      return url.substring(0,4) == "http";
    }
    return false;

  }

  static bool checkStatusCode(num statusCode){
    return statusCode==200||statusCode==201;
  }
}