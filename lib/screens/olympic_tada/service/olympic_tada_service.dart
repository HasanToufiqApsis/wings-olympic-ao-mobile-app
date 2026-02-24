import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:wings_olympic_sr/constants/constant_keys.dart';
import 'package:wings_olympic_sr/screens/leave_management/model/selected_vehicle_with_tada.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../../constants/sync_global.dart';
import '../../../models/cluster_model.dart';
import '../../../models/fare_chart_model.dart';
import '../../../models/outlet_model.dart';
import '../../../services/cluster_service.dart';
import '../../../services/helper.dart';
import '../../../services/outlet_services.dart';
import '../../../services/sync_service.dart';
import '../../leave_management/model/ta_da_vehicle_model.dart';
import '../model/drafted_ta_da.dart';
import '../model/extra_ta_da_model.dart';
import '../model/selected_vehicle_with_tada_olympic.dart';

class OlympicTaDaService {
  final _syncService = SyncService();
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
        for (var o in preorderOutlets) o.id ?? 0: o,
        for (var o in spotSalesOutlets) o.id ?? 0: o,
      };

      final servicesOutletList = outletMap.values.toList();

      bool onlyTouchedCluster = false;

      final allFareCharts = await _clusterService.getAllFareChart();

      if(onlyTouchedCluster) {
        final servicesClusters =
        await _clusterService.getServicesClustersFromOutlets(
          servicesOutletList: servicesOutletList,
        );
        print("------>  ${servicesClusters.length}");
        final Set<int> clusterIds = servicesClusters
            .map((cluster) => cluster.id)
            .whereType<int>() // null safe
            .toSet();

        /// Step 2: FareChart filter
        fareCharts = allFareCharts
            .where((fare) =>
        clusterIds.contains(fare.clusterIdFrom) ||
            clusterIds.contains(fare.clusterIdTo))
            .toList();
      } else {
        final servicesClusters = await _clusterService.getClustersFromFirstToLastByOutlet(
          servicesOutletList: servicesOutletList,
        );
        print("suevices cluster :: ${servicesClusters.length} ");
        final clusterSets = _clusterService.buildClusterSets(
          servicesClusters: servicesClusters,
          allFareCharts: allFareCharts,
        );
        print("clusterSets cluster :: ${clusterSets.length} ");

        fareCharts = _clusterService.getFareChartsByClusterSets(
          clusterSets: clusterSets,
          allFareCharts: allFareCharts,
        );
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return fareCharts;
  }

  List<FareChartModel> getFareChartsByClusterSets({
    required List<ClusterSet> clusterSets,
    required List<FareChartModel> allFareCharts,
  }) {
    return allFareCharts
        .where((fare) {
          return clusterSets.any(
            (set) =>
                set.fromClusters.id == fare.clusterIdFrom && set.toClusters.id == fare.clusterIdTo,
          );
        })
        .toList(growable: false);
  }



  Future<List<ExtraTaDaType>> taDaVehicleTypeList() async {
    List<ExtraTaDaType> list = [];
    try {
      await _syncService.checkSyncVariable();
      for(var val in syncObj["tada_expense_configs"] ?? []) {
        final tada = ExtraTaDaType.fromJson(val);
        if((tada.amount??0)==0) {
          list.add(tada);
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return list;
  }



  Future<List<ExtraTaDaType>> fixedTaDaVehicleTypeList() async {
    List<ExtraTaDaType> list = [];
    try {
      await _syncService.checkSyncVariable();
      for(var val in syncObj["tada_expense_configs"] ?? []) {
        final tada = ExtraTaDaType.fromJson(val);
        if((tada.amount??0)>0) {
          list.add(tada);
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return list;
  }

  Future<DraftedTaDaData?> getDraftTaDa() async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(taDaKey)) {
        return DraftedTaDaData.fromJson(syncObj[taDaKey]);
      }

    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  Future draftTaDa({required List<SelectedVehicleWithTaDaOlympic> vehicleTaDa, required String remarks}) async {
    try {
      List costList = [];
      for (var vehicle in vehicleTaDa) {
        costList.add({
          "cost_type": "${vehicle.selectedTaDa?.id}",
          "cost": "${vehicle.textEditingController?.text}",
          "identity": DateTime.now().toIso8601String(),
        });
      }
      if(costList.isNotEmpty) {
        await _syncService.checkSyncVariable();
        if (!syncObj.containsKey(taDaKey)) {
          syncObj[taDaKey] = {};
        }
        final Map<String, dynamic> data = {
          "remarks": remarks,
          "cost_list": costList,
          "submitted": false,
        };
        syncObj[taDaKey] = data;
        await _syncService.writeSync(jsonEncode(syncObj));
        print("save tada data ${costList}");
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  Future<bool> checkUnSubmittedDraftedTaDa() async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(taDaKey)) {
        if(syncObj[taDaKey]["submitted"] == false) {
          return true;
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return false;
  }

  void taDaSubmitted() async {
    await _syncService.checkSyncVariable();
    if (syncObj.containsKey(taDaKey)) {
      syncObj[taDaKey]["submitted"] = true;

      await _syncService.writeSync(jsonEncode(syncObj));
    }
  }
}
