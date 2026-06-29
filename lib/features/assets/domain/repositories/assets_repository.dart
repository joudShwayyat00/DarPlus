import '../../data/models/amenity_item.dart';
import '../../data/models/asset_item.dart';

class AssetsPage {
  final List<AssetItem> items;
  final bool hasMore;
  AssetsPage({required this.items, required this.hasMore});
}

abstract class AssetsRepository {
  Future<AssetsPage> getAssets(String lang, {int? categoryId, int page = 1});
  Future<AssetsPage> getMyAssets(String lang, {int? categoryId, int page = 1});
  Future<List<AssetItem>> getTopRatedAssets();
  Future<AssetItem> getAssetDetail({required int id, required String lang});
  Future<List<AmenityItem>> getAmenities(String lang);
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
  });
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
  });
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
  });
  Future<void> deleteAsset({required int assetId});
}
