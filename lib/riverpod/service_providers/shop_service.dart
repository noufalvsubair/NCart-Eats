import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/firebase/fb_table.dart';
import 'package:ncart_eats/model/shop/shop.dart';

class ShopService extends StateNotifier<List<Shop>> {
  ShopService() : super([]);

  Future<void> fetchShops() async {
    try {
      List<Shop> shops = [];
      QuerySnapshot<Map<String, dynamic>> shopCollectionRef =
          await FirebaseFirestore.instance
              .collection(FBTable.shopTable)
              .orderBy('name')
              .get();
      for (DocumentSnapshot doc in shopCollectionRef.docs) {
        Map<String, dynamic>? shopJson = doc.data() as Map<String, dynamic>?;
        Shop shop = updateShopByOpenAndCloseTime(Shop.fromJson(shopJson!));
        shops.add(shop);
      }
      state = shops;
    } catch (err) {
      return Future.error(err);
    }
  }

  static Shop updateShopByOpenAndCloseTime(Shop shop) {
    DateTime currentDateTime = DateTime.now();
    DateTime openTime =
        DateTime.fromMillisecondsSinceEpoch(shop.openTime!.toInt());
    DateTime closeTime =
        DateTime.fromMillisecondsSinceEpoch(shop.closeTime!.toInt());
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
