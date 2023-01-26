import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/model/shop/shop.dart';

const shopsJson = 'assets/json/shops.json';

class ShopService extends StateNotifier<List<Shop>> {
  ShopService() : super([]);

  Future<void> fetchShops() async {
    try {
      String offerResponse = await rootBundle.loadString(shopsJson);
      final jsonResponse = await json.decode(offerResponse);
      List<Shop> shops =
          List<Shop>.from(jsonResponse.map((x) => Shop.fromJson(x)));
      state = shops;
    } catch (err) {
      return Future.error(err);
    }
  }
}
