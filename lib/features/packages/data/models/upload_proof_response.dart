import 'package:json_annotation/json_annotation.dart';

part 'upload_proof_response.g.dart';

@JsonSerializable()
class UploadProofResponse {
  final bool? status;
  final String message;

  UploadProofResponse({
    this.status,
    required this.message,
  });

  factory UploadProofResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadProofResponseFromJson(json);
}
