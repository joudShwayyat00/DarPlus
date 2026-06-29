// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_block_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarBlockResponse _$CalendarBlockResponseFromJson(
  Map<String, dynamic> json,
) => CalendarBlockResponse(
  status: json['status'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$CalendarBlockResponseToJson(
  CalendarBlockResponse instance,
) => <String, dynamic>{'status': instance.status, 'message': instance.message};
