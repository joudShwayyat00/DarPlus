import 'package:json_annotation/json_annotation.dart';

part 'appointment_response.g.dart';

@JsonSerializable()
class AppointmentResponse {
  final String message;
  final AppointmentData data;

  AppointmentResponse({required this.message, required this.data});

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentResponseToJson(this);
}

@JsonSerializable()
class AppointmentData {
  final int id;
  @JsonKey(name: 'asset_id')
  final int assetId;
  @JsonKey(name: 'user_id')
  final int? userId;
  final String name;
  final String phone;
  final String email;
  final String date;
  final String time;
  final String? note;

  AppointmentData({
    required this.id,
    required this.assetId,
    this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.date,
    required this.time,
    this.note,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) =>
      _$AppointmentDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentDataToJson(this);
}
