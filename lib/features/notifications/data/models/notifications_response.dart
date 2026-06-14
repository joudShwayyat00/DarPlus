import 'package:json_annotation/json_annotation.dart';

import 'notification_item.dart';

part 'notifications_response.g.dart';

@JsonSerializable()
class NotificationsResponse {
  final List<NotificationItem> notifications;

  const NotificationsResponse({required this.notifications});

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);
}
