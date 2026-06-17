// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_asset_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateAssetResponse _$RateAssetResponseFromJson(Map<String, dynamic> json) =>
    RateAssetResponse(
      message: json['message'] as String,
      data: RateAssetData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RateAssetResponseToJson(RateAssetResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

RateAssetData _$RateAssetDataFromJson(Map<String, dynamic> json) =>
    RateAssetData(
      id: (json['id'] as num).toInt(),
      userId: RateAssetData._intFromJson(json['user_id']),
      ownerId: RateAssetData._nullableIntFromJson(json['owner_id']),
      assetId: RateAssetData._intFromJson(json['asset_id']),
      rating: RateAssetData._intFromJson(json['rating']),
      comment: json['comment'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$RateAssetDataToJson(RateAssetData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'owner_id': instance.ownerId,
      'asset_id': instance.assetId,
      'rating': instance.rating,
      'comment': instance.comment,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
