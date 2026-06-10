import 'package:json_annotation/json_annotation.dart';

part 'country_item.g.dart';

@JsonSerializable()
class CountryItem {
  final int id;
  final String name;
  final String prefix;
  @JsonKey(name: 'iso_code')
  final String isoCode;
  final String image;
  final int order;

  const CountryItem({
    required this.id,
    required this.name,
    required this.prefix,
    required this.isoCode,
    required this.image,
    required this.order,
  });

  factory CountryItem.fromJson(Map<String, dynamic> json) =>
      _$CountryItemFromJson(json);
}
