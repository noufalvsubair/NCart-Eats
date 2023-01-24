import 'package:json_annotation/json_annotation.dart';

part 'current_user.g.dart';

@JsonSerializable()
class CurrentUser {
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

  CurrentUser(
      {this.uid,
      this.firstName,
      this.lastName,
      this.mobile,
      this.hasAddressAdded,
      this.hasTermAndConditionAgreed});

  factory CurrentUser.fromJson(Map<String, dynamic> json) =>
      _$CurrentUserFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentUserToJson(this);
}
