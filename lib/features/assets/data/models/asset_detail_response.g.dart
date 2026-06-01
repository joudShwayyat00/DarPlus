// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetDetailResponse _$AssetDetailResponseFromJson(Map<String, dynamic> json) =>
    AssetDetailResponse(
      result: AssetItem.fromJson(json['result'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>,
      message: json['message'] as String,
    );

Map<String, dynamic> _$AssetDetailResponseToJson(
  AssetDetailResponse instance,
) => <String, dynamic>{
  'result': instance.result,
  'errors': instance.errors,
  'message': instance.message,
};
