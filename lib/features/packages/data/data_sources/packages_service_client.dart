import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/packages_response.dart';

part 'packages_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class PackagesServiceClient {
  factory PackagesServiceClient(Dio dio, {String baseUrl}) =
      _PackagesServiceClient;

  @GET('${ApiConstants.packages}/{lang}')
  Future<PackagesResponse> getPackages(@Path('lang') String lang);
}
