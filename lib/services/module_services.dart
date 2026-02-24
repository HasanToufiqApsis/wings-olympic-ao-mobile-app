import '../constants/sync_global.dart';
import '../models/module.dart';
import 'sync_service.dart';

class ModuleServices{
  final SyncService _syncService = SyncService();

  Future<List<Module>> getModuleModelList() async {
    List<Module> modules = [];
    try {
      Map m = await getModuleList();
      if (m.isNotEmpty) {
        m.forEach((key, value) {
          modules.add(Module.fromJson(value));
        });
      }
    } catch (e) {
      print("inside getModuleModelList syncReadServices catch block $e");
    }

    return modules;
  }

  /// Get all MODULES list for  dashboard containers
  Future<Map> getModuleList() async {
    Map modules = {};
    try {
      await _syncService.checkSyncVariable();
      modules.addAll(syncObj['modules']);
    } catch (e) {
      print("Inside getModuleList in SyncReadService catch block");
    }
    return modules;
  }
}