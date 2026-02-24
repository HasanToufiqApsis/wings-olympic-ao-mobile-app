import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:wings_olympic_sr/services/pre_order_service.dart';

import '../api/global_http.dart';
import '../api/links.dart';
import '../constants/constant_keys.dart';
import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/cluster_model.dart';
import '../models/coupon/coupon_model.dart';
import '../models/fare_chart_model.dart';
import '../models/general_id_slug_model.dart';
import '../models/module.dart';
import '../models/outlet_model.dart';
import '../models/product_category_model.dart';
import '../models/products_details_model.dart';
import '../models/qc_config_model.dart';
import '../models/qc_info_model.dart';
import '../models/returned_data_model.dart';
import '../models/sale_summary_model.dart';
import '../models/sales/memo_information_model.dart';
import '../models/slab_promotion_selection_model.dart';
import '../models/sr_info_model.dart';
import '../models/trade_promotions/applied_discount_model.dart';
import '../models/trade_promotions/promotion_model.dart';
import '../utils/promotion_utils.dart';
import '../utils/sales_type_utils.dart';
import 'Image_service.dart';
import 'before_sale_services/survey_service.dart';
import 'connectivity_service.dart';
import 'delivery_services.dart';
import 'device_info_services.dart';
import 'ff_services.dart';
import 'helper.dart';
import 'module_services.dart';
import 'offline_pda_service.dart';
import 'posm_management_service.dart';
import 'product_category_services.dart';
import 'promotion_services.dart';
import 'sr_target_services.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';
import 'trade_promotion_services.dart';

class ClusterService {
  final _syncService = SyncService();

  Future<List<ClusterModel>> getAllClusters() async {
    List<ClusterModel> clusters = [];

    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("clusters") && syncObj["clusters"].isNotEmpty) {
        for (int a = 0; a < syncObj["clusters"].length; a++) {
          clusters.add(ClusterModel.fromJson(syncObj["clusters"][a], sequence: a));
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }

    return clusters;
  }

  ClusterModel? getClusterFromId({required int clusterId}) {
    try {
      if (syncObj.containsKey("clusters") && syncObj["clusters"].isNotEmpty) {
        int index = syncObj["clusters"].indexWhere((element) => element["id"] == clusterId);
        if (index != -1) {
          return ClusterModel.fromJson(syncObj["clusters"][index], sequence: 0);
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }

    return null;
  }

  Future<List<FareChartModel>> getAllFareChart() async {
    List<FareChartModel> fareCharts = [];

    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("fare_charts") && syncObj["fare_charts"].isNotEmpty) {
        for (var fareChart in syncObj["fare_charts"]) {
          fareCharts.add(FareChartModel.fromJson(fareChart));
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }

    return fareCharts;
  }

  /// Get clusters only for servicesOutletList
  Future<List<ClusterModel>> getServicesClustersFromOutlets({
    required List<OutletModel> servicesOutletList,
  }) async {
    final allClusters = await getAllClusters();

    final Map<int, ClusterModel> clusterById = {
      for (final cluster in allClusters) if (cluster.id != null) cluster.id!: cluster,
    };

    final Map<int, ClusterModel> result = {};
    for (final outlet in servicesOutletList) {
      final clusterId = outlet.clusterId;
      if (clusterId == null) continue;

      final cluster = clusterById[clusterId];
      if (cluster != null) {
        result.putIfAbsent(clusterId, () => cluster);
      }
    }

    return result.values.toList();
  }

  /// Get clusters from sequence 0 → last cluster sequence found in outlets
  Future<List<ClusterModel>> getClustersFromFirstToLastByOutlet({
    required List<OutletModel> servicesOutletList,
  }) async {
    final allClusters = await getAllClusters();
    if (allClusters.isEmpty || servicesOutletList.isEmpty) return [];

    final Map<int, ClusterModel> clusterById = {
      for (var cluster in allClusters) if (cluster.id != null) cluster.id!: cluster
    };

    // find last sequence from actual outlet clusters
    int lastSequence = 0;
    for (final outlet in servicesOutletList) {
      final cluster = outlet.clusterId != null ? clusterById[outlet.clusterId!] : null;
      if (cluster != null && cluster.sequence > lastSequence) {
        lastSequence = cluster.sequence;
      }
    }
    print("lastSequence ------>   $lastSequence ");

    // return clusters from sequence 0 → lastSequence
    final result = allClusters
        .where((c) => c.sequence >= 0 && c.sequence <= lastSequence)
        .toList()
      ..sort((a, b) => a.sequence.compareTo(b.sequence));

    print("cluster length ------>   ${result.length} ");
    return result;
  }

  /// Build ClusterSets strictly based on existing fareCharts to avoid missing match
  List<ClusterSet> buildClusterSets({
    required List<ClusterModel> servicesClusters,
    required List<FareChartModel> allFareCharts,
  }) {
    final Map<int, ClusterModel> clusterMap = {
      for (var c in servicesClusters) c.id!: c
    };

    for(var val in servicesClusters) {
      print("services cluster ${val.id}");
    }
    print("}}}}}}}}}} ${clusterMap}");


    final List<ClusterSet> sets = [];
    for (final fare in allFareCharts) {
      print("try to find:: ");
      final fromCluster = clusterMap[fare.clusterIdFrom];
      final toCluster = clusterMap[fare.clusterIdTo];

      print("!@!@!@!@>> ${fare.clusterIdFrom} :: ${fromCluster?.id} :: ${toCluster?.id}");
      if (fromCluster != null && toCluster != null) {
        print("added set ------->");
        sets.add(ClusterSet(fromClusters: fromCluster, toClusters: toCluster));
      }
    }

    return sets;
  }

  /// Get matched FareCharts
  List<FareChartModel> getFareChartsByClusterSets({
    required List<ClusterSet> clusterSets,
    required List<FareChartModel> allFareCharts,
  }) {
    final Set<String> validPairs = clusterSets
        .map((s) => '${s.fromClusters.id}-${s.toClusters.id}')
        .toSet();

    return allFareCharts
        .where((fare) => validPairs.contains('${fare.clusterIdFrom}-${fare.clusterIdTo}'))
        .toList(growable: false);
  }
}
