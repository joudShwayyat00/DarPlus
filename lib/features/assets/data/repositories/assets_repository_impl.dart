import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../../domain/repositories/assets_repository.dart';
import '../data_sources/assets_service_client.dart';
import '../models/amenity_item.dart';
import '../models/asset_item.dart';

class AssetsRepositoryImpl implements AssetsRepository {
  final AssetsServiceClient _serviceClient;

  AssetsRepositoryImpl(this._serviceClient);

  @override
  Future<AssetsPage> getAssets(
    String lang, {
    int? categoryId,
    int page = 1,
  }) async {
    final response = await _serviceClient.getAssets(
      lang,
      categoryId: categoryId,
      page: page,
    );
    return AssetsPage(
      items: response.items,
      hasMore: response.meta.hasNextPage,
    );
  }

  @override
  Future<AssetsPage> getMyAssets(
    String lang, {
    int? categoryId,
    int page = 1,
  }) async {
    final response = await _serviceClient.getMyAssets(
      lang,
      categoryId: categoryId,
      page: page,
    );
    return AssetsPage(
      items: response.items,
      hasMore: response.meta.hasNextPage,
    );
  }

  @override
  Future<List<AssetItem>> getTopRatedAssets() async {
    final response = await _serviceClient.getTopRatedAssets();
    return response.result;
  }

  @override
  Future<AssetItem> getAssetDetail({
    required int id,
    required String lang,
  }) async {
    final response = await _serviceClient.getAssetDetail(id, lang);
    return response.result;
  }

  @override
  Future<List<AmenityItem>> getAmenities(String lang) async {
    final response = await _serviceClient.getAmenities(lang);
    return response.data;
  }

  @override
  Future<AssetsPage> filterAssets(
    String lang, {
    int? cityId,
    int? regionId,
    String? location,
    String? type,
    int? ownerId,
    int? categoryId,
    String? rentType,
    double? minPrice,
    double? maxPrice,
    int page = 1,
  }) async {
    final response = await _serviceClient.filterAssets(
      lang,
      cityId: cityId,
      regionId: regionId,
      location: location,
      type: type,
      ownerId: ownerId,
      categoryId: categoryId,
      rentType: rentType,
      minPrice: minPrice,
      maxPrice: maxPrice,
      page: page,
    );
    return AssetsPage(
      items: response.items,
      hasMore: response.meta.hasNextPage,
    );
  }

  @override
  Future<void> addAsset({
    required String nameEn,
    required String nameAr,
    required String descriptionEn,
    required String descriptionAr,
    required int categoryId,
    required double price,
    required String imagePath,
    String? video,
    required String location,
    required String email,
    required String phone,
    required String type,
    String? rentType,
    int? monthsCount,
    int? yearsCount,
    int? daysCount,
    double? rentPrice,
    double? dayPrice,
    String? checkInTime,
    String? checkOutTime,
    required double latitude,
    required double longitude,
    required List<int> amenityIds,
    required int countryId,
    required int cityId,
    required int regionId,
  }) async {
    final dio = DioFactory.getDio();
    final formData = FormData.fromMap({
      'name_en': nameEn,
      'name_ar': nameAr,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
      'category_id': categoryId,
      'price': price,
      'image': await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      ),
      if (video != null && video.isNotEmpty) 'video': video,
      'location': location,
      'email': email,
      'phone': phone,
      'type': type,
      if (rentType != null) 'rent_type': rentType,
      if (monthsCount != null) 'months_count': monthsCount,
      if (yearsCount != null) 'years_count': yearsCount,
      if (daysCount != null) 'days_count': daysCount,
      if (rentPrice != null) 'rent_price': rentPrice,
      if (dayPrice != null) 'day_price': dayPrice,
      if (checkInTime != null && checkInTime.isNotEmpty)
        'check_in_time': checkInTime,
      if (checkOutTime != null && checkOutTime.isNotEmpty)
        'check_out_time': checkOutTime,
      'latitude': latitude,
      'longitude': longitude,
      'amenities_ids': jsonEncode(amenityIds),
      'country_id': countryId,
      'city_id': cityId,
      'region_id': regionId,
    });
    await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.addAsset}',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<void> updateAsset({
    required int assetId,
    required String nameEn,
    required String nameAr,
    required String descriptionEn,
    required String descriptionAr,
    required int categoryId,
    required double price,
    String? imagePath,
    String? video,
    required String location,
    required String email,
    required String phone,
    required String type,
    String? rentType,
    int? monthsCount,
    int? yearsCount,
    int? daysCount,
    double? rentPrice,
    double? dayPrice,
    String? checkInTime,
    String? checkOutTime,
    required double latitude,
    required double longitude,
    required List<int> amenityIds,
    required int countryId,
    required int cityId,
    required int regionId,
  }) async {
    final dio = DioFactory.getDio();
    final formData = FormData.fromMap({
      'asset_id': assetId,
      'name_en': nameEn,
      'name_ar': nameAr,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
      'category_id': categoryId,
      'price': price,
      if (imagePath != null)
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      if (video != null && video.isNotEmpty) 'video': video,
      'location': location,
      'email': email,
      'phone': phone,
      'type': type,
      if (rentType != null) 'rent_type': rentType,
      if (monthsCount != null) 'months_count': monthsCount,
      if (yearsCount != null) 'years_count': yearsCount,
      if (daysCount != null) 'days_count': daysCount,
      if (rentPrice != null) 'rent_price': rentPrice,
      if (dayPrice != null) 'day_price': dayPrice,
      if (checkInTime != null && checkInTime.isNotEmpty)
        'check_in_time': checkInTime,
      if (checkOutTime != null && checkOutTime.isNotEmpty)
        'check_out_time': checkOutTime,
      'latitude': latitude,
      'longitude': longitude,
      'amenities_ids': jsonEncode(amenityIds),
      'country_id': countryId,
      'city_id': cityId,
      'region_id': regionId,
    });
    await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.updateAsset}',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<void> deleteAsset({required int assetId}) async {
    final dio = DioFactory.getDio();
    final formData = FormData.fromMap({'asset_id': assetId});
    await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.deleteAsset}',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}
