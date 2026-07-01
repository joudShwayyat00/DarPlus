import 'package:json_annotation/json_annotation.dart';

part 'delete_account_response.g.dart';

@JsonSerializable()
class DeleteAccountResponse {
  final bool status;
  final String message;

  DeleteAccountResponse({
    required this.status,
    required this.message,
  });

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAccountResponseToJson(this);
}
