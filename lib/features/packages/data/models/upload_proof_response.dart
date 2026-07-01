import 'package:json_annotation/json_annotation.dart';

part 'upload_proof_response.g.dart';

@JsonSerializable()
class UploadProofResponse {
  @JsonKey(fromJson: _readStatus)
  final bool? status;
  final String message;

  UploadProofResponse({
    this.status,
    required this.message,
  });

  factory UploadProofResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadProofResponseFromJson(json);

  static bool? _readStatus(dynamic value) {
    if (value == true || value == 1) return true;
    if (value == false || value == 0) return false;
    if (value is String) {
      final normalized = value.toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }
}
