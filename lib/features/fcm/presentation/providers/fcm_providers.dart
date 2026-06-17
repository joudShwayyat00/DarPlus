import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/fcm_service_client.dart';
import '../../data/repositories/fcm_repository_impl.dart';
import '../../domain/repositories/fcm_repository.dart';

part 'fcm_providers.g.dart';

@riverpod
FcmServiceClient fcmServiceClient(Ref ref) {
  return FcmServiceClient(DioFactory.getDio());
}

@riverpod
FcmRepository fcmRepository(Ref ref) {
  return FcmRepositoryImpl(ref.watch(fcmServiceClientProvider));
}
