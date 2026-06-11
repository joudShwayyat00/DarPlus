// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionResponse _$RegionResponseFromJson(Map<String, dynamic> json) =>
    RegionResponse(
      items: (json['data'] as List<dynamic>)
          .map((e) => RegionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RegionResponseToJson(RegionResponse instance) =>
    <String, dynamic>{'data': instance.items};
