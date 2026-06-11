import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';
import '../models/about_us_response.dart';
import '../models/contact_data_response.dart';
import '../models/contact_us_submit_response.dart';
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

  @GET("${ApiConstants.aboutUs}/{lang}")
  Future<AboutUsResponse> getAboutUs(@Path("lang") String lang);

  @GET(ApiConstants.contactData)
  Future<ContactDataResponse> getContactData();

  @POST(ApiConstants.contactUs)
  @MultiPart()
  Future<ContactUsSubmitResponse> submitContactUs(
    @Part() String name,
    @Part() String email,
    @Part() String phone,
    @Part() String message,
  );
}
