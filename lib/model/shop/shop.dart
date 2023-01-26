import 'package:json_annotation/json_annotation.dart';
import 'package:ncart_eats/helpers/utilities.dart';

part 'shop.g.dart';

@JsonSerializable()
class Shop {
  final int? id;
  final String? name;
  final List<String>? cuisines;
  final String? street;
  final String? landmark;
  final String? location;
  final String? latitude;
  final String? longitude;
  @JsonKey(name: 'open_time')
  final String? openTime;
  @JsonKey(name: 'close_time')
  final String? closeTime;
  final double? rating;
  @JsonKey(name: 'review_count')
  final int? reviewCount;
  @JsonKey(name: 'delivery_time')
  final String? deliveryTime;
  final String? logo;
  final String? image;
  @JsonKey(name: 'has_free_delivery', defaultValue: false)
  final bool? hasFreeDelivery;

  Shop(
      {this.id,
      this.name,
      this.cuisines,
      this.street,
      this.landmark,
      this.location,
      this.latitude,
      this.longitude,
      this.openTime,
      this.closeTime,
      this.rating,
      this.reviewCount,
      this.deliveryTime,
      this.logo,
      this.image,
      this.hasFreeDelivery});

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  Map<String, dynamic> toJson() => _$ShopToJson(this);

  String getRatingAndReview() {
    String embeddedString = "";
    if (rating! > 0) {
      embeddedString = "$rating";
    }

    if (reviewCount! > 0) {
      embeddedString += " (${Utilities.viewCountFormatter(reviewCount!)})";
    }

    return embeddedString;
  }
}
