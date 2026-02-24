

import 'dart:convert';
import 'dart:developer';

import '../constants/constant_variables.dart';
import '../constants/sync_global.dart';

class AppVersionService {
  Future<bool>checkVersionMatched()async{
    try{
      if(syncObj.isNotEmpty){

        if(syncObj.containsKey("app_version_configurations")){
          if(syncObj["app_version_configurations"].containsKey("version")){
            if(syncObj["app_version_configurations"]["version"] == appVersionDeviceLog){
              return true;
            }
          }

        }
      }
    }
    catch(e,s){
      print("inside AppVersionService checkVersionMatched $e, $s ");
    }
    return false;
  }

  Future<bool>checkVersionIfMandatory()async{
    try{
      if(syncObj.isNotEmpty){
        if(syncObj.containsKey("app_version_configurations")){
          if(syncObj["app_version_configurations"].containsKey("version_mandatory")){
            if(syncObj["app_version_configurations"]["version_mandatory"] == 1){
              return true;
            }
          }

        }
      }
    }
    catch(e,s){
      print("inside AppVersionService checkVersionIfMandatory $e, $s ");
    }
    return false;
  }
}