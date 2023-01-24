import 'package:json_annotation/json_annotation.dart';

part 'current_location.g.dart';

@JsonSerializable()
class CurrentLocation {
  final int? id;
  final String? name;
  final double? latitude;
  final double? longitude;
  final String? type;

  CurrentLocation(
      {this.id, this.name, this.latitude, this.longitude, this.type});

  factory CurrentLocation.fromJson(Map<String, dynamic> json) =>
      _$CurrentLocationFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentLocationToJson(this);
}
