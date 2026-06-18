import 'package:json_annotation/json_annotation.dart';

part 'rate_owner_response.g.dart';

@JsonSerializable()
class RateOwnerResponse {
  final String message;
  final RateOwnerData data;

  const RateOwnerResponse({required this.message, required this.data});

  factory RateOwnerResponse.fromJson(Map<String, dynamic> json) =>
      _$RateOwnerResponseFromJson(json);
}

@JsonSerializable()
class RateOwnerData {
  final int id;
  @JsonKey(name: 'user_id', fromJson: _intFromJson)
  final int userId;
  @JsonKey(name: 'owner_id', fromJson: _intFromJson)
  final int ownerId;
  @JsonKey(fromJson: _intFromJson)
  final int rating;
  final String? comment;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const RateOwnerData({
    required this.id,
    required this.userId,
    required this.ownerId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory RateOwnerData.fromJson(Map<String, dynamic> json) =>
      _$RateOwnerDataFromJson(json);

  static int _intFromJson(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
