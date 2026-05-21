import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/assets_response.dart';

part 'assets_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class AssetsServiceClient {
  factory AssetsServiceClient(Dio dio, {String baseUrl}) = _AssetsServiceClient;

  @GET("${ApiConstants.assets}/{lang}")
  Future<AssetsResponse> getAssets(@Path("lang") String lang);
}
