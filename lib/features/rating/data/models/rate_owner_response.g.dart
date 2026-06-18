// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_owner_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateOwnerResponse _$RateOwnerResponseFromJson(Map<String, dynamic> json) =>
    RateOwnerResponse(
      message: json['message'] as String,
      data: RateOwnerData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RateOwnerResponseToJson(RateOwnerResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

RateOwnerData _$RateOwnerDataFromJson(Map<String, dynamic> json) =>
    RateOwnerData(
      id: (json['id'] as num).toInt(),
      userId: RateOwnerData._intFromJson(json['user_id']),
      ownerId: RateOwnerData._intFromJson(json['owner_id']),
      rating: RateOwnerData._intFromJson(json['rating']),
      comment: json['comment'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$RateOwnerDataToJson(RateOwnerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'owner_id': instance.ownerId,
      'rating': instance.rating,
      'comment': instance.comment,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
