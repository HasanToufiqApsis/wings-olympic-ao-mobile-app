import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:wings_olympic_sr/models/cluster_model.dart';

import '../api/global_http.dart';
import '../api/links.dart';
import '../api/retailer_api.dart';
import '../constants/constant_keys.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/general_id_slug_model.dart';
import '../models/outlet_model.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import '../utils/sales_type_utils.dart';
import 'delivery_services.dart';
import 'ff_services.dart';
import 'helper.dart';
import 'sales_service.dart';
import 'shared_storage_services.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class OutletServices {
  final SyncService _syncService = SyncService();
  final FFServices _ffServices = FFServices();
  final DeliveryServices _deliveryServices = DeliveryServices();
  final SyncReadService _syncReadService = SyncReadService();

  Future<List<GeneralIdSlugModel>> getBusinessTypeList() async {
    return await getIdSlugModelList("business_types");
  }

  Future<List<GeneralIdSlugModel>> getChannelCategoryList() async {
    return await getIdSlugModelList("channel_categories");
  }

  Future<List<GeneralIdSlugModel>> getCoolerList() async {
    return await getIdSlugModelList("coolers");
  }

  Future<List<GeneralIdSlugModel>> getIdSlugModelList(String key) async {
    List<GeneralIdSlugModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("outlet_onboarding_configurations")) {
        if (syncObj["outlet_onboarding_configurations"].containsKey(key)) {
          List types = syncObj["outlet_onboarding_configurations"][key];
          if (types.isNotEmpty) {
            for (Map type in types) {
              list.add(GeneralIdSlugModel.fromJson(type));
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint(
        "inside getIdSlugModelList OutletServices catch block $e, $s",
      );
    }
    return list;
  }

  Future<bool> inactiveOutlet({
    required OutletModel outletModel,
    required String reason,
  }) async {
    try {
      await _syncService.checkSyncVariable();
      if (outletModel.id == null) {
        /// new outlet
        if (syncObj.containsKey(onboardingOutletInfoKey)) {
          if (syncObj[onboardingOutletInfoKey].containsKey(
            onboardingNewOutletKey,
          )) {
            for (MapEntry outletInfo
                in syncObj[onboardingOutletInfoKey][onboardingNewOutletKey]
                    .entries) {
              String outletCode = outletInfo.key.toString();
              if (outletCode == outletModel.outletCode) {
                syncObj[onboardingOutletInfoKey][onboardingNewOutletKey].remove(
                  outletCode,
                );
                break;
              }
            }
          }
        }
      } else {
        if (!syncObj.containsKey(onboardingOutletInfoKey)) {
          syncObj[onboardingOutletInfoKey] = {};
        }
        if (!syncObj[onboardingOutletInfoKey].containsKey(
          onboardingInactiveOutletKey,
        )) {
          syncObj[onboardingOutletInfoKey][onboardingInactiveOutletKey] = {};
        }
        if (!syncObj[onboardingOutletInfoKey][onboardingInactiveOutletKey]
            .containsKey(outletModel.outletCode.toString())) {
          syncObj[onboardingOutletInfoKey][onboardingInactiveOutletKey][outletModel
                  .outletCode
                  .toString()] =
              {};
        }
        syncObj[onboardingOutletInfoKey][onboardingInactiveOutletKey][outletModel
            .outletCode
            .toString()] = {
          onboardingInactiveOutletCodeKey: outletModel.outletCode,
          onboardingInactiveReasonKey: reason,
        };
        ReturnedDataModel returnedDataModel = await RetailerApi().bulkDisable([
          outletModel.outletCode,
        ]);
        // if(returnedDataModel.status == ReturnedStatus.success){
        //   syncObj[onboardingOutletInfoKey][onboardingInactiveOutletKey].remove(outletModel.outletCode.toString());
        // }
      }
      await _syncService.writeSync();

      return true;
    } catch (e, s) {
      Helper.dPrint("inside inactiveOutlet OutletServices catch block $e $s");
    }
    return false;
  }

  bool checkRetailer(String outletCode) {
    if (syncObj.containsKey(onboardingOutletInfoKey)) {
      if (syncObj[onboardingOutletInfoKey].containsKey(
        onboardingInactiveOutletKey,
      )) {
        return syncObj[onboardingOutletInfoKey][onboardingInactiveOutletKey]
            .containsKey(outletCode.toString());
      }
    }
    return false;
  }

  OutletModel? checkUpdatedOutlet(String outletModelId) {
    if (syncObj.containsKey(onboardingOutletInfoKey)) {
      if (syncObj[onboardingOutletInfoKey].containsKey(
        onboardingNewOutletKey,
      )) {
        if (syncObj[onboardingOutletInfoKey][onboardingNewOutletKey]
            .containsKey(outletModelId.toString())) {
          return OutletModel.fromJson(
            syncObj[onboardingOutletInfoKey][onboardingNewOutletKey][outletModelId],
          );
        }
      }
    }
    return null;
  }

  Future<OutletModel?> getOutletBuId(int outletModelId) async {
    final outlets = await getOutletList(false);
    for (final outlet in outlets) {
      if (outlet.id == outletModelId) {
        return outlet;
      }
    }
    return null;
  }

  Future<bool> checkIfAllOutletSynced() async {
    bool synced = true;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(onboardingOutletInfoKey)) {
        if (syncObj[onboardingOutletInfoKey].containsKey(
          onboardingNewOutletKey,
        )) {
          synced =
              syncObj[onboardingOutletInfoKey][onboardingNewOutletKey].isEmpty;
        }
      }
    } catch (e) {
      Helper.dPrint(
        "inside checkIfAllOutletSynced OutletServices catch block $e",
      );
    }
    return synced;
  }

  Future<int> getMemoCountBySaleType({required SaleType saleType}) async {
    try {
      await _syncService.checkSyncVariable();

      final dataKey = saleType == SaleType.preorder
          ? preorderKey
          : saleType == SaleType.delivery
          ? deliveryKey
          : spotSaleKey;
      return syncObj[dataKey]?.length ?? 0;
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return 0;
  }

  Future<List<OutletModel>> getOrderedOutletList({
    required SaleType saleType,
  }) async {
    final result = <OutletModel>[];
    try {
      final dataKey = saleType == SaleType.preorder
          ? preorderKey
          : saleType == SaleType.delivery
          ? deliveryKey
          : spotSaleKey;
      final retailerList = await getOutletList(true);

      final saleData = syncObj[dataKey] as Map?;

      if (saleData == null) return [];

      for (var out in retailerList) {
        if (saleData.containsKey(out.id.toString())) {
          result.add(out);
        }
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return result;
  }

  Future<List<OutletModel>> getOutletList(
    bool liveOnly, {
    bool forMemo = false,
  }) async {
    List<OutletModel> outlets = [];
    List<OutletModel> preOrderedOutlets = [];
    List<OutletModel> spotSaleOutlets = [];
    List<OutletModel> zeroOrderedOutlets = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(onboardingOutletInfoKey) && !liveOnly) {
        if (syncObj[onboardingOutletInfoKey].containsKey(
          onboardingNewOutletKey,
        )) {
          // print(syncObj[onboardingOutletInfoKey][onboardingNewOutletKey]);
          for (MapEntry outletInfo
              in syncObj[onboardingOutletInfoKey][onboardingNewOutletKey]
                  .entries) {
            String timestamp = outletInfo.key.toString();
            Map outletInfoJson = outletInfo.value;
            OutletModel outletModel = OutletModel.fromJson(outletInfoJson);
            outlets.add(outletModel);
          }
        }
      }
      if (syncObj.containsKey("retailers")) {
        if (syncObj["retailers"].isNotEmpty) {
          for (Map retailer in syncObj["retailers"]) {
            bool exist = checkRetailer(retailer[onboardingOutletCodeKey]??"");
            // log(retailer.toString());
            if (!exist) {
              OutletModel? outletModel = checkUpdatedOutlet(
                retailer[onboardingOutletCodeKey].toString(),
              );
              if (outletModel == null) {
                outletModel = OutletModel.fromJson(retailer);
                bool hasPreOrdered = await SalesService()
                    .checkRetailerHasTakenPreorder(outletModel.id!);
                bool hasSpotSales = await SalesService()
                    .checkRetailerHasSpotSales(outletModel.id!);
                bool hasZeroSell = await SalesService().checkZeroSell(
                  outletModel.id!,
                );
                outletModel.hasPreOrdered = hasPreOrdered || hasZeroSell;
                outletModel.hasZeroSales = hasZeroSell;
                if (hasPreOrdered || hasSpotSales) {
                  preOrderedOutlets.add(outletModel);
                } else if (hasZeroSell) {
                  zeroOrderedOutlets.add(outletModel);
                } else {
                  outlets.add(outletModel);
                }
              }
              // OutletModel o = OutletModel.fromJson(retailer);
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getOutletList OutletServices catch block $e $s");
    }
    List<OutletModel> finalOutlet = forMemo
        ? preOrderedOutlets
        : [...outlets, ...preOrderedOutlets, ...zeroOrderedOutlets];

    return finalOutlet;
  }

  //delivery outlet list
  Future<List<OutletModel>> getDeliveryOutletList({bool all = false}) async {
    List<OutletModel> outlets = [];
    try {
      await _syncService.checkSyncVariable();

      if (syncObj.containsKey("delivery_configurations")) {
        if (syncObj["delivery_configurations"]["retailers"].isNotEmpty) {
          for (Map? retailer
              in syncObj["delivery_configurations"]["retailers"]) {
            if (retailer != null) {
              bool done = await _deliveryServices
                  .checkIfDeliveryDoneForARetailer(retailer["id"] ?? 0);
              if (!done || all) {
                OutletModel outletModel = OutletModel.fromJson(retailer);
                outlets.add(outletModel);
              }
            }

            // bool exist = checkRetailer(retailer[onboardingOutletCodeKey]);
            // // log(retailer.toString());
            // if(!exist){
            //   OutletModel? outletModel = checkUpdatedOutlet(retailer[onboardingOutletCodeKey].toString());
            //   if(outletModel == null){
            //
            //   }
            // }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getOutletList OutletServices catch block $e");
      Helper.dPrint("inside getOutletList OutletServices catch block $s");
    }
    return [...outlets];
  }

  Future<bool> getDeliveryAvailableThisOutlet({
    required OutletModel outlet,
  }) async {
    try {
      await _syncService.checkSyncVariable();

      if (syncObj.containsKey("delivery_configurations")) {
        if (syncObj["delivery_configurations"]["retailers"].isNotEmpty) {
          for (Map? retailer
              in syncObj["delivery_configurations"]["retailers"]) {
            if (retailer != null) {
              int id = retailer["id"] ?? 0;
              if (id == outlet.id) {
                bool done = await _deliveryServices
                    .checkIfDeliveryDoneForARetailer(retailer["id"] ?? 0);
                if (!done) {
                  return true;
                }
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getOutletList OutletServices catch block $e");
      Helper.dPrint("inside getOutletList OutletServices catch block $s");
    }
    return false;
  }

  updateNewOutlet(String outletCode, OutletModel outletModel) async {
    try {
      Map outletMap = {
        onboardingClusterKey: outletModel.cluster?.toJson()??{},
        onboardingOutletCodeKey: outletCode,
        onboardingOutletNameKey: outletModel.name,
        onboardingOutletNameBnKey: outletModel.nameBn,
        onboardingOutletCoverPhotoPathKey: outletModel.outletCoverImage?.image,
        onboardingOwnerNameKey: outletModel.owner,
        onboardingContactNumberKey: outletModel.contact,
        onboardingNIDNumberKey: outletModel.nid,
        onboardingAddressKey: outletModel.address,
        onboardingNewOutletNumKey: outletModel.newOutletIndex,
        onboardingHasSyncedKey: false,
        onboardingLatitudeKey: outletModel.outletLocation.latitude,
        onboardingLongitudeKey: outletModel.outletLocation.longitude,
        onboardingAvailableOnboardingInfoKey: {
          onboardingBusinessTypeKey: outletModel
              .availableOnboardingInfo
              ?.businessType
              ?.toJson(),
          onboardingChannelCategoryKey: outletModel
              .availableOnboardingInfo
              ?.channelCategory
              ?.toJson(),
          onboardingCoolerStatusKey:
              outletModel.availableOnboardingInfo?.coolerStatus,
          onboardingCoolerKey: outletModel.availableOnboardingInfo?.cooler
              ?.toJson(),
          onboardingCoolerImagePathKey:
              outletModel.availableOnboardingInfo?.coolerPhotoImage?.image,
        },
      };
      syncObj[onboardingOutletInfoKey][onboardingNewOutletKey][outletCode] =
          outletMap;
      await _syncService.writeSync();
      bool done = await sendNewOutletInfoToApi(
        outletMap,
        SendOutletInfoType.edit,
        outletCode,
      );
      syncObj[onboardingOutletInfoKey][onboardingNewOutletKey][outletCode][onboardingHasSyncedKey] =
          done;
      // if(done){
      //   syncObj[onboardingOutletInfoKey][onboardingNewOutletKey].remove(outletCode);
      // }
    } catch (e, s) {
      Helper.dPrint("inside updateNewOutlet OutletServices catch block $e $s");
    }
    return false;
  }

  updateExistingOutlet(OutletModel outletModel) async {
    try {
      await _syncService.checkSyncVariable();
      if (!syncObj.containsKey(onboardingOutletInfoKey)) {
        syncObj[onboardingOutletInfoKey] = {};
      }
      if (!syncObj[onboardingOutletInfoKey].containsKey(
        onboardingNewOutletKey,
      )) {
        syncObj[onboardingOutletInfoKey][onboardingNewOutletKey] = {};
      }
      bool done = await sendNewOutletInfoToApi(
        outletModel.toJson(),
        SendOutletInfoType.edit,
        outletModel.outletCode.toString(),
      );
      outletModel.synced = done;

      syncObj[onboardingOutletInfoKey][onboardingNewOutletKey][outletModel
          .outletCode
          .toString()] = outletModel
          .toJson();
      // if(!done){
      //   syncObj[onboardingOutletInfoKey][onboardingNewOutletKey][outletModel.outletCode.toString()] = outletModel.toJson();
      // }
      await _syncService.writeSync();
    } catch (e, s) {
      Helper.dPrint(
        "inside updateExistingOutlet OutletServices catch block $e $s",
      );
    }
  }

  String numberFormatter(int digit, int number) {
    String strNum = "";
    int numberLength = number.toString().length;
    int left = digit - numberLength;
    if (left >= 0) {
      for (int i = 0; i < left; i++) {
        strNum += "0";
      }
    }
    strNum += number.toString();
    return strNum;
  }

  Future<String> generateUniqueOutletCode([int? outletCount]) async {
    int currentOutletCount =
        outletCount ?? await LocalStorageHelper.readInt("outlet_count");
    currentOutletCount++;
    String generatedOutletCode = await generateOutletCode(currentOutletCount);
    bool outletCodeExists = await checkExistingOutletCode(generatedOutletCode);
    if (outletCodeExists) {
      return generateUniqueOutletCode(currentOutletCount);
    } else {
      await LocalStorageHelper.saveInt("outlet_count", currentOutletCount);
      return generatedOutletCode;
    }
  }

  Future<String> generateOutletCode(int outletCount) async {
    SrInfoModel? srInfo = await _ffServices.getSrInfo();
    DateTime today = DateTime.now();
    String code = "R-${srInfo?.ffId}";
    code += srInfo!.ffId.toString();
    code += numberFormatter(2, today.day);
    code += numberFormatter(2, today.month);
    code += numberFormatter(
      2,
      int.parse(today.year.toString().substring(2, 4)),
    );
    code += "-";
    code += numberFormatter(3, outletCount);
    return code;
  }

  addNewOutlet({
    required ClusterModel clusterModel,
    required String outletName,
    required String outletNameBn,
    String? outletCoverPhotoPath,
    required String ownerName,
    required String contactNumber,
    required String nidNumber,
    required String address,
    GeneralIdSlugModel? businessType,
    GeneralIdSlugModel? channelCategory,
    GeneralIdSlugModel? cooler,
    required String coolerStatus,
    String? coolerPhotoPath,
    String status = "PENDING",
    LocationData? position,
  }) async {
    try {
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      String cleanStr = srInfo.sbuId.replaceAll(
        RegExp(r'[\[\]]'),
        '',
      ); // Remove brackets
      int sbuId = int.parse(cleanStr);
      String outletCode = await generateUniqueOutletCode();
      Map outletMap = {
        onboardingClusterKey: clusterModel.toJson(),
        onboardingOutletCodeKey: outletCode,
        onboardingOutletNameKey: outletName,
        onboardingNewOutletStatusKey: status,
        onboardingOutletNameBnKey: outletNameBn,
        onboardingOutletCoverPhotoPathKey: outletCoverPhotoPath,
        onboardingOwnerNameKey: ownerName,
        onboardingContactNumberKey: contactNumber,
        onboardingNIDNumberKey: nidNumber,
        sbuIdKey: [sbuId],
        onboardingAddressKey: address,
        onboardingNewOutletNumKey: 0,
        onboardingHasSyncedKey: false,
        onboardingLatitudeKey: position?.latitude,
        onboardingLongitudeKey: position?.longitude,
        onboardingAvailableOnboardingInfoKey: {
          onboardingBusinessTypeKey: businessType?.toJson(),
          onboardingChannelCategoryKey: channelCategory?.toJson(),
          onboardingCoolerStatusKey: coolerStatus,
          onboardingCoolerKey: cooler?.toJson(),
          onboardingCoolerImagePathKey: coolerPhotoPath,
        },
      };

      if (position == null ||
          position.latitude == null ||
          position.longitude == null)
        return;

      if (!syncObj.containsKey(onboardingOutletInfoKey)) {
        syncObj[onboardingOutletInfoKey] = {};
      }

      if (!syncObj[onboardingOutletInfoKey].containsKey(
        onboardingNewOutletKey,
      )) {
        syncObj[onboardingOutletInfoKey][onboardingNewOutletKey] = {};
      }

      syncObj[onboardingOutletInfoKey][onboardingNewOutletKey][outletCode] =
          outletMap;
      bool hasSynced = await sendNewOutletInfoToApi(
        outletMap,
        SendOutletInfoType.create,
      );
      syncObj[onboardingOutletInfoKey][onboardingNewOutletKey][outletCode][onboardingHasSyncedKey] =
          hasSynced;
      // if(hasSynced){
      //   syncObj[onboardingOutletInfoKey][onboardingNewOutletKey].remove(outletCode);
      // }
      await _syncService.writeSync();
    } catch (e) {
      Helper.dPrint("inside addNewOutlet OutletServices catch block $e");
    }
  }

  Future<bool> sendNewOutletInfoToApi(
    Map outletMap,
    SendOutletInfoType type, [
    String? outletCode,
  ]) async {
    try {
      SrInfoModel? srInfo = await _ffServices.getSrInfo();
      if (srInfo != null) {
        ClusterModel clusterModel = ClusterModel.fromJson(outletMap[onboardingClusterKey]??{}, sequence: 0);
        Map jsonDataToSendToApi = {
          "name": outletMap[onboardingOutletNameKey],
          "name_bn": outletMap[onboardingOutletNameBnKey],
          'cluster_id': outletMap['cluster_id']?? outletMap['id']?? clusterModel.id,
          "outlet_code": outletMap[onboardingOutletCodeKey],
          "owner_name": outletMap[onboardingOwnerNameKey],
          "contact_number": outletMap[onboardingContactNumberKey],
          "address": outletMap[onboardingAddressKey],
          "nid": outletMap[onboardingNIDNumberKey],
          "sbu_id": outletMap[sbuIdKey],
          "tin": "",
          "cooler_outlet":
              outletMap[onboardingAvailableOnboardingInfoKey][onboardingCoolerStatusKey] ==
                  "Yes"
              ? 1
              : 0,
          "cooler_id": Helper.getIdFromIdSlugMap(
            outletMap[onboardingAvailableOnboardingInfoKey][onboardingCoolerKey],
          ),
          "cooler_owner": 0,
          "outlet_type": Helper.getIdFromIdSlugMap(
            outletMap[onboardingAvailableOnboardingInfoKey][onboardingChannelCategoryKey],
          ),
          "outlet_id": 0,
          "business_type": Helper.getIdFromIdSlugMap(
            outletMap[onboardingAvailableOnboardingInfoKey][onboardingBusinessTypeKey],
          ),
          "manufacturer_id": 6,
          "lat": outletMap[onboardingLatitudeKey],
          "long": outletMap[onboardingLongitudeKey],
          "section_id": srInfo.sectionId,
          "dep_id": srInfo.depId,
        };
        // log(jsonEncode(outletMap));
        ReturnedDataModel response = await RetailerApi().send(
          jsonDataToSendToApi,
          outletMap[onboardingOutletCoverPhotoPathKey],
          outletMap[onboardingAvailableOnboardingInfoKey][onboardingCoolerImagePathKey],
          srInfo,
          type,
          outletCode,
        );
        print("outlet send");
        print(response.data);
        print(response.status);
        if (response.status == ReturnedStatus.success) {
          return true;
        }
      }
    } catch (e, s) {
      Helper.dPrint(
        "inside sendNewOutletInfoToApi outletServices catch block $e $s",
      );
    }
    return false;
  }

  changeRetailerList(Map retailer, {String? offlineId}) async {
    try {
      if (retailer.isNotEmpty) {
        if (retailer.containsKey("id")) {
          int? retailerPosition = await checkIfARetailerExistsInRetailerList(
            retailer['id'],
          );
          List retailers = syncObj["retailers"];
          if (retailerPosition != null) {
            retailers[retailerPosition] = retailer;
          } else {
            retailers.insert(0, retailer);
          }
          syncObj["retailers"] = retailers;

          if (offlineId != null) {
            await deleteRetailerFromNewRetailerList(offlineId);
          }
          await _syncService.writeSync();
        }
      }
    } catch (e) {
      Helper.dPrint("inside changeRetailerList OutletServices catch block $e");
    }
  }

  Future<int?> checkIfARetailerExistsInRetailerList(int id) async {
    int? position;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("retailers")) {
        if (syncObj["retailers"].isNotEmpty) {
          List retailers = syncObj["retailers"];
          for (int i = 0; i < retailers.length; i++) {
            var retailer = retailers[i];
            if (retailer["id"] == id) {
              position = i;
              break;
            }
          }
        }
      }
    } catch (e) {
      Helper.dPrint(
        "inside checkIfARetailerExistsInRetailerList OutletServices catch block $e",
      );
    }
    return position;
  }

  deleteRetailerFromNewRetailerList(String offlineId) async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(onboardingOutletInfoKey)) {
        if (syncObj[onboardingOutletInfoKey].containsKey(
          onboardingNewOutletKey,
        )) {
          if (syncObj[onboardingOutletInfoKey][onboardingNewOutletKey]
              .containsKey(offlineId)) {
            syncObj[onboardingOutletInfoKey][onboardingNewOutletKey].remove(
              offlineId,
            );
          }
        }
      }
    } catch (e) {
      Helper.dPrint(
        "inside deleteRetailerFromNewRetailerList outletServices catch block $e",
      );
    }
  }

  Map createPayload(
    String outletCode,
    String outletName,
    String outletNameBn,
    String outletCoverPhotoPath,
    String ownerName,
    String contactNumber,
    String nidNumber,
    String address,
    int newOutletCount,
    double lat,
    double lng,
    GeneralIdSlugModel? businessType,
    GeneralIdSlugModel? channelCategory,
    GeneralIdSlugModel? cooler,
    String coolerStatus,
    String coolerPhotoPath,
  ) {
    Map outletMap = {
      onboardingOutletCodeKey: outletCode,
      onboardingOutletNameKey: outletName,
      onboardingOutletNameBnKey: outletNameBn,
      onboardingOutletCoverPhotoPathKey: outletCoverPhotoPath,
      onboardingOwnerNameKey: ownerName,
      onboardingContactNumberKey: contactNumber,
      onboardingNIDNumberKey: nidNumber,
      onboardingAddressKey: address,
      onboardingNewOutletNumKey: newOutletCount,
      onboardingHasSyncedKey: false,
      onboardingLatitudeKey: lat,
      onboardingLongitudeKey: lng,
      onboardingAvailableOnboardingInfoKey: {
        onboardingBusinessTypeKey: businessType?.toJson(),
        onboardingChannelCategoryKey: channelCategory?.toJson(),
        onboardingCoolerStatusKey: coolerStatus,
        onboardingCoolerKey: cooler?.toJson(),
        onboardingCoolerImagePathKey: coolerPhotoPath,
      },
    };
    return outletMap;
  }

  Future<Map<String, int>> getNewAndUpdatedOutletCount() async {
    int total = 0;
    int totalSynced = 0;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(onboardingOutletInfoKey)) {
        if (syncObj[onboardingOutletInfoKey].containsKey(
          onboardingNewOutletKey,
        )) {
          for (MapEntry outletInfo
              in syncObj[onboardingOutletInfoKey][onboardingNewOutletKey]
                  .entries) {
            total += 1;
            String outletCode = outletInfo.key.toString();
            Map outletData = outletInfo.value;
            if (outletData.containsKey(onboardingHasSyncedKey)) {
              if (outletData[onboardingHasSyncedKey]) {
                totalSynced += 1;
              }
            }
          }
        }
      }
    } catch (e, s) {
      print("inside outlet services getNewAndUpdatedOutletCount $e, $s");
    }
    return {"total": total, "server": totalSynced};
  }

  syncOutletInfo([bool deleteOutletAfterSuccessfullSubmission = false]) async {
    try {
      await _syncService.checkSyncVariable();
      List updatedOrCreatedOutlets = [];
      if (syncObj.containsKey(onboardingOutletInfoKey)) {
        if (syncObj[onboardingOutletInfoKey].containsKey(
          onboardingNewOutletKey,
        )) {
          for (MapEntry outletInfo
              in syncObj[onboardingOutletInfoKey][onboardingNewOutletKey]
                  .entries) {
            String outletCode = outletInfo.key.toString();
            Map outletData = outletInfo.value;
            if (outletData.containsKey(onboardingHasSyncedKey)) {
              if (!outletData[onboardingHasSyncedKey]) {
                bool done = await sendNewOutletInfoToApi(
                  outletData,
                  SendOutletInfoType.edit,
                  outletCode,
                );
                syncObj[onboardingOutletInfoKey][onboardingNewOutletKey][outletCode][onboardingHasSyncedKey] =
                    done;
                print("retailer send to api $done");
                if (done) {
                  updatedOrCreatedOutlets.add(outletCode);
                }
              } else {
                updatedOrCreatedOutlets.add(outletCode);
              }
            } else {
              updatedOrCreatedOutlets.add(outletCode);
            }
          }
        }
      }
      // delete synced outlets
      print(updatedOrCreatedOutlets);
      if (deleteOutletAfterSuccessfullSubmission) {
        for (String outletCode in updatedOrCreatedOutlets) {
          syncObj[onboardingOutletInfoKey][onboardingNewOutletKey].remove(
            outletCode,
          );
        }
      }
      print("hello retailer ${syncObj[onboardingOutletInfoKey]}");
      List<String> inactiveList = [];
      if (syncObj.containsKey(onboardingInactiveOutletKey)) {
        for (MapEntry inactiveOutletData
            in syncObj[onboardingInactiveOutletKey].entries) {
          String inactiveOutletCode = inactiveOutletData.key.toString();
          inactiveList.add(inactiveOutletCode);
        }
      }
      if (inactiveList.isNotEmpty) {
        ReturnedDataModel returnedDataModel = await RetailerApi().bulkDisable(
          inactiveList,
        );
        if (returnedDataModel.status == ReturnedStatus.success) {
          for (String outletCode in inactiveList) {
            syncObj[onboardingInactiveOutletKey].remove(outletCode);
          }
        }
      }
      await _syncService.writeSync();
    } catch (e, s) {
      print("inside outlet services syncOutletInfo $e, $s");
    }
  }

  Future<bool> checkExistingNID(String nid, [String? newOutletCode]) async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(onboardingOutletInfoKey)) {
        if (syncObj[onboardingOutletInfoKey].containsKey(
          onboardingNewOutletKey,
        )) {
          for (MapEntry outletInfo
              in syncObj[onboardingOutletInfoKey][onboardingNewOutletKey]
                  .entries) {
            String outletCode = outletInfo.key.toString();
            if (outletCode != newOutletCode) {
              Map outletData = outletInfo.value;
              if (outletData.containsKey(onboardingNIDNumberKey)) {
                if (outletData[onboardingNIDNumberKey] == nid) {
                  return true;
                }
              }
            }
          }
        }
      }
      if (syncObj.containsKey("retailers")) {
        for (Map outlets in syncObj["retailers"]) {
          if (outlets.containsKey("outlet_code")) {
            if (newOutletCode != null) {
              if (outlets["outlet_code"] != newOutletCode) {
                if (outlets["nid"] == nid) {
                  return true;
                }
              }
            } else {
              if (outlets["nid"] == nid) {
                return true;
              }
            }
          }
        }
      }
    } catch (e, s) {
      print("inside OutletService checkExistingNID $e, $s");
    }
    return false;
  }

  Future<bool> checkExistingOutletCode(String newOutletCode) async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(onboardingOutletInfoKey)) {
        if (syncObj[onboardingOutletInfoKey].containsKey(
          onboardingNewOutletKey,
        )) {
          for (MapEntry outletInfo
              in syncObj[onboardingOutletInfoKey][onboardingNewOutletKey]
                  .entries) {
            String outletCode = outletInfo.key.toString();
            if (outletCode == newOutletCode) {
              return true;
            }
          }
        }
      }
      if (syncObj.containsKey("retailers")) {
        for (Map outlets in syncObj["retailers"]) {
          if (outlets.containsKey("outlet_code")) {
            if (outlets["outlet_code"] == newOutletCode) {
              return true;
            }
          }
        }
      }
    } catch (e, s) {
      print("inside OutletService checkExistingOutletCode $e, $s");
    }
    return false;
  }

  Future<Map> getAvailableOnboardingFeatures() async {
    Map availableOnboardingFeatures = {};
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("outlet_onboarding_configurations")) {
        if (syncObj["outlet_onboarding_configurations"].containsKey(
          "available_onboarding_buttons",
        )) {
          availableOnboardingFeatures =
              syncObj["outlet_onboarding_configurations"]["available_onboarding_buttons"];
        }
      }
    } catch (e) {
      print(
        "inside getAvailableOnboardingFeatures outletServices catch block $e",
      );
    }
    return availableOnboardingFeatures;
  }

  updateRetailerListFromApi() async {
    try {
      SrInfoModel? srInfoModel = await _ffServices.getSrInfo();
      String salesDate = await _ffServices.getSalesDate();
      String url =
          "${Links.baseUrl}${Links.getRetailerListUrl}/${srInfoModel!.sectionId}/$salesDate";
      ReturnedDataModel returned = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
        accessToken: srInfoModel.accessToken,
        refreshToken: srInfoModel.refreshToken,
      ).fetch();
      if (returned.status == ReturnedStatus.success) {
        syncObj["retailers"] = returned.data["data"];
        await _syncService.writeSync();
      }
    } catch (e) {
      Helper.dPrint(
        "inside updateRetailerListFromApi OutletServices catch block $e",
      );
    }
  }

  static bool showCoolerIcon(OutletModel outlet) {
    bool available = false;
    try {
      if (outlet.availableOnboardingInfo?.cooler != null) {
        available = outlet.availableOnboardingInfo?.coolerStatus.isNotEmpty ?? false;
      }
    } catch (e) {
      Helper.dPrint("inside showCoolerIcon OutletServices catch block $e");
    }
    return available;
  }

  Future<String> getOutletImage({required String imageName}) async {
    String imageUrl = '';
    try {
      ReturnedDataModel returnedDataModel = await RetailerApi().getOutletImage(
        imageName: imageName,
      );
      imageUrl = returnedDataModel.data?['data']?['url'] ?? "";
      print("!@!@>> ${imageUrl}");
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return imageUrl;
  }

  /// Returns true when retailers list in sync file is empty (no outlets loaded yet)
  Future<bool> isOutletListEmpty() async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey('retailers')) {
        final retailers = syncObj['retailers'];
        return retailers == null || (retailers as List).isEmpty;
      }
    } catch (e) {
      Helper.dPrint('inside isOutletListEmpty OutletServices catch block $e');
    }
    return true;
  }

  /// Calls the retailers API for the given [pointId] and [saleDate],
  /// then replaces syncObj['retailers'] with the fetched list and writes the sync file.
  Future<bool> fetchAndUpdateRetailersFromApi({
    required int pointId,
    required String saleDate,
    bool changeRequest = false,
  }) async {
    try {
      final srInfo = await _ffServices.getSrInfo();
      if (srInfo == null) return false;

      final url = Links.getPointWiseOutletUrl(pointId: pointId, saleDate: saleDate);
      final result = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
      ).fetch();

      if (result.status == ReturnedStatus.success) {
        final data = result.data?['data'];
        if (data != null && data.containsKey('retailers')) {
          final List retailers = data['retailers'] as List;
          await _syncService.checkSyncVariable();
          if (retailers.isNotEmpty) {
            syncObj['retailers'] = retailers;
          }
          if (data.containsKey('survey') && data['survey'] == true && data['survey'].containsKey('survey_details') &&
              data['survey']['survey_details'].containsKey('survey_info') &&
              data['survey']['survey_details'].containsKey('questions')) {
            if (!syncObj.containsKey('survey_details')) {
              syncObj['survey_details'] = {};
            }
            List serveryInfo = syncObj['survey_details']['survey_info'] as List;
            serveryInfo.add(data['survey']['survey_details']['survey_info']);
            Map questions = syncObj['survey_details']['questions'] as Map;
            questions.addAll(data['survey']['survey_details']['questions']);
          }
          syncObj['userData']['pointId']=pointId;
          List lastServicesPoints = syncObj['last_service_points'] as List;
          if(changeRequest == true) {
            lastServicesPoints.add(pointId);
            syncObj['last_service_points'] = lastServicesPoints;
          }

          await _syncService.writeSync();
          return true;
        }
      }
    } catch (e, s) {
      Helper.dPrint('inside fetchAndUpdateRetailersFromApi OutletServices catch block $e $s');
    }
    return false;
  }
}
