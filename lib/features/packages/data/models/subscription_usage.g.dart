// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionUsage _$SubscriptionUsageFromJson(Map<String, dynamic> json) =>
    SubscriptionUsage(
      saleAssets: SubscriptionAssetUsage.fromJson(
        json['sale_assets'] as Map<String, dynamic>,
      ),
      rentAssets: SubscriptionAssetUsage.fromJson(
        json['rent_assets'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$SubscriptionUsageToJson(SubscriptionUsage instance) =>
    <String, dynamic>{
      'sale_assets': instance.saleAssets,
      'rent_assets': instance.rentAssets,
    };
