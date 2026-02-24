import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  static read(key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    return value;
  }

  static readBool(key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic value = prefs.getBool(key) ?? false;
    return value;
  }

  static readInt(key)async{
    final prefs = await SharedPreferences.getInstance();
    dynamic value = prefs.getInt(key) ?? 1;
    return value;
  }

  static save(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value ?? " ");
  }

  static saveBool(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static saveInt(key, value)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static clearData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<void> saveList(String key, {required List<String> list}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(list));
  }

  static Future<List<String>> getList(String key,) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];
    return List<String>.from(jsonDecode(jsonString));
  }

  /// Add an item
  static Future<void> addItem(String key, {required String item, bool unique = true, int? maxLength}) async {
    final list = await getList(key);
    if (unique && list.contains(item)) {
      int index = list.indexOf(item);
      list.removeAt(index);
      list.insert(0, item);
    } else {
      list.insert(0, item);
    }
    if(maxLength != null && list.length > maxLength) {
      list.removeLast();
    }
    await saveList(key, list: list);
  }

  /// Delete an item
  static Future<void> deleteItem(String key, {required String item}) async {
    final list = await getList(key);
    list.remove(item);
    await saveList(key, list: list);
  }

  /// Clear all
  static Future<void> clearList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
