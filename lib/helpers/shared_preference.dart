import 'dart:convert';

import 'package:ncart_eats/model/current_user/current_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // Singleton
  static final SharedPreferenceHelper shared =
      SharedPreferenceHelper._privateConstructor();

  SharedPreferenceHelper._privateConstructor();

  // Keys
  final String _user = "user";

  Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_user);
  }

  Future<void> setUser(CurrentUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_user, json.encode(user));
  }

  Future<CurrentUser?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_user);
    if (userJson != null && userJson.isNotEmpty) {
      return CurrentUser.fromJson(jsonDecode(userJson));
    }

    return null;
  }
}
