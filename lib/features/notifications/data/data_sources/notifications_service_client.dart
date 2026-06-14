import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/notifications_response.dart';

part 'notifications_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class NotificationsServiceClient {
  factory NotificationsServiceClient(Dio dio, {String baseUrl}) =
      _NotificationsServiceClient;

  @GET('${ApiConstants.notifications}/{lang}')
  Future<NotificationsResponse> getNotifications(@Path('lang') String lang);
}
