import 'package:json_annotation/json_annotation.dart';

part 'asset_amenity.g.dart';

@JsonSerializable()
class AssetAmenity {
  final int id;
  final String name;
  final String icon;

  const AssetAmenity({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory AssetAmenity.fromJson(Map<String, dynamic> json) =>
      _$AssetAmenityFromJson(json);

  Map<String, dynamic> toJson() => _$AssetAmenityToJson(this);
}
