import 'package:json_annotation/json_annotation.dart';

import 'country_item.dart';

part 'country_response.g.dart';

@JsonSerializable()
class CountryResponse {
  final List<CountryItem> result;

  const CountryResponse({required this.result});

  factory CountryResponse.fromJson(Map<String, dynamic> json) =>
      _$CountryResponseFromJson(json);
}
