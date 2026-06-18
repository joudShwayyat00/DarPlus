// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owners_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnersResponse _$OwnersResponseFromJson(Map<String, dynamic> json) =>
    OwnersResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => AssetOwner.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OwnersResponseToJson(OwnersResponse instance) =>
    <String, dynamic>{'data': instance.data};
