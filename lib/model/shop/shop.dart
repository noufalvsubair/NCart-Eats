import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ncart_eats/helpers/utilities.dart';

part 'shop.g.dart';

@JsonSerializable()
class Shop {
  final String? id;
  final String? name;
  final List<String>? cuisines;
  final String? street;
  final String? landmark;
  final String? location;
  final double? latitude;
  final double? longitude;
  @JsonKey(name: 'open_time')
  final String? openTime;
  @JsonKey(name: 'close_time')
  final String? closeTime;
  final double? rating;
  @JsonKey(name: 'review_count')
  final int? reviewCount;
  @JsonKey(name: 'delivery_time')
  final double? deliveryTime;
  final String? logo;
  final String? image;
  @JsonKey(name: 'has_free_delivery', defaultValue: false)
  final bool? hasFreeDelivery;
  bool? hasClosed;

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
      this.hasFreeDelivery,
      this.hasClosed});

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  Map<String, dynamic> toJson() => _$ShopToJson(this);

  get ratingAndReviewCount =>
      "${rating! > 0 ? rating : ""} ${reviewCount! > 0 ? " "
          "(${Utilities.viewCountFormatter(reviewCount!)})" : ""}";

  get timeDuration => deliveryTime != null
      ? "${Duration(seconds: deliveryTime!.toInt()).inMinutes} mins"
      : "";

  get openingTime => openTime != null && openTime!.isNotEmpty
      ? DateFormat.jm().format(DateTime.parse(openTime!))
      : "";
}
