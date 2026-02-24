import 'dart:convert';

import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../constants/constant_keys.dart';
import '../constants/sync_global.dart';
import '../models/module.dart';
import '../models/product_model.dart';
import '../models/target/dashboard_target_model.dart';
import '../models/target/dashboard_target_model_overall.dart';
import '../models/target/sr_stt_target_model.dart';
import 'helper.dart';
import 'product_category_services.dart';
import 'sales_service.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class SrTargetServices {
  final SyncService _syncService = SyncService();
  final ProductCategoryServices _productCategoryServices = ProductCategoryServices();

  //get STT target for a specific module

  Future<List<Module>> getEnabledSbuModelList() async {
    List<Module> finalModuleList = [];
    try {
      await SyncService().checkSyncVariable();
      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("target_enabled_sbus")) {
          List<Module> moduleList = await SyncReadService().getModuleModelList();
          for (Module module in moduleList) {
            if (syncObj["target_configurations"]["target_enabled_sbus"].contains(module.id)) {
              finalModuleList.add(module);
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside Dashboard service getTargetType error $e, $s");
    }
    return finalModuleList;
  }

  Future<String> getTargetType(String moduleId, String label) async {
    try {
      await SyncService().checkSyncVariable();
      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("targets")) {
          if (syncObj["target_configurations"]["targets"].containsKey(moduleId.toString())) {
            if (syncObj["target_configurations"]["targets"][moduleId.toString()].containsKey(label)) {
              return syncObj["target_configurations"]["targets"][moduleId.toString()][label].runtimeType.toString();
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside Dashboard service getTargetType error $e, $s");
    }
    return "";
  }

  Future<List<SRDetailTargetModel>> getSTTTargetForASpecificModule(int moduleId) async {
    List<SRDetailTargetModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("targets")) {
          if (syncObj["target_configurations"]["targets"].containsKey(moduleId.toString())) {
            if (syncObj["target_configurations"]["targets"][moduleId.toString()].containsKey(sttTargetTypeKey)) {
              if (syncObj["target_configurations"]["targets"][moduleId.toString()][sttTargetTypeKey].isNotEmpty) {
                Map allSttTargets = syncObj["target_configurations"]["targets"][moduleId.toString()][sttTargetTypeKey];
                for (MapEntry sttTargetEntry in allSttTargets.entries) {
                  var typeId = sttTargetEntry.key;
                  var typeValue = sttTargetEntry.value;
                  if (syncObj.containsKey("cats")) {
                    if (syncObj["cats"].containsKey(moduleId.toString())) {
                      if (typeValue.isNotEmpty) {
                        for (var targetEntry in typeValue.entries) {
                          var ids = targetEntry.key;
                          var target = targetEntry.value;
                          double achievement = getSTTAchievementByModuleAndType(moduleId, typeId, ids);
                          int imageName = 0;
                          ProductModel? productModel =
                              await _productCategoryServices.getFirstSkuModelForAProductCategoryAndModule(int.parse(moduleId.toString()), int.parse(typeId.toString()), int.parse(ids.toString()));

                          if (productModel != null) {
                            imageName = productModel.id;
                          }

                          SRDetailTargetModel targetModel = SRDetailTargetModel(
                            id: int.parse(ids),
                            name: syncObj["cats"][moduleId.toString()][typeId][ids]["short_name"],
                            target: target,
                            achievement: achievement,
                            imageId: imageName,
                          );
                          list.add(targetModel);
                        }
                      }
                    }
                  }
                }
                syncObj["target_configurations"]["targets"][moduleId.toString()]["STT"].forEach((typeId, typeValue) {});
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getSTTTargetForASpecificModule SrTargetServices catch block $e, $s");
    }
    return list;
  }

  Future<List<SRDetailTargetModel>> getSTTSpecialTargetForASpecificModule(int moduleId) async {
    List<SRDetailTargetModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("targets")) {
          if (syncObj["target_configurations"]["targets"].containsKey(moduleId.toString())) {
            if (syncObj["target_configurations"]["targets"][moduleId.toString()].containsKey(sttSpecialTargetTypeKey)) {
              if (syncObj["target_configurations"]["targets"][moduleId.toString()][sttSpecialTargetTypeKey].isNotEmpty) {
                Map allSttTargets = syncObj["target_configurations"]["targets"][moduleId.toString()][sttSpecialTargetTypeKey];
                for (MapEntry sttTargetEntry in allSttTargets.entries) {
                  var typeId = sttTargetEntry.key;
                  var typeValue = sttTargetEntry.value;
                  if (syncObj.containsKey("cats")) {
                    if (syncObj["cats"].containsKey(moduleId.toString())) {
                      if (typeValue.isNotEmpty) {
                        for (var targetEntry in typeValue.entries) {
                          var ids = targetEntry.key;
                          var target = targetEntry.value;
                          double achievement = getSpecialSTTAchievementByModuleAndType(moduleId, typeId, ids);
                          int imageName = 0;
                          ProductModel? productModel =
                              await _productCategoryServices.getFirstSkuModelForAProductCategoryAndModule(int.parse(moduleId.toString()), int.parse(typeId.toString()), int.parse(ids.toString()));

                          if (productModel != null) {
                            imageName = productModel.id;
                          }

                          SRDetailTargetModel targetModel = SRDetailTargetModel(
                              id: int.parse(ids), name: syncObj["cats"][moduleId.toString()][typeId][ids]["short_name"], target: target, achievement: achievement, imageId: imageName);
                          list.add(targetModel);
                        }
                      }
                    }
                  }
                }
                syncObj["target_configurations"]["targets"][moduleId.toString()]["Special Target"].forEach((typeId, typeValue) {});
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getSTTTargetForASpecificModule SrTargetServices catch block $e, $s");
    }
    return list;
  }

  Future<List<SRDetailTargetModel>> getBCPTargetForASpecificModule(int moduleId) async {
    List<SRDetailTargetModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("targets")) {
          if (syncObj["target_configurations"]["targets"].containsKey(moduleId.toString())) {
            if (syncObj["target_configurations"]["targets"][moduleId.toString()].containsKey(bcpTargetTypeKey)) {
              if (syncObj["target_configurations"]["targets"][moduleId.toString()][bcpTargetTypeKey].isNotEmpty) {
                Map allBCPTargets = syncObj["target_configurations"]["targets"][moduleId.toString()][bcpTargetTypeKey];
                for (MapEntry bcpTargetEntry in allBCPTargets.entries) {
                  var typeId = bcpTargetEntry.key;
                  var typeValue = bcpTargetEntry.value;
                  if (syncObj.containsKey("cats")) {
                    if (syncObj["cats"].containsKey(moduleId.toString())) {
                      if (typeValue.isNotEmpty) {
                        for (var targetEntry in typeValue.entries) {
                          var ids = targetEntry.key;
                          var target = targetEntry.value;
                          double achievement = getBCPachievementByModuleAndType(moduleId, typeId, ids);

                          int imageName = 0;
                          ProductModel? productModel =
                              await _productCategoryServices.getFirstSkuModelForAProductCategoryAndModule(int.parse(moduleId.toString()), int.parse(typeId.toString()), int.parse(ids.toString()));

                          if (productModel != null) {
                            imageName = productModel.id;
                          }

                          SRDetailTargetModel targetModel = SRDetailTargetModel(
                              id: int.parse(ids),
                              name: syncObj["cats"][moduleId.toString()][typeId][ids]["name"],
                              target: target.toInt(),
                              achievement: (achievement * 100).toInt(),
                              imageId: imageName);
                          list.add(targetModel);
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getBCPTargetForASpecificModule SrTargetServices catch block $e, $s");
    }
    return list;
  }

  saveAchievementForASaleData(Map saleData, Map oldSaleData) async {
    try {
      if (saleData.isNotEmpty) {
        for (MapEntry moduleWiseSaleEntry in saleData.entries) {
          if (moduleWiseSaleEntry.value.isNotEmpty) {
            Map moduleWiseSale = moduleWiseSaleEntry.value;
            for (MapEntry skuWiseSaleEntry in moduleWiseSale.entries) {
              if (skuWiseSaleEntry.value.isNotEmpty) {
                Map skuWiseSale = skuWiseSaleEntry.value;
                if (skuWiseSale.containsKey(preorderSttKey)) {
                  int moduleId = int.parse(moduleWiseSaleEntry.key);
                  int skuId = int.parse(skuWiseSaleEntry.key);
                  await saveAchievementForAModuleAndSkuIfTargetExists(moduleId, skuId, skuWiseSale[preorderSttKey], true);
                }
              }
            }
          }
        }
      }

      if (oldSaleData.isNotEmpty) {
        for (MapEntry moduleWiseSaleEntry in oldSaleData.entries) {
          if (moduleWiseSaleEntry.value.isNotEmpty) {
            Map moduleWiseSale = moduleWiseSaleEntry.value;
            for (MapEntry skuWiseSaleEntry in moduleWiseSale.entries) {
              if (skuWiseSaleEntry.value.isNotEmpty) {
                Map skuWiseSale = skuWiseSaleEntry.value;
                if (skuWiseSale.containsKey(preorderSttKey)) {
                  int moduleId = int.parse(moduleWiseSaleEntry.key);
                  int skuId = int.parse(skuWiseSaleEntry.key);
                  await saveAchievementForAModuleAndSkuIfTargetExists(moduleId, skuId, skuWiseSale[preorderSttKey], false);
                }
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside saveAchievementForASaleData srTargetServices catch block $e $s");
    }
  }

  saveAchievementForAModuleAndSkuIfTargetExists(int moduleId, int skuId, int qty, bool add) async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("target_enabled_sbus")) {
          if (syncObj["target_configurations"]["target_enabled_sbus"].contains(moduleId)) {
            if (syncObj["target_configurations"].containsKey("targets")) {
              if (syncObj["target_configurations"]["targets"].containsKey(moduleId.toString())) {
                if (syncObj["target_configurations"]["targets"][moduleId.toString()].containsKey(sttTargetTypeKey)) {
                  Map sttTarget = syncObj["target_configurations"]["targets"][moduleId.toString()][sttTargetTypeKey];
                  if (sttTarget.isNotEmpty) {
                    for (MapEntry srrTargetEntry in sttTarget.entries) {
                      int productCategoryId = int.parse(srrTargetEntry.key.toString());
                      int? productId = await _productCategoryServices.getProductIdForASkuAndModuleAndProductCategory(moduleId, skuId, productCategoryId);
                      int? packSize = await _productCategoryServices.getSkuPackSizeByModuleBySkuId(moduleId, skuId);
                      if (productId != null && packSize != null) {
                        double pack = qty / packSize;
                        if (sttTarget[productCategoryId.toString()].containsKey(productId.toString())) {
                          await saveSttAchievementForAProductIdAndCategory(moduleId, productCategoryId, productId, pack, add);
                        }
                      }
                    }
                  }
                }
                if (syncObj["target_configurations"]["targets"][moduleId.toString()].containsKey(sttSpecialTargetTypeKey)) {
                  Map sttTarget = syncObj["target_configurations"]["targets"][moduleId.toString()][sttSpecialTargetTypeKey];
                  if (sttTarget.isNotEmpty) {
                    for (MapEntry srrTargetEntry in sttTarget.entries) {
                      int productCategoryId = int.parse(srrTargetEntry.key.toString());
                      int? productId = await _productCategoryServices.getProductIdForASkuAndModuleAndProductCategory(moduleId, skuId, productCategoryId);
                      int? packSize = await _productCategoryServices.getSkuPackSizeByModuleBySkuId(moduleId, skuId);
                      if (productId != null && packSize != null) {
                        double pack = qty / packSize;
                        if (sttTarget[productCategoryId.toString()].containsKey(productId.toString())) {
                          await saveSpecialSttAchievementForAProductIdAndCategory(moduleId, productCategoryId, productId, pack, add);
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getProductIdForAModuleAndSkuIfTargetExists catch block $e $s");
    }
  }

  saveSttAchievementForAProductIdAndCategory(int moduleId, int productCategoryId, int productId, double qty, bool add) async {
    try {
      await checkIfSTTTargetKeyExists();
      if (!syncObj[srAchievementKey][sttTargetTypeKey].containsKey(moduleId.toString())) {
        syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()] = {};
      }
      if (!syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()].containsKey(productCategoryId.toString())) {
        syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()][productCategoryId.toString()] = {};
      }

      if (syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()][productCategoryId.toString()].containsKey(productId.toString())) {
        if (add) {
          syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()][productCategoryId.toString()][productId.toString()] += qty;
        } else {
          syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()][productCategoryId.toString()][productId.toString()] -= qty;
          if (syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()][productCategoryId.toString()][productId.toString()] < 0) {
            syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()][productCategoryId.toString()][productId.toString()] = 0;
          }
        }
      } else {
        syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()][productCategoryId.toString()][productId.toString()] = qty;
      }
    } catch (e, s) {
      Helper.dPrint("inside saveSttAchievementForAProductIdAndCategory srTargetServices catch block $e $s");
    }
  }

  saveSpecialSttAchievementForAProductIdAndCategory(int moduleId, int productCategoryId, int productId, double qty, bool add) async {
    try {
      await checkIfSpecialSTTTargetKeyExists();
      if (!syncObj[srAchievementKey][sttSpecialTargetTypeKey].containsKey(moduleId.toString())) {
        syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()] = {};
      }
      if (!syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()].containsKey(productCategoryId.toString())) {
        syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()][productCategoryId.toString()] = {};
      }

      if (syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()][productCategoryId.toString()].containsKey(productId.toString())) {
        if (add) {
          syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()][productCategoryId.toString()][productId.toString()] += qty;
        } else {
          syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()][productCategoryId.toString()][productId.toString()] -= qty;
          if (syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()][productCategoryId.toString()][productId.toString()] < 0) {
            syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()][productCategoryId.toString()][productId.toString()] = 0;
          }
        }
      } else {
        syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()][productCategoryId.toString()][productId.toString()] = qty;
      }
    } catch (e, s) {
      Helper.dPrint("inside saveSttAchievementForAProductIdAndCategory srTargetServices catch block $e $s");
    }
  }

  checkIfSpecialSTTTargetKeyExists() async {
    try {
      await _syncService.checkSyncVariable();
      if (!syncObj.containsKey(srAchievementKey)) {
        syncObj[srAchievementKey] = {};
      }

      if (!syncObj[srAchievementKey].containsKey(sttSpecialTargetTypeKey)) {
        syncObj[srAchievementKey][sttSpecialTargetTypeKey] = {};
      }
    } catch (e) {
      Helper.dPrint("inside checkIfSTTTargetKeyExists SRTargetServices catch block $e");
    }
  }

  checkIfSTTTargetKeyExists() async {
    try {
      await _syncService.checkSyncVariable();
      if (!syncObj.containsKey(srAchievementKey)) {
        syncObj[srAchievementKey] = {};
      }

      if (!syncObj[srAchievementKey].containsKey(sttTargetTypeKey)) {
        syncObj[srAchievementKey][sttTargetTypeKey] = {};
      }
    } catch (e) {
      Helper.dPrint("inside checkIfSTTTargetKeyExists SRTargetServices catch block $e");
    }
  }

  double getSTTAchievementByModuleAndType(int moduleId, String typeId, String skuTypeID) {
    try {
      if (syncObj.containsKey(srAchievementKey)) {
        if (syncObj[srAchievementKey].containsKey(sttTargetTypeKey)) {
          if (syncObj[srAchievementKey][sttTargetTypeKey].containsKey(moduleId.toString())) {
            if (syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()].containsKey(typeId)) {
              if (syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()][typeId].containsKey(skuTypeID)) {
                return double.parse(syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()][typeId][skuTypeID].toString());
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getSTTAchievementByModuleAndType SRTargetServices catch block $e $s");
    }
    return 0;
  }

  double getSpecialSTTAchievementByModuleAndType(int moduleId, String typeId, String skuTypeID) {
    try {
      if (syncObj.containsKey(srAchievementKey)) {
        if (syncObj[srAchievementKey].containsKey(sttSpecialTargetTypeKey)) {
          if (syncObj[srAchievementKey][sttSpecialTargetTypeKey].containsKey(moduleId.toString())) {
            if (syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()].containsKey(typeId)) {
              if (syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()][typeId].containsKey(skuTypeID)) {
                return double.parse(syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()][typeId][skuTypeID].toString());
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getSTTAchievementByModuleAndType SRTargetServices catch block $e $s");
    }
    return 0;
  }

  // int getTotalSTTAchievements(int moduleId){
  //   int total = 0;
  //   try {
  //     if (syncObj.containsKey(srAchievementKey)) {
  //       if (syncObj[srAchievementKey].containsKey(sttTargetTypeKey)) {
  //         if (syncObj[srAchievementKey][sttTargetTypeKey].containsKey(moduleId.toString())) {
  //           for(MapEntry typeData in syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()].entries){
  //             Map productMap = typeData.value;
  //             for(MapEntry product in productMap.entries){
  //               total += product.value as int;
  //             }
  //           }
  //         }
  //       }
  //     }
  //   } catch (e, s) {
  //     Helper.dPrint("inside getTotalSTTTargets SRTargetServices catch block $e $s");
  //   }
  //   return total;
  // }

  // int getTotalSTTTargets(int moduleId){
  //   int total = 0;
  //   try {
  //     if (syncObj.containsKey("target_configurations")) {
  //       if (syncObj["target_configurations"].containsKey("targets")) {
  //         if (syncObj["target_configurations"]["targets"].containsKey(moduleId.toString())) {
  //           if(syncObj["target_configurations"]["targets"][moduleId.toString()].containsKey("STT")){
  //             for(MapEntry typeData in syncObj["target_configurations"]["targets"][moduleId.toString()]["STT"].entries){
  //               Map productMap = typeData.value;
  //               for(MapEntry product in productMap.entries){
  //                 total += product.value as int;
  //               }
  //             }
  //           }
  //         }
  //       }
  //     }
  //   } catch (e, s) {
  //     Helper.dPrint("inside getTotalSTTTargets SRTargetServices catch block $e $s");
  //   }
  //   return total;
  // }

  double getBCPachievementByModuleAndType(int moduleId, String typeId, String skuTypeID) {
    try {
      if (syncObj.containsKey(srAchievementKey)) {
        if (syncObj[srAchievementKey].containsKey(bcpTargetTypeKey)) {
          if (syncObj[srAchievementKey][bcpTargetTypeKey].containsKey(moduleId.toString())) {
            if (syncObj[srAchievementKey][bcpTargetTypeKey][moduleId.toString()].containsKey(typeId)) {
              if (syncObj[srAchievementKey][bcpTargetTypeKey][moduleId.toString()][typeId].containsKey(skuTypeID)) {
                return syncObj[srAchievementKey][bcpTargetTypeKey][moduleId.toString()][typeId][skuTypeID].toDouble();
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getSTTAchievementByModuleAndType SRTargetServices catch block $e $s");
    }
    return 0;
  }

  Future<double> getTotalSTTAchievementByModuleAndType(int moduleId) async {
    double res = 0;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(srAchievementKey)) {
        if (syncObj[srAchievementKey].containsKey(sttTargetTypeKey)) {
          if (syncObj[srAchievementKey][sttTargetTypeKey].containsKey(moduleId.toString())) {
            syncObj[srAchievementKey][sttTargetTypeKey][moduleId.toString()].forEach((typeId, typeAchievements) {
              typeAchievements.forEach((id, value) {
                res += double.parse(value.toString());
              });
            });
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getTotalSTTAchievementByModuleAndType SRTargetServices catch block $e $s");
    }

    return res;
  }

  Future<double> getTotalSpecialSTTAchievementByModuleAndType(int moduleId) async {
    double res = 0;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(srAchievementKey)) {
        if (syncObj[srAchievementKey].containsKey(sttSpecialTargetTypeKey)) {
          if (syncObj[srAchievementKey][sttSpecialTargetTypeKey].containsKey(moduleId.toString())) {
            syncObj[srAchievementKey][sttSpecialTargetTypeKey][moduleId.toString()].forEach((typeId, typeAchievements) {
              typeAchievements.forEach((id, value) {
                res += double.parse(value.toString());
              });
            });
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getTotalSTTAchievementByModuleAndType SRTargetServices catch block $e $s");
    }

    return res;
  }

  Future<int> getTotalSTTTargetForASpecificModule(int moduleId) async {
    int res = 0;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("targets")) {
          if (syncObj["target_configurations"]["targets"].containsKey(moduleId.toString())) {
            if (syncObj["target_configurations"]["targets"][moduleId.toString()].containsKey(sttTargetTypeKey)) {
              if (syncObj["target_configurations"]["targets"][moduleId.toString()][sttTargetTypeKey].isNotEmpty) {
                syncObj["target_configurations"]["targets"][moduleId.toString()]["STT"].forEach((typeId, typeValue) {
                  typeValue.forEach((ids, target) {
                    res += target as int;
                  });
                });
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getSTTTargetForASpecificModule SrTargetServices catch block $e, $s");
    }
    return res;
  }

  Future<int> getTotalSpecialSTTTargetForASpecificModule(int moduleId) async {
    int res = 0;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("targets")) {
          if (syncObj["target_configurations"]["targets"].containsKey(moduleId.toString())) {
            if (syncObj["target_configurations"]["targets"][moduleId.toString()].containsKey(sttSpecialTargetTypeKey)) {
              if (syncObj["target_configurations"]["targets"][moduleId.toString()][sttSpecialTargetTypeKey].isNotEmpty) {
                syncObj["target_configurations"]["targets"][moduleId.toString()][sttSpecialTargetTypeKey].forEach((typeId, typeValue) {
                  typeValue.forEach((ids, target) {
                    res += target as int;
                  });
                });
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getSTTTargetForASpecificModule SrTargetServices catch block $e, $s");
    }
    return res;
  }

  Future<int> getTotalManualOverrid() async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(manualOverrideKey)) {
        if (syncObj[manualOverrideKey].isNotEmpty) {
          return syncObj[manualOverrideKey].length;
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside TargetService getTotalManualOverrid $e, $s");
    }
    return 0;
  }

  checkBCPData(String moduleId, String typeId) {
    try {
      if (!syncObj.containsKey(srAchievementKey)) {
        syncObj[srAchievementKey] = {};
      }
      if (!syncObj[srAchievementKey].containsKey(bcpTargetTypeKey)) {
        syncObj[srAchievementKey][bcpTargetTypeKey] = {};
      }
      if (!syncObj[srAchievementKey][bcpTargetTypeKey].containsKey(moduleId)) {
        syncObj[srAchievementKey][bcpTargetTypeKey][moduleId] = {};
      }
      if (!syncObj[srAchievementKey][bcpTargetTypeKey][moduleId].containsKey(typeId)) {
        syncObj[srAchievementKey][bcpTargetTypeKey][moduleId][typeId] = {};
      }
    } catch (e, s) {
      Helper.dPrint("inside SRTargetService checkBCPData $e, $s");
    }
  }

  Map bcpTarget(String moduleId, String parentsCategoryId) {
    // {
    //    42: 1,
    //    41: 1
    // }
    try {
      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("targets")) {
          if (syncObj["target_configurations"]["targets"].containsKey(moduleId.toString())) {
            if (syncObj["target_configurations"]["targets"][moduleId.toString()].containsKey(bcpTargetTypeKey)) {
              if (syncObj["target_configurations"]["targets"][moduleId.toString()][bcpTargetTypeKey].isNotEmpty) {
                Map allBCPTargets = syncObj["target_configurations"]["targets"][moduleId.toString()][bcpTargetTypeKey];
                if (allBCPTargets.containsKey(parentsCategoryId)) {
                  return allBCPTargets[parentsCategoryId];
                }
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside SRTargetService bcpTargets $e, $s");
    }
    return {};
  }

  String getProductSkuIdFromParents(String moduleId, String productTypeId, String productCategoryTypeId) {
    try {
      if (syncObj.containsKey("cats")) {
        if (syncObj["cats"].containsKey(moduleId)) {
          for (MapEntry sku in syncObj["cats"][moduleId]["10"].entries) {
            String skuId = sku.key.toString();
            Map skuMap = sku.value;
            if (skuMap.containsKey("parents")) {
              if (skuMap["parents"].containsKey(productCategoryTypeId)) {
                if (skuMap["parents"][productCategoryTypeId].toString() == productTypeId) {
                  return skuId;
                }
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside SRTargetService getProductParentsFromSku $e, $s");
    }
    return "";
  }

  saveBCPBytType() async {
    try {
      await _syncService.checkSyncVariable();
      Map<String, dynamic> achievementData = await getSKUsAmountFromParents();
      int totalRetailers = await SalesService().getTotalRetailer(saleType: SaleType.preorder);
      for (MapEntry moduleData in achievementData.entries) {
        String moduleId = moduleData.key.toString();
        Map amountByCategoryMap = moduleData.value;
        for (MapEntry amountByCategory in amountByCategoryMap.entries) {
          String parentsCategoryId = amountByCategory.key.toString();
          Map amountByParentsMap = amountByCategory.value;
          for (MapEntry amountByParents in amountByParentsMap.entries) {
            String parentId = amountByParents.key.toString();
            int amount = amountByParents.value;
            double bcp = amount / totalRetailers;
            checkBCPData(moduleId, parentsCategoryId);
            syncObj[srAchievementKey][bcpTargetTypeKey][moduleId][parentsCategoryId][parentId] = bcp;
          }
        }
      }

      await _syncService.writeSync(jsonEncode(syncObj));
    } catch (e, s) {
      Helper.dPrint("inside SRTargetService saveBCPBytType $e, $s");
    }
  }

  Map<String, dynamic> getSaleDataByRetailer() {
    Map<String, dynamic> achievementDataBySKU = {};
    try {
      Map saleDataMap = syncObj[preorderKey];
      Map<String, String> targetSKUCategoryType = getBCPSKUCategoryTypeIdForBCP();
      for (MapEntry saleData in saleDataMap.entries) {
        String retailerId = saleData.key.toString();
        Map saleModuleMap = saleData.value;
        for (MapEntry module in saleModuleMap.entries) {
          String moduleId = module.key.toString();
          if (targetSKUCategoryType.containsKey(moduleId)) {
            Map skuMap = module.value;
            for (MapEntry sku in skuMap.entries) {
              String skuId = sku.key.toString();
              if (!achievementDataBySKU.containsKey(moduleId)) {
                achievementDataBySKU[moduleId] = {};
              }
              if (achievementDataBySKU[moduleId].containsKey(skuId)) {
                achievementDataBySKU[moduleId][skuId] = 1 + achievementDataBySKU[moduleId][skuId]!;
              } else {
                achievementDataBySKU[moduleId][skuId] = 1;
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside SRTargetService getSaleDataByRetailer $e, $s");
    }

    return achievementDataBySKU;
  }

  Future<Map<String, dynamic>> getRetailersByParent() async {
    Map<String, dynamic> achievementDataBySKU = {};
    try {
      Map saleDataMap = syncObj[preorderKey];
      Map<String, String> targetSKUCategoryType = getBCPSKUCategoryTypeIdForBCP();
      for (MapEntry saleData in saleDataMap.entries) {
        String retailerId = saleData.key.toString();
        Map saleModuleMap = saleData.value;
        for (MapEntry module in saleModuleMap.entries) {
          String moduleId = module.key.toString();
          if (targetSKUCategoryType.containsKey(moduleId)) {
            Map skuMap = module.value;
            String parentCategoryId = targetSKUCategoryType[moduleId]!;
            for (MapEntry sku in skuMap.entries) {
              String skuId = sku.key.toString();
              int? parentId = await _productCategoryServices.getProductIdForASkuAndModuleAndProductCategory(int.parse(moduleId), int.parse(skuId), int.parse(parentCategoryId));

              if (!achievementDataBySKU.containsKey(parentId.toString())) {
                achievementDataBySKU[parentId.toString()] = [];
              }

              if (!achievementDataBySKU[parentId.toString()].contains(retailerId)) {
                achievementDataBySKU[parentId.toString()].add(retailerId);
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside SRTargetService getSkuAmountByRetailer $e, $s");
    }
    return achievementDataBySKU;
  }

  Future<Map<String, dynamic>> getSKUsAmountFromParents() async {
    Map<String, dynamic> achievementDataByParents = {};
    try {
      Map<String, String> targetSKUCategoryType = getBCPSKUCategoryTypeIdForBCP();
      Map<String, dynamic> achievementDataBySKU = getSaleDataByRetailer();
      Map<String, dynamic> parentWiseRetailer = await getRetailersByParent();
      for (MapEntry moduleByParentsId in targetSKUCategoryType.entries) {
        String moduleId = moduleByParentsId.key.toString();
        String parentsCategoryId = moduleByParentsId.value.toString(); // 10,9,8,7,6
        if (achievementDataBySKU.containsKey(moduleId)) {
          Map targetedProductTypeIds = bcpTarget(moduleId, parentsCategoryId);
          for (MapEntry moduleWiseSku in achievementDataBySKU[moduleId].entries) {
            String skuId = moduleWiseSku.key.toString();
            int skuAmount = moduleWiseSku.value;

            int? parentId = await _productCategoryServices.getProductIdForASkuAndModuleAndProductCategory(int.parse(moduleId), int.parse(skuId), int.parse(parentsCategoryId));
            // 42, 45,46,47
            if (parentId != null) {
              if (targetedProductTypeIds.containsKey(parentId.toString())) {
                if (!achievementDataByParents.containsKey(moduleId)) {
                  achievementDataByParents[moduleId] = {};
                }
                if (!achievementDataByParents[moduleId].containsKey(parentsCategoryId)) {
                  achievementDataByParents[moduleId][parentsCategoryId] = {};
                }
                if (!achievementDataByParents[moduleId][parentsCategoryId].containsKey(parentId.toString())) {
                  achievementDataByParents[moduleId][parentsCategoryId][parentId.toString()] = parentWiseRetailer[parentId.toString()].length;
                }
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside SRTargetService getSKUsAmountFromParents $e, $s");
    }

    return achievementDataByParents;
  }

  Map<String, String> getBCPSKUCategoryTypeIdForBCP() {
    // 10,9,8,7,6
    Map<String, String> targetSKUCategoryType = {};
    try {
      if (syncObj.containsKey('target_configurations')) {
        if (syncObj['target_configurations'].containsKey('targets')) {
          for (MapEntry bcpType in syncObj['target_configurations']['targets'].entries) {
            String module = bcpType.key.toString();
            if (syncObj['target_configurations']['targets'][module].containsKey('BCP')) {
              for (MapEntry bcpCat in syncObj['target_configurations']['targets'][module]['BCP'].entries) {
                targetSKUCategoryType[module] = bcpCat.key.toString();
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside SRTargetService getBCPSKUCategoryTypeIdForBCP $e, $s");
    }

    return targetSKUCategoryType;
  }

  int getTotalBCPProductAmount(int moduleId) {
    try {
      if (syncObj.containsKey('target_configurations')) {
        if (syncObj['target_configurations'].containsKey('targets')) {
          for (MapEntry bcpType in syncObj['target_configurations']['targets'].entries) {
            if (syncObj['target_configurations']['targets'][moduleId.toString()].containsKey('BCP')) {
              for (MapEntry bcpMap in syncObj['target_configurations']['targets'][moduleId.toString()]['BCP'].entries) {
                Map productMap = bcpMap.value;
                return productMap.length;
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside SRTargetService getTotalBCPProductAmount $e, $s");
    }
    return 0;
  }

  createTempMap(String moduleId, String parentCategoryId, String parentId) {
    Map tempMapForParetnsId = {};
    if (!tempMapForParetnsId.containsKey(moduleId)) {
      tempMapForParetnsId[moduleId] = {};
    }
    if (!tempMapForParetnsId[moduleId].containsKey(parentCategoryId)) {
      tempMapForParetnsId[moduleId][parentCategoryId] = {};
    }
    if (!tempMapForParetnsId[moduleId][parentCategoryId].containsKey(parentId)) {
      tempMapForParetnsId[moduleId][parentCategoryId][parentId] = {};
    }
  }

  Future<double> getBCPTotalAchievements(int moduleId) async {
    try {
      await _syncService.checkSyncVariable();
      Map<String, String> targetSKUCategoryType = getBCPSKUCategoryTypeIdForBCP();
      if (syncObj.containsKey(srAchievementKey)) {
        if (syncObj[srAchievementKey].containsKey(bcpTargetTypeKey)) {
          if (syncObj[srAchievementKey][bcpTargetTypeKey].isNotEmpty) {
            if (syncObj[srAchievementKey][bcpTargetTypeKey].containsKey(moduleId.toString())) {
              String parentCategoryId = targetSKUCategoryType[moduleId.toString()]!.toString();
              double res = 0.0;

              for (MapEntry srBCP in syncObj[srAchievementKey][bcpTargetTypeKey][moduleId.toString()][parentCategoryId].entries) {
                res += double.parse(srBCP.value.toString());
              }
              if (syncObj[srAchievementKey][bcpTargetTypeKey][moduleId.toString()][parentCategoryId].isNotEmpty) {
                int total = getTotalBCPProductAmount(moduleId);
                return (res) / total;
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside SRTargetService getBCPTotalAchievements $e, $s");
    }
    return 0.0;
  }

  Future<double> getMinimumTargetRate(String label, int moduleId) async {
    try {
      await SyncService().checkSyncVariable();

      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("targets")) {
          if (syncObj["target_configurations"]["targets"].containsKey(moduleId.toString())) {
            if (syncObj["target_configurations"]["targets"][moduleId.toString()].containsKey(label)) {
              if (syncObj["target_configurations"]["targets"][moduleId.toString()][label] is double) {
                return syncObj["target_configurations"]["targets"][moduleId.toString()][label];
              } else if (syncObj["target_configurations"]["targets"][moduleId.toString()][label] is int) {
                return double.parse(syncObj["target_configurations"]["targets"][moduleId.toString()][label].toString());
              } else if (syncObj["target_configurations"]["targets"][moduleId.toString()][label] is Map) {
                return 100;
              } else {
                return 0;
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside Dashboard service getMinimumTargetRate error $e, $s");
    }
    return 0.0;
  }

  Future<List<DashboardTargetModel>> getDashBoardTarget(int moduleId) async {
    List<DashboardTargetModel> list = [];
    try {
      await SyncService().checkSyncVariable();
      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("sbu_wise_available_targets")) {
          if (syncObj["target_configurations"]["sbu_wise_available_targets"].containsKey(moduleId.toString())) {
            for (var label in syncObj["target_configurations"]["sbu_wise_available_targets"][moduleId.toString()]) {
              double minimumTarget = await getMinimumTargetRate(label, moduleId);
              if (minimumTarget > 0.0) {
                double current = 0;
                if (label == "STT") {
                  int totalSttTarget = await SrTargetServices().getTotalSTTTargetForASpecificModule(moduleId);

                  ///int totalSttTarget = 2500; 01819743813
                  double totalSttAchievementByPiece = await SrTargetServices().getTotalSTTAchievementByModuleAndType(moduleId);

                  current = (totalSttAchievementByPiece * 100) / totalSttTarget;
                } else if (label == "Special Target") {
                  int totalSttTarget = await SrTargetServices().getTotalSpecialSTTTargetForASpecificModule(moduleId);
                  double totalSttAchievement = await SrTargetServices().getTotalSpecialSTTAchievementByModuleAndType(moduleId);
                  Helper.dPrint("$label $totalSttTarget $totalSttAchievement");
                  current = (totalSttAchievement * 100) / totalSttTarget;
                } else if (label == "Geo Fencing") {
                  int manualOverrid = await SrTargetServices().getTotalManualOverrid();
                  int totalVisitedOutlet = await SalesService().getTotalRetailer(saleType: SaleType.preorder);
                  if (totalVisitedOutlet != 0) {
                    current = (totalVisitedOutlet - manualOverrid) * 100 / totalVisitedOutlet;
                  } else {
                    current = 0;
                  }
                } else if (label == "BCP") {
                  double bcp = await SrTargetServices().getBCPTotalAchievements(moduleId);
                  current = bcp * 100;
                }
                DashboardTargetModel targets = DashboardTargetModel(label: label, current: current, minimumTarget: minimumTarget);
                list.add(targets);
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside Dashboard service ifTargetEnabled error $e, $s");
    }
    return list;
  }

  Future<List<DashboardTargetModelOverall>> getDashBoardTargetFullValue(int moduleId) async {
    List<DashboardTargetModelOverall> list = [];
    try {
      await SyncService().checkSyncVariable();
      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("sbu_wise_available_targets")) {
          if (syncObj["target_configurations"]["sbu_wise_available_targets"].containsKey(moduleId.toString())) {
            for (var label in syncObj["target_configurations"]["sbu_wise_available_targets"][moduleId.toString()]) {
              double minimumTarget = await getMinimumTargetRate(label, moduleId);
              if (minimumTarget > 0.0) {
                int target = 0;
                double achieved = 0;
                if (label == "STT") {
                  target = await SrTargetServices().getTotalSTTTargetForASpecificModule(moduleId);

                  ///int totalSttTarget = 2500; 01819743813
                  achieved = await SrTargetServices().getTotalSTTAchievementByModuleAndType(moduleId);
                } else if (label == "Special Target") {
                  target = await SrTargetServices().getTotalSpecialSTTTargetForASpecificModule(moduleId);
                  achieved = await SrTargetServices().getTotalSpecialSTTAchievementByModuleAndType(moduleId);
                }
                // else if(label == "Geo Fencing"){
                //   int manualOverrid = await SrTargetServices().getTotalManualOverrid();
                //   int totalVisitedOutlet = await SalesService().getTotalRetailer();
                //   if(totalVisitedOutlet != 0){
                //     current = (totalVisitedOutlet - manualOverrid) * 100 / totalVisitedOutlet;
                //   }
                //   else {
                //     current = 0;
                //   }
                //
                // }
                // else if(label == "BCP"){
                //   double bcp = await SrTargetServices().getBCPTotalAchievements(moduleId);
                //   current = bcp * 100;
                //
                // }
                DashboardTargetModelOverall targets = DashboardTargetModelOverall(label: label, target: target, achieved: achieved);
                list.add(targets);
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside Dashboard service ifTargetEnabled error $e, $s");
    }
    return list;
  }

  Future<List> getDetailsTabList(int moduleId) async {
    try {
      await SyncService().checkSyncVariable();
      if (syncObj.containsKey("target_configurations")) {
        if (syncObj["target_configurations"].containsKey("sbu_wise_available_targets")) {
          if (syncObj["target_configurations"]["sbu_wise_available_targets"].containsKey(moduleId.toString())) {
            return syncObj["target_configurations"]["sbu_wise_available_targets"][moduleId.toString()];
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside Dashboard service getDetailsTabList error $e, $s");
    }
    return [];
  }
}
