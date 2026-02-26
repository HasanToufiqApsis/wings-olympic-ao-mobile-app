import '../constants/sync_global.dart';
import '../models/digital_learning/digital_learning_item.dart';
import '../models/point_model.dart';
import 'helper.dart';
import 'sync_service.dart';

class AuditService {
  final SyncService _syncService = SyncService();

  Future<List<PointDetailsModel>> getAllPointList() async {
    List<PointDetailsModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("locations")) {
        if(syncObj['locations'].containsKey('point')) {
          Map point = syncObj['locations']['point'];
          point.forEach((key, value) {
            list.add(PointDetailsModel.fromJson(value));
          });
        }
      }
    } catch (e, s) {
      Helper.dPrint("$e");
      Helper.dPrint("$s");
    }
    return list;
  }

  Future<PointDetailsModel?> getPointById({required int id}) async {
    List<PointDetailsModel> list = await getAllPointList();
    try {
      for (var element in list) {
        if (element.id == id) {
          return element;
        }
      }
    } catch (e, s) {
      Helper.dPrint("$e");
      Helper.dPrint("$s");
    }
    return null;
  }
}
