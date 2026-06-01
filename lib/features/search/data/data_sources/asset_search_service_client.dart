import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../../../assets/data/models/assets_response.dart';

part 'asset_search_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class AssetSearchServiceClient {
  factory AssetSearchServiceClient(Dio dio, {String baseUrl}) =
      _AssetSearchServiceClient;

  @POST(ApiConstants.search)
  @MultiPart()
  Future<AssetsResponse> searchAssets(@Part(name: 'search') String query);
}
