// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) =>
    NotificationItem(
      id: json['id'] as String,
      body: json['body'] as String,
      icon: json['icon'] as String,
      url: json['url'] as String?,
      bookId: json['book_id'] as String?,
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$NotificationItemToJson(NotificationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'icon': instance.icon,
      'url': instance.url,
      'book_id': instance.bookId,
      'is_read': instance.isRead,
      'created_at': instance.createdAt,
    };
