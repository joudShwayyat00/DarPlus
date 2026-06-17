import '../../domain/repositories/fcm_repository.dart';
import '../data_sources/fcm_service_client.dart';
import '../models/update_device_token_response.dart';

class FcmRepositoryImpl implements FcmRepository {
  final FcmServiceClient _client;

  FcmRepositoryImpl(this._client);

  @override
  Future<UpdateDeviceTokenResponse> updateDeviceToken({
    required String userId,
    required String fcmToken,
  }) {
    return _client.updateDeviceToken(userId, fcmToken);
  }
}
