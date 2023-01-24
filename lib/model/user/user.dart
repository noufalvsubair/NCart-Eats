import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String? uid;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;
  final String? mobile;

  @JsonKey(name: 'has_address_added')
  final bool? hasAddressAdded;

  @JsonKey(name: 'has_terms_condition_agreed')
  final bool? hasTermAndConditionAgreed;

  User(
      {this.uid,
      this.firstName,
      this.lastName,
      this.mobile,
      this.hasAddressAdded,
      this.hasTermAndConditionAgreed});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
