// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_proof_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadProofResponse _$UploadProofResponseFromJson(Map<String, dynamic> json) =>
    UploadProofResponse(
      status: json['status'] as bool?,
      message: json['message'] as String,
    );

Map<String, dynamic> _$UploadProofResponseToJson(
  UploadProofResponse instance,
) => <String, dynamic>{'status': instance.status, 'message': instance.message};
