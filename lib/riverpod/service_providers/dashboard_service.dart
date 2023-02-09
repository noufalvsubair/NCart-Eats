import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/firebase/fb_table.dart';
import 'package:ncart_eats/model/offer/offer.dart';
import 'package:ncart_eats/model/shop/shop.dart';
import 'package:ncart_eats/riverpod/states/dashboard_state.dart';

class DashboardService extends StateNotifier<DashboardState> {
  DashboardService() : super(DashboardState.initial());

  Future<void> fetchDashboardInfo() async {
    try {
      List<Shop> allShops = await fetchShopsInfo();
      List<Offer> offers = await fetchOfferInfo();
      offers = offers.where((Offer offer) {
        Shop shop =
            allShops.firstWhere((Shop shop) => shop.id! == offer.offerID);
        return !shop.hasClosed!;
      }).toList();
      state = state.copyWith(offers, allShops);
    } catch (err) {
      return Future.error(err);
    }
  }

  Future<List<Offer>> fetchOfferInfo() async {
    try {
      List<Offer> offers = [];
      DateTime currentDateTime = DateTime.now();
      QuerySnapshot<Map<String, dynamic>> offerCollectionRef =
          await FirebaseFirestore.instance
              .collection(FBTable.offerTable)
              .where('end_time',
                  isGreaterThan: Timestamp.fromDate(currentDateTime))
              .get();
      for (DocumentSnapshot doc in offerCollectionRef.docs) {
        Map<String, dynamic>? offerJson = doc.data() as Map<String, dynamic>?;
        offerJson!['start_time'] =
            (offerJson['start_time'] as Timestamp).toDate().toString();
        offerJson['end_time'] =
            (offerJson['end_time'] as Timestamp).toDate().toString();
        DateTime startTime = DateTime.parse(offerJson['start_time']);
        if (currentDateTime.isAfter(startTime)) {
          offers.add(Offer.fromJson(offerJson));
        }
      }

      return offers;
    } catch (err) {
      return Future.error(err);
    }
  }

  Future<List<Shop>> fetchShopsInfo() async {
    try {
      List<Shop> shops = [];
      QuerySnapshot<Map<String, dynamic>> shopCollectionRef =
          await FirebaseFirestore.instance
              .collection(FBTable.shopTable)
              .orderBy('name')
              .get();
      for (DocumentSnapshot doc in shopCollectionRef.docs) {
        Map<String, dynamic>? shopJson = doc.data() as Map<String, dynamic>?;
        shopJson!['open_time'] =
            (shopJson['open_time'] as Timestamp).toDate().toString();
        shopJson['close_time'] =
            (shopJson['close_time'] as Timestamp).toDate().toString();
        Shop shop = updateShopByOpenAndCloseTime(Shop.fromJson(shopJson));
        shops.add(shop);
      }

      return shops;
    } catch (err) {
      return Future.error(err);
    }
  }

  static Shop updateShopByOpenAndCloseTime(Shop shop) {
    DateTime currentDateTime = DateTime.now();
    DateTime openTime = DateTime.parse(shop.openTime!);
    DateTime closeTime = DateTime.parse(shop.closeTime!);
    DateTime openDateTime = DateTime(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day,
        openTime.hour,
        openTime.minute,
        openTime.second);
    DateTime closeDateTime = DateTime(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day,
        closeTime.hour,
        closeTime.minute,
        closeTime.second);
    shop.hasClosed = !(currentDateTime.isBefore(closeDateTime) &&
        currentDateTime.isAfter(openDateTime));
    return shop;
  }
}
