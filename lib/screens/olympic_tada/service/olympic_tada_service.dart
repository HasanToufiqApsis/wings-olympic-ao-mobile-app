import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:wings_olympic_sr/constants/constant_keys.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../../constants/sync_global.dart';
import '../../../models/cluster_model.dart';
import '../../../models/fare_chart_model.dart';
import '../../../models/outlet_model.dart';
import '../../../services/cluster_service.dart';
import '../../../services/outlet_services.dart';
import '../../../services/sync_read_service.dart';
import '../../../services/sync_service.dart';
import '../../leave_management/model/ta_da_vehicle_model.dart';
import '../model/drafted_ta_da.dart';
import '../model/extra_ta_da_model.dart';
import '../model/olympic_da_info.dart';
import '../model/olympic_tada_entry.dart';

class OlympicTaDaService {
  final _syncService = SyncService();
  final _syncReadService = SyncReadService();
  final _outletService = OutletServices();
  final _clusterService = ClusterService();

  Future<List<FareChartModel>> getServicesClusters() async {
    List<FareChartModel> fareCharts = [];

    try {
      await _syncService.checkSyncVariable();
      final preorderOutlets = await _outletService.getOrderedOutletList(
        saleType: SaleType.preorder,
      );
      final spotSalesOutlets = await _outletService.getOrderedOutletList(
        saleType: SaleType.spotSale,
      );

      final Map<int, OutletModel> outletMap = {
        for (final outlet in preorderOutlets) outlet.id ?? 0: outlet,
        for (final outlet in spotSalesOutlets) outlet.id ?? 0: outlet,
      };

      final servicesOutletList = outletMap.values.toList();
      final allFareCharts = await _clusterService.getAllFareChart();
      final servicesClusters = await _clusterService.getClustersFromFirstToLastByOutlet(
        servicesOutletList: servicesOutletList,
      );

      final List<ClusterSet> clusterSets = _clusterService.buildClusterSets(
        servicesClusters: servicesClusters,
        allFareCharts: allFareCharts,
      );

      fareCharts = _clusterService.getFareChartsByClusterSets(
        clusterSets: clusterSets,
        allFareCharts: allFareCharts,
      );
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }

    return fareCharts;
  }

  Future<List<TaDaVehicleModel>> vehicleTypeList() async {
    final List<TaDaVehicleModel> list = [];

    try {
      await _syncService.checkSyncVariable();
      final rawVehicles = syncObj['ta_da_config']?['vehicle_list'];
      if (rawVehicles is List) {
        for (final vehicle in rawVehicles) {
          if (vehicle is Map<String, dynamic>) {
            list.add(TaDaVehicleModel.fromJson(vehicle));
          } else if (vehicle is Map) {
            list.add(TaDaVehicleModel.fromJson(Map<String, dynamic>.from(vehicle)));
          }
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }

    return list;
  }

  Future<List<ExtraTaDaType>> taDaVehicleTypeList() async {
    return <ExtraTaDaType>[];
  }

  Future<List<ExtraTaDaType>> fixedTaDaVehicleTypeList() async {
    return <ExtraTaDaType>[];
  }

  Future<OlympicDaResolution> resolveDaForCurrentSalesDate() async {
    try {
      await _syncService.checkSyncVariable();
      final salesDate = await _syncReadService.getSalesDate();
      final daCategoryId = _getDaCategoryId();

      final rawConfigs = syncObj['tada_expense_configs'];
      if (rawConfigs is! Map) {
        return const OlympicDaResolution(
          message: 'DA configuration is unavailable in sync data.',
        );
      }

      final rawEvents = syncObj[taDaSurveyEventKey];
      if (rawEvents is! List || rawEvents.isEmpty) {
        return const OlympicDaResolution(
          message: 'Complete an audit or outlet survey first to unlock DA.',
        );
      }

      final List<Map<String, dynamic>> todayEvents = [];
      for (final event in rawEvents) {
        if (event is Map) {
          final map = Map<String, dynamic>.from(event);
          if (map['sales_date']?.toString() == salesDate) {
            todayEvents.add(map);
          }
        }
      }

      if (todayEvents.isEmpty) {
        return const OlympicDaResolution(
          message: 'Complete an audit or outlet survey first to unlock DA.',
        );
      }

      todayEvents.sort((a, b) {
        final first = DateTime.tryParse(a['created_at']?.toString() ?? '');
        final second = DateTime.tryParse(b['created_at']?.toString() ?? '');
        if (first == null && second == null) return 0;
        if (first == null) return 1;
        if (second == null) return -1;
        return first.compareTo(second);
      });

      final firstEvent = todayEvents.first;
      final surveyType = firstEvent['survey_type']?.toString() ?? '';

      if (surveyType == 'audit') {
        final pointId = int.tryParse(firstEvent['point_id']?.toString() ?? '');
        if (pointId == null) {
          return const OlympicDaResolution(
            message: 'The first audit survey is missing point information.',
          );
        }

        final pointConfig = rawConfigs[pointId.toString()];
        if (pointConfig is! Map || pointConfig.isEmpty) {
          return const OlympicDaResolution(
            message: 'No DA config found for the audited point.',
          );
        }

        final firstConfig = pointConfig.entries.first;
        final sectionId = int.tryParse(firstConfig.key.toString());
        final configData = Map<String, dynamic>.from(firstConfig.value as Map);
        final pointType =
            _getPointType(pointId) ??
            configData['type']?.toString() ??
            'DA';

        return OlympicDaResolution(
          daInfo: OlympicDaInfo(
            surveyType: 'audit',
            pointId: pointId,
            sectionId: sectionId,
            categoryId: daCategoryId,
            allowanceType: pointType,
            amount: _parseAmount(configData['amount']),
            salesDate: salesDate,
          ),
        );
      }

      if (surveyType == 'outlet') {
        final depId = int.tryParse(
          (firstEvent['dep_id'] ?? firstEvent['point_id'])?.toString() ?? '',
        );
        final sectionId =
            int.tryParse(firstEvent['section_id']?.toString() ?? '');

        if (depId == null || sectionId == null) {
          return const OlympicDaResolution(
            message: 'The first outlet survey is missing point or section data.',
          );
        }

        final pointConfig = rawConfigs[depId.toString()];
        if (pointConfig is! Map ||
            !pointConfig.containsKey(sectionId.toString())) {
          return const OlympicDaResolution(
            message: 'No DA config found for the surveyed outlet.',
          );
        }

        final configData = pointConfig[sectionId.toString()];
        if (configData is! Map) {
          return const OlympicDaResolution(
            message: 'No DA config found for the surveyed outlet.',
          );
        }

        final configMap = Map<String, dynamic>.from(configData);
        final pointType =
            _getPointType(depId) ?? configMap['type']?.toString() ?? 'DA';
        return OlympicDaResolution(
          daInfo: OlympicDaInfo(
            surveyType: 'outlet',
            pointId: depId,
            sectionId: sectionId,
            categoryId: daCategoryId,
            allowanceType: pointType,
            amount: _parseAmount(configMap['amount']),
            salesDate: salesDate,
          ),
        );
      }

      return const OlympicDaResolution(
        message: 'Complete an audit or outlet survey first to unlock DA.',
      );
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }

    return const OlympicDaResolution(
      message: 'Failed to resolve DA from sync data.',
    );
  }

  Future<DraftedTaDaData?> getDraftTaDa() async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(taDaKey) && syncObj[taDaKey] is Map) {
        return DraftedTaDaData.fromJson(
          Map<String, dynamic>.from(syncObj[taDaKey] as Map),
        );
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return null;
  }

  Future<void> draftTaDa({
    required List<OlympicTaDaEntry> entries,
    required String remarks,
    required OlympicDaInfo? daInfo,
  }) async {
    try {
      final salesDate = await _syncReadService.getSalesDate();
      final taRows = entries
          .where((entry) => !entry.isEmpty)
          .map((entry) => entry.toDraftJson())
          .toList(growable: false);

      await _syncService.checkSyncVariable();
      syncObj[taDaKey] = <String, dynamic>{
        'remarks': remarks,
        'submitted': false,
        'sales_date': salesDate,
        'da_info': daInfo?.toJson(),
        'ta_rows': taRows,
      };

      await _syncService.writeSync(jsonEncode(syncObj));
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  Future<bool> checkUnSubmittedDraftedTaDa() async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(taDaKey) && syncObj[taDaKey] is Map) {
        return syncObj[taDaKey]['submitted'] == false;
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return false;
  }

  void taDaSubmitted() async {
    await _syncService.checkSyncVariable();
    if (syncObj.containsKey(taDaKey) && syncObj[taDaKey] is Map) {
      syncObj[taDaKey]['submitted'] = true;
      await _syncService.writeSync(jsonEncode(syncObj));
    }
  }

  double _parseAmount(dynamic value) {
    return double.tryParse(value?.toString() ?? '0') ?? 0;
  }

  String? _getPointType(int pointId) {
    final rawPoints = syncObj['locations']?['point'];
    if (rawPoints is! Map) return null;

    final pointData = rawPoints[pointId.toString()];
    if (pointData is Map) {
      return pointData['type']?.toString();
    }

    return null;
  }

  int _getDaCategoryId() {
    final rawOtherCostTypes = syncObj['ta_da_config']?['other_cost_type_list'];
    if (rawOtherCostTypes is! List) return 0;

    for (final item in rawOtherCostTypes) {
      if (item is Map &&
          item['slug']?.toString().trim().toUpperCase() == 'DA') {
        return int.tryParse(item['id']?.toString() ?? '') ?? 0;
      }
    }

    return 0;
  }
}
