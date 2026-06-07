// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentResponse _$AppointmentResponseFromJson(Map<String, dynamic> json) =>
    AppointmentResponse(
      message: json['message'] as String,
      data: AppointmentData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppointmentResponseToJson(
  AppointmentResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

AppointmentData _$AppointmentDataFromJson(Map<String, dynamic> json) =>
    AppointmentData(
      id: (json['id'] as num).toInt(),
      assetId: (json['asset_id'] as num).toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$AppointmentDataToJson(AppointmentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'asset_id': instance.assetId,
      'user_id': instance.userId,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'date': instance.date,
      'time': instance.time,
      'note': instance.note,
    };
