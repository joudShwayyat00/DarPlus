// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_appointment_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyAppointmentItem _$MyAppointmentItemFromJson(Map<String, dynamic> json) =>
    MyAppointmentItem(
      id: (json['id'] as num).toInt(),
      assetId: (json['asset_id'] as num).toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      note: json['note'] as String?,
      status: json['status'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$MyAppointmentItemToJson(MyAppointmentItem instance) =>
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
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
