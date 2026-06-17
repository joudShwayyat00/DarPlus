import 'package:json_annotation/json_annotation.dart';

part 'rate_asset_response.g.dart';

@JsonSerializable()
class RateAssetResponse {
  final String message;
  final RateAssetData data;

  const RateAssetResponse({required this.message, required this.data});

  factory RateAssetResponse.fromJson(Map<String, dynamic> json) =>
      _$RateAssetResponseFromJson(json);
}

@JsonSerializable()
class RateAssetData {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'owner_id')
  final int? ownerId;
  @JsonKey(name: 'asset_id')
  final int assetId;
  @JsonKey(fromJson: _ratingFromJson)
  final int rating;
  final String? comment;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const RateAssetData({
    required this.id,
    required this.userId,
    this.ownerId,
    required this.assetId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory RateAssetData.fromJson(Map<String, dynamic> json) =>
      _$RateAssetDataFromJson(json);

  static int _ratingFromJson(dynamic value) {
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
