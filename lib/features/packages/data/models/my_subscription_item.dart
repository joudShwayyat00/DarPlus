import 'package:json_annotation/json_annotation.dart';

import 'package_item.dart';
import 'subscription_usage.dart';

part 'my_subscription_item.g.dart';

@JsonSerializable()
class MySubscriptionItem {
  final int id;
  final String status;
  @JsonKey(name: 'starts_at')
  final String startsAt;
  @JsonKey(name: 'expires_at')
  final String expiresAt;
  @JsonKey(name: 'days_remaining')
  final int daysRemaining;
  final PackageItem package;
  final SubscriptionUsage usage;

  const MySubscriptionItem({
    required this.id,
    required this.status,
    required this.startsAt,
    required this.expiresAt,
    required this.daysRemaining,
    required this.package,
    required this.usage,
  });

  factory MySubscriptionItem.fromJson(Map<String, dynamic> json) =>
      _$MySubscriptionItemFromJson(json);

  bool get isActive => status.toLowerCase() == 'active';

  bool get needsPayment => status.toLowerCase() == 'pending';

  bool get isExpired =>
      status.toLowerCase() == 'expired' || daysRemaining <= 0 && !needsPayment;

  bool get isExpiringSoon => isActive && daysRemaining > 0 && daysRemaining <= 7;

  double get timeProgress {
    if (package.durationDays <= 0) return 0;
    final elapsed = package.durationDays - daysRemaining;
    return (elapsed / package.durationDays).clamp(0.0, 1.0);
  }
}
