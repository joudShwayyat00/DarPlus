// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_callback_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentCallbackResponse _$PaymentCallbackResponseFromJson(
  Map<String, dynamic> json,
) => PaymentCallbackResponse(
  message: json['message'] as String,
  result: json['result'] == null
      ? null
      : PaymentCallbackResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaymentCallbackResponseToJson(
  PaymentCallbackResponse instance,
) => <String, dynamic>{'message': instance.message, 'result': instance.result};

PaymentCallbackResult _$PaymentCallbackResultFromJson(
  Map<String, dynamic> json,
) => PaymentCallbackResult(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  subscriptionId: json['subscription_id'] as String,
  amount: json['amount'] as String,
  transactionId: json['transaction_id'] as String?,
  receiptImage: json['receipt_image'] as String?,
  status: json['status'] as String,
);

Map<String, dynamic> _$PaymentCallbackResultToJson(
  PaymentCallbackResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'subscription_id': instance.subscriptionId,
  'amount': instance.amount,
  'transaction_id': instance.transactionId,
  'receipt_image': instance.receiptImage,
  'status': instance.status,
};
