import 'package:json_annotation/json_annotation.dart';

part 'contact_us_submit_response.g.dart';

@JsonSerializable()
class ContactUsSubmitResponse {
  final List<dynamic> errors;
  final String message;
  final String result;

  const ContactUsSubmitResponse({
    required this.errors,
    required this.message,
    required this.result,
  });

  factory ContactUsSubmitResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactUsSubmitResponseFromJson(json);

  bool get isSuccess => errors.isEmpty;

  String get displayMessage {
    if (result.trim().isNotEmpty) return result.trim();
    if (message.trim().isNotEmpty) return message.trim();
    return '';
  }
}
