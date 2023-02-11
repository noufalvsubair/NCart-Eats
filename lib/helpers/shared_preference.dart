import 'dart:convert';

import 'package:ncart_eats/model/cart/cart.dart';
import 'package:ncart_eats/model/current_location/current_location.dart';
import 'package:ncart_eats/model/current_user/current_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // Singleton
  static final SharedPreferenceHelper shared =
      SharedPreferenceHelper._privateConstructor();

  SharedPreferenceHelper._privateConstructor();

  // Keys
  final String _user = "user";
  final String _location = "location";
  final String _cart = "cart";

  Future<void> clearPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_user);
    await prefs.remove(_location);
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

  Future<void> setLocation(CurrentLocation location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_location, json.encode(location));
  }

  Future<CurrentLocation?> getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locationJson = prefs.getString(_location);
    if (locationJson != null && locationJson.isNotEmpty) {
      return CurrentLocation.fromJson(jsonDecode(locationJson));
    }

    return null;
  }

  Future<List<Cart>> getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString(_cart);
    if (cartJson != null && cartJson.isNotEmpty) {
      return List<Cart>.from(
          jsonDecode(cartJson).map((x) => Cart.fromJson(x)));
    }

    return [];
  }

  Future<void> setCart(List<Cart> carts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cart, carts.isNotEmpty ? json.encode(carts) : "");
  }
}
