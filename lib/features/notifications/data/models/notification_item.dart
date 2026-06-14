import 'package:json_annotation/json_annotation.dart';

part 'notification_item.g.dart';

@JsonSerializable()
class NotificationItem {
  final String id;
  final String body;
  final String icon;
  final String? url;
  @JsonKey(name: 'book_id')
  final String? bookId;
  @JsonKey(name: 'is_read')
  final bool isRead;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const NotificationItem({
    required this.id,
    required this.body,
    required this.icon,
    this.url,
    this.bookId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
