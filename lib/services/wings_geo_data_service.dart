import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as path;

import '../api/global_http.dart';
import '../api/links.dart';
import '../constants/constant_keys.dart';
import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/outlet_model.dart';
import '../models/sr_info_model.dart';
import 'ff_services.dart';
import 'geo_location_service.dart';
import 'sync_service.dart';

class WingsGeoDataService {
  static final WingsGeoDataService _wingsGeoDataService = WingsGeoDataService._internal();

  factory WingsGeoDataService() {
    return _wingsGeoDataService;
  }

  WingsGeoDataService._internal();

  final FFServices _ffService = FFServices();
  final SyncService _syncService = SyncService();

  Future<int> getTrackingInterval() async {
    int interval = 180;
    await _syncService.checkSyncVariable();

    if (syncObj.containsKey('geo_data_config')) {
      if (syncObj['geo_data_config'].containsKey('tracking_interval')) {
        interval = syncObj['geo_data_config']['tracking_interval'];
      }
    }
    return interval;
  }

  ///geo data for sale
  Future<Map> createGeoDataMap({required BuildContext context, required OutletModel retailer}) async {
    SrInfoModel? srInfo = await _ffService.getSrInfo();
    LocationData? position = await LocationService(context).determinePosition(checkLocal: true);
    num? allowableDistance;
    num? distance;
    Map? manualOverrideData;
    String? coolerImage;
    String? coolerPurityScore;
    _syncService.checkSyncVariable();

    // if (syncObj.containsKey('geo_data_config')) {
    allowableDistance = retailer.outletLocation.allowableDistance;
    // }
    if (syncObj.containsKey(manualOverrideKey)) {
      if (syncObj[manualOverrideKey].containsKey(retailer.id.toString())) {
        if (syncObj[manualOverrideKey][retailer.id.toString()].isNotEmpty) {
          manualOverrideData = syncObj[manualOverrideKey][retailer.id.toString()];
        }
      }
    }

    coolerImage = syncObj[coolerImageKey]?[retailer.id.toString()];
    coolerPurityScore = syncObj[coolerPurityScoreKey]?[retailer.id.toString()];
    if (coolerImage != null) {
      coolerImage = path.basename(coolerImage);
    }
    if (retailer.outletLocation.latitude != 0 || retailer.outletLocation.longitude != 0) {
      distance = await LocationService(context).getDistance(retailer.outletLocation.latitude, retailer.outletLocation.longitude, checkLocal: true);
    } else {
      distance = 0;
    }

    Map geoData = {};
    if (position != null) {
      geoData = {
        geoDataDepIdKey: srInfo!.depId,
        geoDataSectionIdKey: srInfo.sectionId,
        geoDataRetailerIdKey: retailer.id,
        geoDataRetailerCodeKey: retailer.outletCode,
        geoDataFFIdKey: srInfo.ffId,
        geoDataDateKey: apiDateFormat.format(DateTime.now()),
        geoDataLatKey: position.latitude,
        geoDataLngKey: position.longitude,
        geoDataAllowableDistanceKey: allowableDistance,
        geoDataDistanceKey: distance,
        geoDataAccuracyKey: position.accuracy,
        geoDataGeoValidationKey: manualOverrideData != null ? 0 : 1,
        geoDataPhotoValidationKey: manualOverrideData != null ? 1 : 0,
        geoDataImageUrlKey: manualOverrideData != null ? path.basename(manualOverrideData[manualOverrideImageKey]) : null,
        geoDataReasoningKey: manualOverrideData != null ? manualOverrideData[manualOverrideReasoningKey] : null,
        geoDataCoolerImageUrlKey: coolerImage,
        geoDataCoolerPurityScoreKey: coolerPurityScore,
        geoDataStatusKey: 3,
        geoDataAltitudeKey: position.altitude,
        geoDataHeadingKey: position.heading,
        geoDataSpeedKey: position.speed,
        geoDataInternetSpeedKey: "",
        geoDataConnectionTypeKey: "",
        geoDataCaptureTime: apiDateTimeFormat.format(DateTime.now())
      };
    }

    return geoData;
  }

  ///sr tracking data
  void submitLocation(LocationData position) async {
    try {
      // print('location update::::>');
      SrInfoModel? srInfo = await _ffService.getSrInfo();
      String salesDate = await _ffService.getSalesDate();

      Map trackingData = {
        srTrackingSbuIdKey: srInfo?.sbuId,
        srTrackingDateKey: salesDate,
        srTrackingTimestampKey: DateTime.now().toString(),
        srTrackingFFIdKey: srInfo?.ffId,
        srTrackingDepIdKey: srInfo?.depId,
        srTrackingSectionIdKey: srInfo?.sectionId,
        srTrackingLatKey: position.latitude.toString(),
        srTrackingLngKey: position.longitude.toString(),
        srTrackingAccuracyKey: position.accuracy,
        srTrackingAltitudeKey: position.altitude,
        srTrackingAltitudeAccuracyKey: "",
        srTrackingHeadingKey: position.heading,
        srTrackingSpeedKey: position.speed,
        srTrackingInternetSpeedKey: "",
        srTrackingConnectionTypeKey: ""
      };

      await saveSrTrackingDataToSync(data: trackingData);

      await GlobalHttp(
              httpType: HttpType.post,
              uri: '${Links.baseUrl}${Links.srTracking}',
              accessToken: srInfo?.accessToken,
              refreshToken: srInfo?.refreshToken,
              body: jsonEncode(trackingData))
          .fetch();
    } catch (e, s) {
      print('inside GeoDataService submitLocation method $e');
    }
  }

  saveSrTrackingDataToSync({required Map data}) async {
    _syncService.checkSyncVariable();
    try {
      if (!syncObj.containsKey(srTrackingKey)) {
        syncObj[srTrackingKey] = [];
      }

      syncObj[srTrackingKey].add(data);

      await _syncService.writeSync(jsonEncode(syncObj));
      // print(syncObj[srTrackingKey].length);
    } catch (e, s) {
      print('inside GeoDataService saveSrTrackingDataToSync method $e');
    }
  }
}
