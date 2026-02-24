import 'package:wings_olympic_sr/services/shared_storage_services.dart';

class SearchHistoryDbService {
  static const String _listKey = 'search_history_list';
  static const int _maxHistoryLength = 20;

  Future<List<String>> getList() {
    return LocalStorageHelper.getList(_listKey);
  }

  Future<void> addItem({required String searchKey}) {
    return LocalStorageHelper.addItem(_listKey, item: searchKey, maxLength: _maxHistoryLength);
  }

  Future<void> deleteItem({required String searchKey}) {
    return LocalStorageHelper.deleteItem(_listKey, item: searchKey);
  }
}