import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/asset_api_exception.dart';
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
    List<String> galleryImagePaths = const [],
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
    int? space,
    int? rooms,
    required double latitude,
    required double longitude,
    required List<int> amenityIds,
    required int countryId,
    required int cityId,
    required int regionId,
  }) async {
    final formData = await _buildAssetFormData(
      fields: _assetFormFields(
        nameEn: nameEn,
        nameAr: nameAr,
        descriptionEn: descriptionEn,
        descriptionAr: descriptionAr,
        categoryId: categoryId,
        price: price,
        video: video,
        location: location,
        email: email,
        phone: phone,
        type: type,
        rentType: rentType,
        monthsCount: monthsCount,
        yearsCount: yearsCount,
        daysCount: daysCount,
        rentPrice: rentPrice,
        dayPrice: dayPrice,
        checkInTime: checkInTime,
        checkOutTime: checkOutTime,
        space: space,
        rooms: rooms,
        latitude: latitude,
        longitude: longitude,
        amenityIds: amenityIds,
        countryId: countryId,
        cityId: cityId,
        regionId: regionId,
      ),
      imagePath: imagePath,
      galleryImagePaths: galleryImagePaths,
    );
    await _postAssetFormData(ApiConstants.addAsset, formData);
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
    List<String> galleryImagePaths = const [],
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
    int? space,
    int? rooms,
    required double latitude,
    required double longitude,
    required List<int> amenityIds,
    required int countryId,
    required int cityId,
    required int regionId,
  }) async {
    final formData = await _buildAssetFormData(
      fields: _assetFormFields(
        assetId: assetId,
        nameEn: nameEn,
        nameAr: nameAr,
        descriptionEn: descriptionEn,
        descriptionAr: descriptionAr,
        categoryId: categoryId,
        price: price,
        video: video,
        location: location,
        email: email,
        phone: phone,
        type: type,
        rentType: rentType,
        monthsCount: monthsCount,
        yearsCount: yearsCount,
        daysCount: daysCount,
        rentPrice: rentPrice,
        dayPrice: dayPrice,
        checkInTime: checkInTime,
        checkOutTime: checkOutTime,
        space: space,
        rooms: rooms,
        latitude: latitude,
        longitude: longitude,
        amenityIds: amenityIds,
        countryId: countryId,
        cityId: cityId,
        regionId: regionId,
      ),
      imagePath: imagePath,
      galleryImagePaths: galleryImagePaths,
    );
    await _postAssetFormData(ApiConstants.updateAsset, formData);
  }

  Map<String, dynamic> _assetFormFields({
    int? assetId,
    required String nameEn,
    required String nameAr,
    required String descriptionEn,
    required String descriptionAr,
    required int categoryId,
    required double price,
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
    int? space,
    int? rooms,
    required double latitude,
    required double longitude,
    required List<int> amenityIds,
    required int countryId,
    required int cityId,
    required int regionId,
  }) {
    return {
      if (assetId != null) 'asset_id': assetId,
      'name_en': nameEn,
      'name_ar': nameAr,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
      'category_id': categoryId,
      'price': price,
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
      if (space != null) 'space': space,
      if (rooms != null) 'rooms': rooms,
      'latitude': latitude,
      'longitude': longitude,
      'amenities_ids': jsonEncode(amenityIds),
      'country_id': countryId,
      'city_id': cityId,
      'region_id': regionId,
    };
  }

  Future<FormData> _buildAssetFormData({
    required Map<String, dynamic> fields,
    String? imagePath,
    List<String> galleryImagePaths = const [],
  }) async {
    final formData = FormData.fromMap(fields);

    if (imagePath != null) {
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
        ),
      );
    }

    for (final path in galleryImagePaths) {
      formData.files.add(
        MapEntry(
          'images[]',
          await MultipartFile.fromFile(
            path,
            filename: path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }

  Future<void> _postAssetFormData(String endpoint, FormData formData) async {
    final dio = DioFactory.getDio();
    try {
      await dio.post(
        '${ApiConstants.baseUrl}$endpoint',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {ApiHeaders.acceptHeader: 'application/vnd.api+json'},
        ),
      );
    } on DioException catch (e) {
      throw _mapAssetDioError(e);
    }
  }

  AssetApiException _mapAssetDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    String message = 'Something went wrong';

    if (data is Map) {
      final apiMessage = data['message'];
      if (apiMessage is String && apiMessage.isNotEmpty) {
        message = apiMessage;
      }
    }

    final isSubscriptionRequired = statusCode == 403 &&
        message.toLowerCase().contains('subscription');

    return AssetApiException(
      message,
      isSubscriptionRequired: isSubscriptionRequired,
    );
  }

  @override
  Future<void> deleteAsset({required int assetId}) async {
    final dio = DioFactory.getDio();
    final formData = FormData.fromMap({'asset_id': assetId});
    try {
      await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.deleteAsset}',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {ApiHeaders.acceptHeader: 'application/vnd.api+json'},
        ),
      );
    } on DioException catch (e) {
      throw _mapAssetDioError(e);
    }
  }
}
