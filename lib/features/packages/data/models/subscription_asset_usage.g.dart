// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_asset_usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionAssetUsage _$SubscriptionAssetUsageFromJson(
  Map<String, dynamic> json,
) => SubscriptionAssetUsage(
  used: (json['used'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  remaining: (json['remaining'] as num).toInt(),
);

Map<String, dynamic> _$SubscriptionAssetUsageToJson(
  SubscriptionAssetUsage instance,
) => <String, dynamic>{
  'used': instance.used,
  'limit': instance.limit,
  'remaining': instance.remaining,
};
