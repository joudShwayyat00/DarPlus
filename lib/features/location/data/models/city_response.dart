import 'package:json_annotation/json_annotation.dart';

import 'city_item.dart';

part 'city_response.g.dart';

@JsonSerializable()
class CityResponse {
  @JsonKey(name: 'data')
  final List<CityItem> items;

  const CityResponse({required this.items});

  factory CityResponse.fromJson(Map<String, dynamic> json) =>
      _$CityResponseFromJson(json);
}
