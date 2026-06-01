import 'package:json_annotation/json_annotation.dart';

part 'asset_attribute.g.dart';

@JsonSerializable()
class AssetAttribute {
  final int id;
  final String name;
  final String type;
  final String icon;

  const AssetAttribute({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
  });

  factory AssetAttribute.fromJson(Map<String, dynamic> json) =>
      _$AssetAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$AssetAttributeToJson(this);
}
