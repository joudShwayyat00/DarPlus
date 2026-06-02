import 'package:json_annotation/json_annotation.dart';

part 'amenity_item.g.dart';

@JsonSerializable()
class AmenityItem {
  final int id;
  final String name;
  final String icon;

  const AmenityItem({required this.id, required this.name, required this.icon});

  factory AmenityItem.fromJson(Map<String, dynamic> json) =>
      _$AmenityItemFromJson(json);

  Map<String, dynamic> toJson() => _$AmenityItemToJson(this);
}
