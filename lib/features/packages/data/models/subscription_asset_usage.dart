import 'package:json_annotation/json_annotation.dart';

part 'subscription_asset_usage.g.dart';

@JsonSerializable()
class SubscriptionAssetUsage {
  final int used;
  final int limit;
  final int remaining;

  const SubscriptionAssetUsage({
    required this.used,
    required this.limit,
    required this.remaining,
  });

  factory SubscriptionAssetUsage.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionAssetUsageFromJson(json);

  double get usageRatio => limit > 0 ? used / limit : 0;
}
