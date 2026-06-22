// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_appointments_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyAppointmentsResponse _$MyAppointmentsResponseFromJson(
  Map<String, dynamic> json,
) => MyAppointmentsResponse(
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => MyAppointmentItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MyAppointmentsResponseToJson(
  MyAppointmentsResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};
