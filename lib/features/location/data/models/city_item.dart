import 'package:json_annotation/json_annotation.dart';

part 'city_item.g.dart';

@JsonSerializable()
class CityItem {
  final int id;
  final String name;

  const CityItem({required this.id, required this.name});

  factory CityItem.fromJson(Map<String, dynamic> json) =>
      _$CityItemFromJson(json);
}
