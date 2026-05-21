import 'package:json_annotation/json_annotation.dart';

part 'asset_owner.g.dart';

@JsonSerializable()
class AssetOwner {
  final int id;
  final String name;
  final String email;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String? image;
  final String status;
  final String role;
  final double? rating;

  const AssetOwner({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.image,
    required this.status,
    required this.role,
    this.rating,
  });

  factory AssetOwner.fromJson(Map<String, dynamic> json) =>
      _$AssetOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$AssetOwnerToJson(this);
}
