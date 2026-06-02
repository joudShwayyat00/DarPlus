// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amenities_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmenitiesResponse _$AmenitiesResponseFromJson(Map<String, dynamic> json) =>
    AmenitiesResponse(
      result: (json['result'] as List<dynamic>)
          .map((e) => AmenityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors: json['errors'] as List<dynamic>,
      message: json['message'] as String,
    );

Map<String, dynamic> _$AmenitiesResponseToJson(AmenitiesResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'errors': instance.errors,
      'message': instance.message,
    };
