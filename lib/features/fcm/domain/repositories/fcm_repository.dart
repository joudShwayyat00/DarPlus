import '../../data/models/update_device_token_response.dart';

abstract class FcmRepository {
  Future<UpdateDeviceTokenResponse> updateDeviceToken({
    required String userId,
    required String fcmToken,
  });
}
