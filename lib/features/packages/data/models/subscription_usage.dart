import 'package:json_annotation/json_annotation.dart';

import 'subscription_asset_usage.dart';

part 'subscription_usage.g.dart';

@JsonSerializable()
class SubscriptionUsage {
  @JsonKey(name: 'sale_assets')
  final SubscriptionAssetUsage saleAssets;
  @JsonKey(name: 'rent_assets')
  final SubscriptionAssetUsage rentAssets;

  const SubscriptionUsage({
    required this.saleAssets,
    required this.rentAssets,
  });

  factory SubscriptionUsage.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionUsageFromJson(json);
}
