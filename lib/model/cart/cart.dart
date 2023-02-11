import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
class Cart {
  final double? id;
  final String? shopID;
  final String? shopName;
  final String? dishID;
  final String? dishName;
  final int? quantity;
  final double? price;
  final String? type;

  Cart(
      {this.id,
      this.shopID,
      this.shopName,
      this.dishID,
      this.dishName,
      this.quantity,
      this.price,
      this.type});

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);
}
