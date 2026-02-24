import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:wings_olympic_sr/services/product_category_services.dart';
import 'package:wings_olympic_sr/services/sync_read_service.dart';
import 'package:wings_olympic_sr/services/sync_service.dart';

import '../api/team_performance_repository.dart';
import '../constants/enum.dart';
import '../models/dsr_model.dart';
import '../models/outlet_model.dart';
import '../models/product_model.dart';
import '../models/returned_data_model.dart';
import '../models/target/dashboard_target_model.dart';
import '../models/target/sr_stt_target_model.dart';
import '../models/team_performance/complete_dsr_wise_performance_model.dart';

class PerMetaData {
  List<dynamic> rawRetailerList;
  List<int> retailerIdList;

  PerMetaData({required this.rawRetailerList, required this.retailerIdList});
}

Future<List<OutletModel>> _parseRetailerList(PerMetaData metaData) async {
  List<OutletModel> resultList = [];
  for (var json in metaData.rawRetailerList) {
    if (metaData.retailerIdList.contains(json['id'])) {
      resultList.add(OutletModel.fromJson(json));
    }
  }

  return resultList;
}

Future<List<OutletModel>> _computeRetailerList(PerMetaData metaData) async {
  List<OutletModel> retailers = await compute(_parseRetailerList, metaData);
  return retailers;
}

class TeamPerformanceService {
  final _syncService = SyncService();
  final TeamPerformanceRepository _teamPerformanceRepository = TeamPerformanceRepository();
  final _syncReadService = SyncReadService();
  final _productCategoryServices = ProductCategoryServices();

  // Future<List<SectionModel>> getSectionList(int superVisorId) async {
  //   log("supervisor id: $superVisorId");
  //   final sectionList = <SectionModel>[];
  //   try {
  //     await _syncService.checkSyncVariable();
  //
  //     if (syncObj.containsKey("locations")) {
  //       if (syncObj['locations'].containsKey("sections")) {
  //         final sectionMap = syncObj['locations']["sections"];
  //         for (var json in sectionMap.values) {
  //           if (json['parent_id'] == superVisorId) {
  //             sectionList.add(
  //               SectionModel.fromJson(json),
  //             );
  //           }
  //         }
  //       }
  //     }
  //   } catch (error, stck) {
  //     debugPrint(error.toString());
  //     debugPrint(stck.toString());
  //   }
  //
  //   log('Section list => supervisorId : $superVisorId => length : ${sectionList.length}');
  //
  //   return sectionList;
  // }

  // Future<List<RetailerModel>> getRetailerList(List<int> retailerIds) async {
  //   try {
  //     await _syncService.checkSyncVariable();
  //     final syncRetailerList = syncObj['retailers'];
  //     return await _computeRetailerList(
  //       PerMetaData(
  //         rawRetailerList: syncRetailerList,
  //         retailerIdList: retailerIds,
  //       ),
  //     );
  //   } catch (error, stck) {
  //     debugPrint(error.toString());
  //     debugPrint(stck.toString());
  //   }
  //
  //   return [];
  // }

  // Future<List<SupervisorModel>> getSupervisorList() async {
  //   final visorList = <SupervisorModel>[];
  //
  //   try {
  //     await _syncService.checkSyncVariable();
  //     final superVisorJson = syncObj['locations']['supervisor'];
  //
  //     for (var json in superVisorJson.values) {
  //       visorList.add(SupervisorModel.fromJson(json));
  //     }
  //   } catch (error, stck) {
  //     debugPrint(error.toString());
  //     debugPrint(stck.toString());
  //   }
  //
  //   // log('supervisor list => ${visorList.length}');
  //
  //   return visorList;
  // }

  // Future<List<PointModel>> getAwsPointList() async {
  //   final awsPointList = <PointModel>[];
  //
  //   try {
  //     await _syncService.checkSyncVariable();
  //     final superVisorJson = syncObj['locations']['points'];
  //
  //     for (var json in superVisorJson.values) {
  //       awsPointList.add(PointModel.fromJson(json));
  //     }
  //   } catch (error, stck) {
  //     debugPrint(error.toString());
  //     debugPrint(stck.toString());
  //   }
  //
  //   // log('aws point list => ${awsPointList.length}');
  //
  //   return awsPointList;
  // }

  Future<List<DsrModel>> getDsrList(List dsrJson) async {
    final dsrList = <DsrModel>[];

    try {
      await _syncService.checkSyncVariable();

      for (var json in dsrJson) {
        dsrList.add(DsrModel.fromJson(json));
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    // log('aws point list => ${awsPointList.length}');

    return dsrList;
  }

  Future<List<CompletePerformanceModel>> getAllDsrWisePerformanceData() async {
    List<CompletePerformanceModel> performanceList = [];

    try {
      ReturnedDataModel responseData = await _teamPerformanceRepository.getDsrWisePerformanceData();
      if (responseData.status == ReturnedStatus.success) {
        Map mapData = responseData.data;
        log("map data: $mapData");
        if (mapData.containsKey("target")) {
          List<DsrModel> dsrList = await getDsrList(mapData['target']['ff_list']);

          List<DashboardTargetModel> targetList = [];
          for (DsrModel dsr in dsrList) {
            List<String> labels = [];
            if (mapData["target"]["sbu_wise_available_targets"].containsKey(dsr.id.toString())) {
              if (mapData["target"]["sbu_wise_available_targets"][dsr.id.toString()].isNotEmpty) {
                for (String label in mapData["target"]["sbu_wise_available_targets"]
                    [dsr.id.toString()]) {
                  labels.add(label);
                }
              }
            } else {
              labels.add("STT");
            }
            double minimumTargetRate =
                getMinimumTargetRate("STT", dsr.id ?? 0, mapData["target"]["targets"]);
            double current = 0;
            int totalSttTarget =
                getTotalSTTTargetForASpecificDsr(dsr.id ?? 0, mapData["target"]["targets"]);
            int totalAchievement = getTotalSTTAchievementForASpecificDsr(
                dsr.id ?? 0, mapData["target"]["sr_archivement"]);
            if (totalSttTarget > 0) {
              current = (totalAchievement * 100) / totalSttTarget;
            } else {
              if (totalAchievement > 0) {
                current = 100;
              } else {
                current = 0;
              }
            }
            log("dsr ${dsr.id}=> target: $totalSttTarget ach: $totalAchievement current: $current");
            DashboardTargetModel target = DashboardTargetModel(
              label: "STT",
              current: current,
              minimumTarget: minimumTargetRate,
            );
            targetList.add(target);
            List<SRDetailTargetModel> srDetailTargetList =
                await getSttTargetForASpecificDsr(dsr.id ?? 0, mapData["target"]);
            CompletePerformanceModel completePerformanceModel = CompletePerformanceModel(
              dashboardTargetModel: target,
              sttTargetList: srDetailTargetList,
              dsrModel: dsr,
            );
            performanceList.add(completePerformanceModel);
          }
          log("performance list length: ${performanceList.length}");
        }
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return performanceList;
  }

  ProductModel? _getProductModelById(List skuJsonList, String skuId) {
    try {
      for (var json in skuJsonList) {
        final prod = ProductModel.fromJson(json);
        if (prod.id.toString() == skuId) {
          return prod;
        }
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
    return null;
  }

  Future<List<SRDetailTargetModel>> getSttTargetForASpecificDsr(
      int dsrId, Map targetAchievementData) async {
    List<SRDetailTargetModel> list = [];
    try {
      List sbus = targetAchievementData["target_enabled_sbus"];
      bool dsrHasAchievement = checkDsrHasAchievement(dsrId, targetAchievementData["sr_archivement"]);
      if (targetAchievementData["targets"].containsKey(dsrId.toString())) {
        if (targetAchievementData["targets"][dsrId.toString()].containsKey("STT")) {
          if (targetAchievementData["targets"][dsrId.toString()]["STT"].isNotEmpty) {
            Map allSttTargets = targetAchievementData["targets"][dsrId.toString()]["STT"];
            for (MapEntry sttTargetEntry in allSttTargets.entries) {
              var typeId = sttTargetEntry.key;
              var typeValue = sttTargetEntry.value;
              for (var sbuId in sbus) {
                if (typeValue.isNotEmpty) {
                      for (var targetEntry in typeValue.entries) {
                        var skuId = targetEntry.key;
                        var target = targetEntry.value;
                        int imageId = 0;
                        int achievement = getSttAchievementByDsrAndType(
                            dsrId, typeId, skuId, targetAchievementData["sr_archivement"]);
                        ProductModel? productModel = _getProductModelById(targetAchievementData['sku_list'], skuId);
                        if (productModel != null) {
                          imageId = productModel.id;
                        }
                        SRDetailTargetModel targetModel = SRDetailTargetModel(
                            id: int.parse(skuId),
                            name: productModel?.name ?? 'N/A',
                            materialCode: productModel?.materialCode ?? '',
                            target: target,
                            achievement: achievement,
                            imageId: imageId);
                        list.add(targetModel);
                      }
                      log("sr detail list length: ${list.length}");
                    }
              }
            }
          }
        }
      }
      else{
        if(dsrHasAchievement){
          Map allSttTargets = targetAchievementData["sr_archivement"][dsrId.toString()]["STT"];
          for (MapEntry sttTargetEntry in allSttTargets.entries) {
            var typeId = sttTargetEntry.key;
            var typeValue = sttTargetEntry.value;
            for (var sbuId in sbus) {
                if (typeValue.isNotEmpty) {
                    for (var targetEntry in typeValue.entries) {
                      var skuId = targetEntry.key;
                      var target = targetEntry.value;
                      int imageId = 0;
                      int achievement = getSttAchievementByDsrAndType(
                          dsrId, typeId, skuId, targetAchievementData["sr_archivement"]);

                      ProductModel? productModel = _getProductModelById(targetAchievementData['sku_list'], skuId);
                      if (productModel != null) {
                        imageId = productModel.id;
                      }
                      SRDetailTargetModel targetModel = SRDetailTargetModel(
                          id: int.parse(skuId),
                          name: productModel?.name ?? 'N/A',
                          materialCode: productModel?.materialCode ?? '',
                          target: target,
                          achievement: achievement,
                          imageId: imageId);
                      list.add(targetModel);
                    }
                    }
                    log("sr detail list length: ${list.length}");
                  }
            }
          }
        }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return list;
  }
  
  bool checkDsrHasAchievement(int dsrId, Map data){
    bool dsrHasAchievement = false;
    try{
      if(data.containsKey(dsrId.toString())){
        if(data[dsrId.toString()].containsKey("STT")){
          if(data[dsrId.toString()]["STT"].isNotEmpty){
            dsrHasAchievement = true;
          }
        }
      }
      
    }
    catch(e,s){
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    
    return dsrHasAchievement;
  }

  int getSttAchievementByDsrAndType(
      int dsrId, String typeId, String skuTypeId, Map acheivementData) {
    try {
      return acheivementData[dsrId.toString()]["STT"][typeId][skuTypeId];
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return 0;
  }

  double getMinimumTargetRate(String label, int dsrId, Map targetData) {
    log("label: $label");
    double minimumTargetRate = 0;
    try {
      if (targetData[dsrId.toString()].containsKey(label)) {
        if (targetData[dsrId.toString()][label] is double) {
          minimumTargetRate = targetData[dsrId.toString()][label];
        } else if (targetData[dsrId.toString()][label] is int) {
          minimumTargetRate = double.parse(targetData[dsrId.toString()][label].toString());
        } else if (targetData[dsrId.toString()][label] is Map) {
          minimumTargetRate = 100;
        } else {
          minimumTargetRate = 0;
        }
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return minimumTargetRate;
  }

  int getTotalSTTTargetForASpecificDsr(int dsrId, Map targetData) {
    int totalTarget = 0;

    try {
      if (targetData.containsKey(dsrId.toString())) {
        if (targetData[dsrId.toString()].containsKey("STT")) {
          if (targetData[dsrId.toString()]["STT"].isNotEmpty) {
            targetData[dsrId.toString()]["STT"].forEach((typeId, typeValue) {
              typeValue.forEach((ids, target) {
                totalTarget += target as int;
              });
            });
          }
        }
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    return totalTarget;
  }

  int getTotalSTTAchievementForASpecificDsr(int dsrId, Map achievementData) {
    int totalAchievement = 0;

    try {
      if (achievementData.containsKey(dsrId.toString())) {
        if (achievementData[dsrId.toString()].containsKey("STT")) {
          if (achievementData[dsrId.toString()]["STT"].isNotEmpty) {
            achievementData[dsrId.toString()]["STT"].forEach((typeId, typeValue) {
              typeValue.forEach((ids, target) {
                totalAchievement += target as int;
              });
            });
          }
        }
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    return totalAchievement;
  }
}
