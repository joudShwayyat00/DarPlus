import 'package:json_annotation/json_annotation.dart';

part 'subscription_status_response.g.dart';

@JsonSerializable()
class SubscriptionStatusResponse {
  final bool? status;
  @JsonKey(name: 'subscription_status', defaultValue: '')
  final String subscriptionStatus;
  @JsonKey(defaultValue: '')
  final String message;
  @JsonKey(name: 'days_remaining')
  final int? daysRemaining;
  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  const SubscriptionStatusResponse({
    this.status,
    this.subscriptionStatus = '',
    this.message = '',
    this.daysRemaining,
    this.expiresAt,
  });

  factory SubscriptionStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatusResponseFromJson(json);

  String get normalizedStatus => subscriptionStatus.toLowerCase();

  bool get isActive => normalizedStatus == 'active';

  bool get isPending => normalizedStatus == 'pending';

  bool get isExpired => normalizedStatus == 'expired';

  bool get canAddListings => status == true && isActive;

  bool get isExpiringSoon =>
      isActive && daysRemaining != null && daysRemaining! > 0 && daysRemaining! <= 7;

  bool get isHealthyActive => isActive && status == true && !isExpiringSoon;

  /// Show on home whenever the API reports a subscription status.
  bool get shouldShowHomeBanner => subscriptionStatus.isNotEmpty;
}
