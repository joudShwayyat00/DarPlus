import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/amenities_response.dart';
import '../models/asset_detail_response.dart';
import '../models/assets_response.dart';

part 'assets_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class AssetsServiceClient {
  factory AssetsServiceClient(Dio dio, {String baseUrl}) = _AssetsServiceClient;

  @GET("${ApiConstants.assets}/{lang}")
  Future<AssetsResponse> getAssets(
    @Path("lang") String lang, {
    @Query("category_id") int? categoryId,
  });

  @GET(ApiConstants.topRatedAssets)
  Future<AssetsResponse> getTopRatedAssets();

  @GET("${ApiConstants.assetDetail}/{id}/{lang}")
  Future<AssetDetailResponse> getAssetDetail(
    @Path("id") int id,
    @Path("lang") String lang,
  );

  @GET("${ApiConstants.amenities}/{lang}")
  Future<AmenitiesResponse> getAmenities(@Path("lang") String lang);
}
