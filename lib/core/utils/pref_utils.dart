//ignore: unused_import
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String resgitered = "registered";

const String spectator = "spectator";

late SharedPreferences sharedPreferences;

class PrefUtils {
  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
      print('SharedPreference Initialized 1');
    });
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print('SharedPreference Initialized 2');
  }

  static bool find(String key) {
    return sharedPreferences.containsKey(key);
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    sharedPreferences.clear();
  }

  static void remove(String key) async {
    sharedPreferences.remove(key);
  }

  static setString(String key, String value) {
    sharedPreferences.setString(key, value);
  }

  static setInt(String key, int value) {
    sharedPreferences.setInt(key, value);
  }

  static int? getInt(String key) {
    return sharedPreferences.getInt(key);
  }

  static String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  static setBool(String key, bool value) {
    sharedPreferences.setBool(key, value);
  }

  static bool? getBool(String key) {
    return sharedPreferences.getBool(key);
  }
}
