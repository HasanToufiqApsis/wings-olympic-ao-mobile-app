import '../../../constants/sync_global.dart';
import '../../../services/helper.dart';
import '../../../services/sync_service.dart';
import '../../leave_management/model/ta_da_vehicle_model.dart';

class TaDaService {
  final SyncService _syncService = SyncService();

  Future<List<TaDaVehicleModel>> vehicleTypeList() async {
    List<TaDaVehicleModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      for(var val in syncObj["ta_da_config"]?["vehicle_list"] ?? []) {
        list.add(TaDaVehicleModel.fromJson(val));
      }
    } catch (e) {
      Helper.dPrint("inside checkIfCoolerImageNeedsToBeCaptured PerorderServices catch block $e");
    }
    return list;
  }

  Future<List<TaDaVehicleModel>> otherTypeList() async {
    List<TaDaVehicleModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      for(var val in syncObj["ta_da_config"]?["other_cost_type_list"] ?? []) {
        list.add(TaDaVehicleModel.fromJson(val));
      }
    } catch (e) {
      Helper.dPrint("inside checkIfCoolerImageNeedsToBeCaptured PerorderServices catch block $e");
    }
    return list;
  }
}