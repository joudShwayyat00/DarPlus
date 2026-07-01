import 'package:json_annotation/json_annotation.dart';

part 'payment_callback_response.g.dart';

@JsonSerializable()
class PaymentCallbackResponse {
  final String message;
  final PaymentCallbackResult? result;

  PaymentCallbackResponse({
    required this.message,
    this.result,
  });

  factory PaymentCallbackResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentCallbackResponseFromJson(json);
}

@JsonSerializable()
class PaymentCallbackResult {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'subscription_id')
  final String subscriptionId;
  final String amount;
  @JsonKey(name: 'transaction_id')
  final String? transactionId;
  @JsonKey(name: 'receipt_image')
  final String? receiptImage;
  final String status;

  PaymentCallbackResult({
    required this.id,
    required this.userId,
    required this.subscriptionId,
    required this.amount,
    this.transactionId,
    this.receiptImage,
    required this.status,
  });

  factory PaymentCallbackResult.fromJson(Map<String, dynamic> json) =>
      _$PaymentCallbackResultFromJson(json);
}
