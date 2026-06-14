import '../../domain/repositories/notifications_repository.dart';
import '../data_sources/notifications_service_client.dart';
import '../models/notification_item.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsServiceClient _client;

  NotificationsRepositoryImpl(this._client);

  @override
  Future<List<NotificationItem>> getNotifications(String lang) async {
    final response = await _client.getNotifications(lang);
    return response.notifications;
  }
}
