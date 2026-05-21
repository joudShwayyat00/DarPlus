import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';

part 'popular_search_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class PopularSearchServiceClient {
  factory PopularSearchServiceClient(Dio dio, {String baseUrl}) = _PopularSearchServiceClient;

  @GET(ApiConstants.popularSearches)
  Future<List<String>> getPopularSearches();
}
