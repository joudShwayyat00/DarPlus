// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityResponse _$CityResponseFromJson(Map<String, dynamic> json) => CityResponse(
  items: (json['data'] as List<dynamic>)
      .map((e) => CityItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CityResponseToJson(CityResponse instance) =>
    <String, dynamic>{'data': instance.items};
