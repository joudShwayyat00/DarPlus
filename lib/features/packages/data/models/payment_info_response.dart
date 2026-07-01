import 'package:json_annotation/json_annotation.dart';

part 'payment_info_response.g.dart';

@JsonSerializable()
class PaymentInfoResponse {
  @JsonKey(name: 'bank_account_name')
  final String bankAccountName;
  @JsonKey(name: 'bank_account_number')
  final String bankAccountNumber;
  @JsonKey(name: 'bank_iban')
  final String bankIban;
  @JsonKey(name: 'bank_swift')
  final String bankSwift;
  @JsonKey(name: 'bank_cliq')
  final String bankCliq;
  @JsonKey(name: 'bank_phone')
  final String bankPhone;
  @JsonKey(name: 'bank_image')
  final String? bankImage;

  const PaymentInfoResponse({
    required this.bankAccountName,
    required this.bankAccountNumber,
    required this.bankIban,
    required this.bankSwift,
    required this.bankCliq,
    required this.bankPhone,
    this.bankImage,
  });

  factory PaymentInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentInfoResponseFromJson(json);
}
