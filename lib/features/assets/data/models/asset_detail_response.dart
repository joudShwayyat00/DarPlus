import 'package:json_annotation/json_annotation.dart';

import 'asset_item.dart';

part 'asset_detail_response.g.dart';

/// Single-item response from GET /api/the_asset/{id}/{lang}
@JsonSerializable()
class AssetDetailResponse {
  final AssetItem result;
  final List<dynamic> errors;
  final String message;

  AssetDetailResponse({
    required this.result,
    required this.errors,
    required this.message,
  });

  factory AssetDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetDetailResponseToJson(this);
}
