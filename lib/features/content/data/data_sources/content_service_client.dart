import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';
import '../models/content_page_response.dart';

part 'content_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ContentServiceClient {
  factory ContentServiceClient(Dio dio, {String baseUrl}) =
      _ContentServiceClient;

  @GET("${ApiConstants.termsAndConditions}/{lang}")
  Future<ContentPageResponse> getTerms(@Path("lang") String lang);

  @GET("${ApiConstants.privacyPolicy}/{lang}")
  Future<ContentPageResponse> getPrivacyPolicy(@Path("lang") String lang);
}
