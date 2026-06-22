import 'package:json_annotation/json_annotation.dart';

import 'my_appointment_item.dart';

part 'my_appointments_response.g.dart';

@JsonSerializable()
class MyAppointmentsResponse {
  final String message;
  final List<MyAppointmentItem> data;

  MyAppointmentsResponse({required this.message, required this.data});

  factory MyAppointmentsResponse.fromJson(Map<String, dynamic> json) =>
      _$MyAppointmentsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyAppointmentsResponseToJson(this);
}
