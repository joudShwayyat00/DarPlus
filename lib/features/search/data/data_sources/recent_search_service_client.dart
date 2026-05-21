import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';

part 'recent_search_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class RecentSearchServiceClient {
  factory RecentSearchServiceClient(Dio dio, {String baseUrl}) =
      _RecentSearchServiceClient;

  @GET(ApiConstants.recentSearches)
  Future<List<String>> getRecentSearches();
}
