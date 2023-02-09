import 'package:json_annotation/json_annotation.dart';

part 'offer.g.dart';

@JsonSerializable()
class Offer {
  final String? id;
  final String? image;
  final String? type;

  @JsonKey(name: 'offer_id')
  final String? offerID;

  @JsonKey(name: 'offer_url')
  final String? offerURL;

  @JsonKey(name: 'start_time')
  final String? startTime;

  @JsonKey(name: 'end_time')
  final String? endTime;

  Offer(
      {this.id,
      this.image,
      this.type,
      this.offerID,
      this.offerURL,
      this.startTime,
      this.endTime});

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
