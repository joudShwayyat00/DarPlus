import 'package:json_annotation/json_annotation.dart';

import 'asset_item.dart';

part 'assets_response.g.dart';

@JsonSerializable()
class AssetsResponse {
  final List<AssetItem> result;
  final List<dynamic> errors;
  final String message;

  AssetsResponse({
    required this.result,
    required this.errors,
    required this.message,
  });

  factory AssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsResponseToJson(this);
}
