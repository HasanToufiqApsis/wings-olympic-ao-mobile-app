import 'dart:developer';

import 'package:flutter/material.dart';

import '../constants/sync_global.dart';
import '../models/location_category_models.dart';
import 'sync_service.dart';

class LocationCategoryServices {
  final SyncService _syncService = SyncService();

  Future<List<ClusterModel>> getClusterList() async {
    try {
      List<ClusterModel> clusterList = [];
      await _syncService.checkSyncVariable();
      if(syncObj.containsKey('locations')){
        if(syncObj['locations'].containsKey('clusters')){
          syncObj['locations']['clusters'].forEach((id, cluster) {
            ClusterModel clusterModel = ClusterModel.fromJson(cluster);
            clusterList.add(clusterModel);
          });
        }
      }

      return clusterList;
    } catch (e) {
      print('inside getCluster function in sync read service error:  $e');
      return [];
    }
  }

  //point
  Future<String> getPointNameById(String pointID)async{
    try {
      await _syncService.checkSyncVariable();
      if (syncObj["locations"].containsKey("points")){
        if (syncObj["locations"]["points"].containsKey(pointID)){ //name
          return syncObj["locations"]["points"][pointID]["name"];
        }
      }
    }
    catch(e){
      print("inside getPointById function catch block error: $e");
    }
    return "";
  }

  // cluster
  Future<String> getClusterNameById(String clusterId)async{
    try {
      await _syncService.checkSyncVariable();
      if (syncObj["locations"].containsKey("points")){
        if (syncObj["locations"]["points"].containsKey(clusterId)){ //name
          return syncObj["locations"]["points"][clusterId]["name"];
        }
      }
    }
    catch(e){
      print("inside getPointById function catch block error: $e");
    }
    return "";
  }

  Future<List<PointModel>> getPointList() async {
    List<PointModel> points = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj["locations"].containsKey("points")) {
        Map pointMap = syncObj["locations"]["points"];
        if (pointMap.isNotEmpty) {
          pointMap.forEach((pointId, value) {
            points.add(PointModel.fromJson(value));
          });
        }
      }
    } catch (e) {
      print("inside getPointList LocationCategoryServices catch block $e");
    }

    return points;
  }

  //section
  Future<String> getSectionNameById(String pointID)async{
    try {
      await _syncService.checkSyncVariable();
      if (syncObj["locations"].containsKey("sections")){
        if (syncObj["locations"]["sections"].containsKey(pointID)){ //name
          return syncObj["locations"]["sections"][pointID]["name"];
        }
      }
    }
    catch(e){
      print("inside getPointById function catch block error: $e");
    }
    return "";
  }

  Future<List<String>> getRetailerAllRoutesName (List<int> routeIds) async {
    List<String> routes=[];
    try {
      for(var routId in routeIds) {
        routes.add(await getSectionNameById(routId.toString())) ;
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
    return routes;
  }

  Future<List<SectionModel>> getSectionList({int? pointId}) async {
    List<SectionModel> sections = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj["locations"].containsKey("sections")) {
        Map sectionMap = syncObj["locations"]["sections"];
        if (sectionMap.isNotEmpty) {
          sectionMap.forEach((key, value) {
            Map? singleSectionMap;
            if (pointId != null) {
              if (value.containsKey("parent_id")) {
                if (value["parent_id"] == pointId) {
                  singleSectionMap = value;
                }
              }
            } else {
              singleSectionMap = value;
            }

            if (singleSectionMap != null) {
              sections.add(SectionModel.fromJson(singleSectionMap));
            }
          });
        }
      }
    } catch (e) {
      print("inside getSectionList locationCategoryServices catch block $e");
    }
    return sections;
  }

  Future<SectionModel?> getActiveSection() async {
    try {
      if (syncObj["locations"].containsKey("sections")) {
        Map sectionMap = syncObj["locations"]["sections"];
        if (sectionMap.isNotEmpty) {
          for(var value in sectionMap.values){
            {
              if(value != null) {
                final section = SectionModel.fromJson(value);
                if(section.isActive == true){
                  return section;
                }
              }
            }
          }
        }
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return null;
  }

  Future<bool> checkIfMultiPointExists() async {
    bool exists = false;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj["locations"].containsKey("points")) {
        Map pointMap = syncObj["locations"]["points"];
        if (pointMap.isNotEmpty) {
          exists = pointMap.length > 1;
        }
      }
    } catch (e) {
      print("inside checkIfMultiPointExists locationCategoryServices catch block $e");
    }
    return exists;
  }

  Future<bool> checkIfMultiSectionExists() async {
    bool exists = false;
    try {
      bool multiPoint = await checkIfMultiPointExists();
      if (multiPoint) {
        exists = true;
      } else {
        if (syncObj["locations"].containsKey("sections")) {
          Map sectionMap = syncObj["locations"]["sections"];
          if (sectionMap.isNotEmpty) {
            exists = sectionMap.length > 1;
          }
        }
      }
    } catch (e) {
      print("inside checkIfMultiSectionExists locationCategoryServices catch block $e");
    }
    return exists;
  }

  Future<PointModel?> getSelectedPoint() async {
    try {
      if(syncObj.containsKey('selected_point')){
        return PointModel.fromJson(syncObj['selected_point']);
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return null;
  }
}
