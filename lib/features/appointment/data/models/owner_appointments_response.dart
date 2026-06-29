import 'package:json_annotation/json_annotation.dart';

import 'my_appointment_item.dart';

part 'owner_appointments_response.g.dart';

@JsonSerializable()
class OwnerAppointmentsResponse {
  final String message;
  final OwnerAppointmentsPage data;

  OwnerAppointmentsResponse({required this.message, required this.data});

  factory OwnerAppointmentsResponse.fromJson(Map<String, dynamic> json) =>
      _$OwnerAppointmentsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerAppointmentsResponseToJson(this);
}

@JsonSerializable()
class OwnerAppointmentsPage {
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'last_page')
  final int lastPage;
  final int total;
  @JsonKey(name: 'per_page')
  final int perPage;
  final List<MyAppointmentItem> data;

  OwnerAppointmentsPage({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
    required this.data,
  });

  bool get hasNextPage => currentPage < lastPage;

  factory OwnerAppointmentsPage.fromJson(Map<String, dynamic> json) =>
      _$OwnerAppointmentsPageFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerAppointmentsPageToJson(this);
}
