import 'package:json_annotation/json_annotation.dart';

part 'dish.g.dart';

@JsonSerializable()
class Dish {
  final String? id;
  final String? name;
  final String? description;
  final String? type;
  @JsonKey(name: 'is_best_seller')
  final bool? isBestSeller;
  final double? price;
  final double? rating;
  @JsonKey(name: 'review_count')
  final double? reviewCount;
  final String? image;
  @JsonKey(name: 'shop_id')
  final String? shopID;

  Dish(
      {this.id,
      this.name,
      this.description,
      this.type,
      this.isBestSeller,
      this.price,
      this.rating,
      this.reviewCount,
      this.image,
      this.shopID});

  factory Dish.fromJson(Map<String, dynamic> json) =>
      _$DishFromJson(json);

  Map<String, dynamic> toJson() => _$DishToJson(this);
}
