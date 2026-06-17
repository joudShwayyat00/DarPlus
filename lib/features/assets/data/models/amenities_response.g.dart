// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amenities_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmenitiesResponse _$AmenitiesResponseFromJson(Map<String, dynamic> json) =>
    AmenitiesResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => AmenityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AmenitiesResponseToJson(AmenitiesResponse instance) =>
    <String, dynamic>{'data': instance.data};
