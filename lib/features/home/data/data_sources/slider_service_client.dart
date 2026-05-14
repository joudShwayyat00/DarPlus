import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';
import '../models/slider_response.dart';

part 'slider_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class SliderServiceClient {
  factory SliderServiceClient(Dio dio, {String baseUrl}) = _SliderServiceClient;

  @GET("${ApiConstants.sliders}/{lang}")
  Future<SliderResponse> getSliders(@Path("lang") String lang);
}
