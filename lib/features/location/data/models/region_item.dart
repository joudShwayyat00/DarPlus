import 'package:json_annotation/json_annotation.dart';

part 'region_item.g.dart';

@JsonSerializable()
class RegionItem {
  final int id;
  final String name;

  const RegionItem({required this.id, required this.name});

  factory RegionItem.fromJson(Map<String, dynamic> json) =>
      _$RegionItemFromJson(json);
}
