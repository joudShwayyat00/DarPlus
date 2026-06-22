import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../controller/local_provider.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/data_sources/notifications_service_client.dart';
import '../../data/models/notification_item.dart';
import '../../data/repositories/notifications_repository_impl.dart';
import '../../domain/repositories/notifications_repository.dart';

part 'notifications_providers.g.dart';

@riverpod
NotificationsServiceClient notificationsServiceClient(Ref ref) {
  return NotificationsServiceClient(DioFactory.getDio());
}

@riverpod
NotificationsRepository notificationsRepository(Ref ref) {
  return NotificationsRepositoryImpl(
    ref.watch(notificationsServiceClientProvider),
  );
}

@riverpod
class NotificationsController extends _$NotificationsController {
  @override
  FutureOr<List<NotificationItem>> build() async {
    if (!ref.read(isLoggedInProvider)) return [];
    final lang = ref.watch(apiLanguageCodeProvider);
    return ref.read(notificationsRepositoryProvider).getNotifications(lang);
  }

  Future<void> refresh() async {
    if (!ref.read(isLoggedInProvider)) {
      state = const AsyncData([]);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final lang = ref.read(apiLanguageCodeProvider);
      return ref.read(notificationsRepositoryProvider).getNotifications(lang);
    });
  }
}
