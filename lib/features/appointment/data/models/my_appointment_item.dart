import 'package:json_annotation/json_annotation.dart';

part 'my_appointment_item.g.dart';

@JsonSerializable()
class MyAppointmentItem {
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
  final String status;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const MyAppointmentItem({
    required this.id,
    required this.assetId,
    this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.date,
    required this.time,
    this.note,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory MyAppointmentItem.fromJson(Map<String, dynamic> json) =>
      _$MyAppointmentItemFromJson(json);

  Map<String, dynamic> toJson() => _$MyAppointmentItemToJson(this);
}
