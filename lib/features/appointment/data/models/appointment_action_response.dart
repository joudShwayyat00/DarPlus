import 'package:json_annotation/json_annotation.dart';

part 'appointment_action_response.g.dart';

@JsonSerializable()
class AppointmentActionResponse {
  final String message;

  AppointmentActionResponse({required this.message});

  factory AppointmentActionResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentActionResponseToJson(this);
}
