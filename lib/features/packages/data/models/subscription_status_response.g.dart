// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionStatusResponse _$SubscriptionStatusResponseFromJson(
  Map<String, dynamic> json,
) => SubscriptionStatusResponse(
  status: json['status'] as bool?,
  subscriptionStatus: json['subscription_status'] as String? ?? '',
  message: json['message'] as String? ?? '',
  daysRemaining: (json['days_remaining'] as num?)?.toInt(),
  expiresAt: json['expires_at'] as String?,
);

Map<String, dynamic> _$SubscriptionStatusResponseToJson(
  SubscriptionStatusResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'subscription_status': instance.subscriptionStatus,
  'message': instance.message,
  'days_remaining': instance.daysRemaining,
  'expires_at': instance.expiresAt,
};
