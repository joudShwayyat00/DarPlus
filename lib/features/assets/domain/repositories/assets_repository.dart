import '../../data/models/amenity_item.dart';
import '../../data/models/asset_item.dart';

abstract class AssetsRepository {
  Future<List<AssetItem>> getAssets(String lang, {int? categoryId});
  Future<List<AssetItem>> getTopRatedAssets();
  Future<AssetItem> getAssetDetail({required int id, required String lang});
  Future<List<AmenityItem>> getAmenities(String lang);
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
    double? rentPrice,
    required double latitude,
    required double longitude,
    required List<int> amenityIds,
  });
}
