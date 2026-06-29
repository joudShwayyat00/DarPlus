import 'package:json_annotation/json_annotation.dart';

part 'calendar_block_response.g.dart';

@JsonSerializable()
class CalendarBlockResponse {
  final bool status;
  final String message;

  const CalendarBlockResponse({
    required this.status,
    required this.message,
  });

  factory CalendarBlockResponse.fromJson(Map<String, dynamic> json) =>
      _$CalendarBlockResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarBlockResponseToJson(this);
}
