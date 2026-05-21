// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetsResponse _$AssetsResponseFromJson(Map<String, dynamic> json) =>
    AssetsResponse(
      result: (json['result'] as List<dynamic>)
          .map((e) => AssetItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors: json['errors'] as List<dynamic>,
      message: json['message'] as String,
    );

Map<String, dynamic> _$AssetsResponseToJson(AssetsResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'errors': instance.errors,
      'message': instance.message,
    };
