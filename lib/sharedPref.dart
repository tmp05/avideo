import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<dynamic> read(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return json.decode(prefs.getString(key));
    } else
      return null;
  }

  Future<bool> getAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth') == 'true';
  }

  dynamic save(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value).toString());
  }

  dynamic remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      prefs.remove(key);
    }
  }
}
