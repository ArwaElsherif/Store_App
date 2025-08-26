// ignore_for_file: avoid_print


import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences?
  prefs; //declare a static variable to hold the instance

  static Future<void> init() async {
    prefs =
        await SharedPreferences.getInstance(); //initialize the SharedPreferences instance
  }

  // Methods
  static Future<bool> setData(String key, dynamic value) async {
    if (value is String) {
      return await prefs!.setString(key, value); //store a string value
    }
    if (value is int) {
      return await prefs!.setInt(key, value); //store an integer value
    }
    if (value is bool) {
      return await prefs!.setBool(key, value); //store a boolean value
    }
    if (value is double) {
      return await prefs!.setDouble(key, value); //store a double value
    }
    if (value is List<String>) {
      return await prefs!.setStringList(key, value); //store a list of strings
    }
    return false; //return false if the value type is not supported
  }

  static dynamic getData(String key) {
    return prefs!.get(key); //retrieve data by key
  }

  static Future<bool> removeData(String key) async {
    return await prefs!.remove(key); //remove data by key
  }

  static Future<void> clearAll() async {
     await prefs!.clear(); //clear all stored data
  }


}

