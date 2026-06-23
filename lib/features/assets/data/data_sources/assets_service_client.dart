import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/amenities_response.dart';
import '../models/asset_detail_response.dart';
import '../models/assets_response.dart';
import '../models/paged_assets_response.dart';

part 'assets_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class AssetsServiceClient {
  factory AssetsServiceClient(Dio dio, {String baseUrl}) = _AssetsServiceClient;

  @GET("${ApiConstants.assets}/{lang}")
  Future<PagedAssetsResponse> getAssets(
    @Path("lang") String lang, {
    @Query("category_id") int? categoryId,
    @Query("page") int? page,
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

  @GET("${ApiConstants.myAssets}/{lang}")
  Future<PagedAssetsResponse> getMyAssets(
    @Path("lang") String lang, {
    @Query("category_id") int? categoryId,
    @Query("page") int? page,
  });

  @GET("${ApiConstants.filter}/{lang}")
  Future<PagedAssetsResponse> filterAssets(
    @Path("lang") String lang, {
    @Query("city_id") int? cityId,
    @Query("region_id") int? regionId,
    @Query("location") String? location,
    @Query("type") String? type,
    @Query("owner_id") int? ownerId,
    @Query("category_id") int? categoryId,
    @Query("rent_type") String? rentType,
    @Query("min_price") double? minPrice,
    @Query("max_price") double? maxPrice,
    @Query("page") int? page,
  });
}
