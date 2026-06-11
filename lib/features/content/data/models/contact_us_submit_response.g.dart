// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_us_submit_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactUsSubmitResponse _$ContactUsSubmitResponseFromJson(
  Map<String, dynamic> json,
) => ContactUsSubmitResponse(
  errors: json['errors'] as List<dynamic>,
  message: json['message'] as String,
  result: json['result'] as String,
);

Map<String, dynamic> _$ContactUsSubmitResponseToJson(
  ContactUsSubmitResponse instance,
) => <String, dynamic>{
  'errors': instance.errors,
  'message': instance.message,
  'result': instance.result,
};
