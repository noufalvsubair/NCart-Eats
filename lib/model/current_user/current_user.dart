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

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  final double? rating;

  CurrentUser(
      {this.uid,
      this.firstName,
      this.lastName,
      this.mobile,
      this.hasAddressAdded,
      this.hasTermAndConditionAgreed,
      this.createdAt,
      this.updatedAt,
      this.rating});

  factory CurrentUser.fromJson(Map<String, dynamic> json) =>
      _$CurrentUserFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentUserToJson(this);

  get fullName => "${firstName!} ${lastName!}";

  get formattedMobile =>
      "${mobile!.substring(0, 3)} - ${mobile!.substring(3, 13)}";

  get joiningDuration => createdAt != null && createdAt!.isNotEmpty
      ? DateTime.now().difference(DateTime.parse(createdAt!)).inDays
      : 0;
}
