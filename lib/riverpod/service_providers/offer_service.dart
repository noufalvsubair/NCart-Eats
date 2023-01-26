import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/model/offer/offer.dart';

const offerJson = 'assets/json/offers.json';

class OfferService extends StateNotifier<List<Offer>> {
  OfferService() : super([]);

  Future<void> fetchOffers() async {
    try {
      String offerResponse = await rootBundle.loadString(offerJson);
      final jsonResponse = await json.decode(offerResponse);
      List<Offer> offers =
          List<Offer>.from(jsonResponse.map((x) => Offer.fromJson(x)));
      state = offers;
    } catch (err) {
      return Future.error(err);
    }
  }
}
