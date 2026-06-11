import 'package:json_annotation/json_annotation.dart';

import 'region_item.dart';

part 'region_response.g.dart';

@JsonSerializable()
class RegionResponse {
  @JsonKey(name: 'data')
  final List<RegionItem> items;

  const RegionResponse({required this.items});

  factory RegionResponse.fromJson(Map<String, dynamic> json) =>
      _$RegionResponseFromJson(json);
}
