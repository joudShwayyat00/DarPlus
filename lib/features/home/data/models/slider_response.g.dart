// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SliderResponse _$SliderResponseFromJson(Map<String, dynamic> json) =>
    SliderResponse(
      result: (json['result'] as List<dynamic>)
          .map((e) => SliderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors: json['errors'] as List<dynamic>,
      message: json['message'] as String,
    );

Map<String, dynamic> _$SliderResponseToJson(SliderResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'errors': instance.errors,
      'message': instance.message,
    };
