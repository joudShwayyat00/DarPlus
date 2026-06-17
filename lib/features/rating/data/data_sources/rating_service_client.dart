import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/rate_asset_response.dart';

part 'rating_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class RatingServiceClient {
  factory RatingServiceClient(Dio dio, {String baseUrl}) = _RatingServiceClient;

  @POST(ApiConstants.rateAsset)
  @MultiPart()
  Future<RateAssetResponse> rateAsset({
    @Part(name: 'rating') required int rating,
    @Part(name: 'asset_id') required int assetId,
    @Part(name: 'comment') String? comment,
  });
}
