// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_appointments_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnerAppointmentsResponse _$OwnerAppointmentsResponseFromJson(
  Map<String, dynamic> json,
) => OwnerAppointmentsResponse(
  message: json['message'] as String,
  data: OwnerAppointmentsPage.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OwnerAppointmentsResponseToJson(
  OwnerAppointmentsResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

OwnerAppointmentsPage _$OwnerAppointmentsPageFromJson(
  Map<String, dynamic> json,
) => OwnerAppointmentsPage(
  currentPage: (json['current_page'] as num).toInt(),
  lastPage: (json['last_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => MyAppointmentItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OwnerAppointmentsPageToJson(
  OwnerAppointmentsPage instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'total': instance.total,
  'per_page': instance.perPage,
  'data': instance.data,
};
