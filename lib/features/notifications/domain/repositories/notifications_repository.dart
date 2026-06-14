import '../../data/models/notification_item.dart';

abstract class NotificationsRepository {
  Future<List<NotificationItem>> getNotifications(String lang);
}
