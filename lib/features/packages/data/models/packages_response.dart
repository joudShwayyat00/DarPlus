import 'package:json_annotation/json_annotation.dart';

import 'package_item.dart';

part 'packages_response.g.dart';

@JsonSerializable()
class PackagesResponse {
  @JsonKey(name: 'data')
  final List<PackageItem> items;

  const PackagesResponse({required this.items});

  factory PackagesResponse.fromJson(Map<String, dynamic> json) =>
      _$PackagesResponseFromJson(json);
}
