import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/helpers/shared_preference.dart';
import 'package:ncart_eats/model/cart/cart.dart';
import 'package:ncart_eats/model/dish/dish.dart';
import 'package:ncart_eats/model/shop/shop.dart';

class CartInfoService extends StateNotifier<List<Cart>> {
  CartInfoService() : super([]);

  Future<void> fetchCartInfo() async {
    List<Cart> currentCarts = await SharedPreferenceHelper.shared.getCart();

    state = currentCarts;
  }

  void addOrUpdateCartItem(
      Dish dishInfo, int quantity, bool keepEmpty, Shop shopInfo) {
    List<Cart> carts = [...state];
    if (keepEmpty) {
      carts.clear();
    }

    if (quantity > 0) {
      int index = carts.indexWhere((Cart cart) => cart.dishID == dishInfo.id);
      Cart currentCart = Cart(
          id: DateTime.now().millisecondsSinceEpoch.toDouble(),
          shopID: shopInfo.id!,
          shopName: shopInfo.name!,
          dishID: dishInfo.id,
          dishName: dishInfo.name,
          price: dishInfo.price,
          type: dishInfo.type,
          quantity: quantity);

      if (index >= 0) {
        carts[index] = currentCart;
      } else {
        carts.add(currentCart);
      }
    } else {
      carts.removeWhere((Cart cart) => cart.dishID == dishInfo.id);
    }

    state = carts;
  }
}
