// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_subscription_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MySubscriptionItem _$MySubscriptionItemFromJson(Map<String, dynamic> json) =>
    MySubscriptionItem(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String,
      startsAt: json['starts_at'] as String,
      expiresAt: json['expires_at'] as String,
      daysRemaining: (json['days_remaining'] as num).toInt(),
      package: PackageItem.fromJson(json['package'] as Map<String, dynamic>),
      usage: SubscriptionUsage.fromJson(json['usage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MySubscriptionItemToJson(MySubscriptionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'starts_at': instance.startsAt,
      'expires_at': instance.expiresAt,
      'days_remaining': instance.daysRemaining,
      'package': instance.package,
      'usage': instance.usage,
    };
