import 'package:json_annotation/json_annotation.dart';

part 'subscription_status_response.g.dart';

@JsonSerializable()
class SubscriptionStatusResponse {
  final bool? status;
  @JsonKey(name: 'subscription_status')
  final String subscriptionStatus;
  final String message;
  @JsonKey(name: 'days_remaining')
  final int? daysRemaining;

  const SubscriptionStatusResponse({
    this.status,
    required this.subscriptionStatus,
    required this.message,
    this.daysRemaining,
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

  bool get shouldShowHomeReminder =>
      isPending || isExpired || isExpiringSoon || (status != true && message.isNotEmpty);
}
