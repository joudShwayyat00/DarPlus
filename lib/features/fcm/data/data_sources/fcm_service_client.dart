import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/update_device_token_response.dart';

part 'fcm_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class FcmServiceClient {
  factory FcmServiceClient(Dio dio, {String baseUrl}) = _FcmServiceClient;

  @POST(ApiConstants.updateDeviceToken)
  @MultiPart()
  Future<UpdateDeviceTokenResponse> updateDeviceToken(
    @Part(name: 'user_id') String userId,
    @Part(name: 'fcm_token') String fcmToken,
  );
}
