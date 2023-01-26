
import 'package:json_annotation/json_annotation.dart';

part 'offer.g.dart';

@JsonSerializable()
class Offer {
  final int? id;
  final String? image;
  final String? type;

  @JsonKey(name: 'offer_id')
  final int? offerID;

  @JsonKey(name: 'offer_url')
  final String? offerURL;

  Offer({this.id, this.image, this.type, this.offerID, this.offerURL});

  factory Offer.fromJson(Map<String, dynamic> json) =>
      _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
