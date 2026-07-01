// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentInfoResponse _$PaymentInfoResponseFromJson(Map<String, dynamic> json) =>
    PaymentInfoResponse(
      bankAccountName: json['bank_account_name'] as String,
      bankAccountNumber: json['bank_account_number'] as String,
      bankIban: json['bank_iban'] as String,
      bankSwift: json['bank_swift'] as String,
      bankCliq: json['bank_cliq'] as String,
      bankPhone: json['bank_phone'] as String,
      bankImage: json['bank_image'] as String?,
    );

Map<String, dynamic> _$PaymentInfoResponseToJson(
  PaymentInfoResponse instance,
) => <String, dynamic>{
  'bank_account_name': instance.bankAccountName,
  'bank_account_number': instance.bankAccountNumber,
  'bank_iban': instance.bankIban,
  'bank_swift': instance.bankSwift,
  'bank_cliq': instance.bankCliq,
  'bank_phone': instance.bankPhone,
  'bank_image': instance.bankImage,
};
