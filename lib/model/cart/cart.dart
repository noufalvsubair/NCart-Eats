import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
class Cart {
  final double? id;
  final String? shopID;
  final List<CartItem>? cartItems;

  Cart({this.id, this.shopID, this.cartItems});

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);
}

@JsonSerializable()
class CartItem {
  final String? dishID;
  final String? name;
  final int? quantity;
  final double? price;
  final String? type;

  CartItem({this.dishID, this.name, this.quantity, this.price, this.type});

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
