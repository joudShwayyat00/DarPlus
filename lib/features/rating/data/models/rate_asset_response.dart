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
  @JsonKey(name: 'user_id', fromJson: _intFromJson)
  final int userId;
  @JsonKey(name: 'owner_id', fromJson: _nullableIntFromJson)
  final int? ownerId;
  @JsonKey(name: 'asset_id', fromJson: _intFromJson)
  final int assetId;
  @JsonKey(fromJson: _intFromJson)
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

  static int _intFromJson(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int? _nullableIntFromJson(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
