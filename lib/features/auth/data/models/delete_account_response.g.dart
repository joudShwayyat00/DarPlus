// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteAccountResponse _$DeleteAccountResponseFromJson(
  Map<String, dynamic> json,
) => DeleteAccountResponse(
  status: json['status'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$DeleteAccountResponseToJson(
  DeleteAccountResponse instance,
) => <String, dynamic>{'status': instance.status, 'message': instance.message};
