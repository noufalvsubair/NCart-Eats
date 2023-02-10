import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/firebase/fb_table.dart';
import 'package:ncart_eats/model/dish/dish.dart';

class FoodService extends StateNotifier<List<Dish>> {
  FoodService() : super([]);

  Future<void> fetchFoodInfo(String shopID) async {
    try {
      List<Dish> foods = [];
      QuerySnapshot<Map<String, dynamic>> shopCollectionRef =
          await FirebaseFirestore.instance
              .collection(FBTable.foodTable)
              .where('shop_id', isEqualTo: shopID)
              .get();
      for (DocumentSnapshot doc in shopCollectionRef.docs) {
        Map<String, dynamic>? foodJson = doc.data() as Map<String, dynamic>?;
        Dish dish = Dish.fromJson(foodJson!);
        foods.add(dish);
      }

      state = foods;
    } catch (err) {
      return Future.error(err);
    }
  }
}
