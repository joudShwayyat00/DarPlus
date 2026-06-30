import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/owner_detail.dart';
import '../models/owner_statistics_response.dart';
import '../models/owners_response.dart';

part 'owners_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class OwnersServiceClient {
  factory OwnersServiceClient(Dio dio, {String baseUrl}) = _OwnersServiceClient;

  @GET(ApiConstants.owners)
  Future<OwnersResponse> getOwners();

  @GET("${ApiConstants.ownerDetail}/{id}")
  Future<OwnerDetailResponse> getOwnerDetail(@Path("id") int id);

  @GET(ApiConstants.ownerStatistics)
  Future<OwnerStatisticsResponse> getOwnerStatistics();
}
