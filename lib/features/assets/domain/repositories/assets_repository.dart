import '../../data/models/asset_item.dart';

abstract class AssetsRepository {
  Future<List<AssetItem>> getAssets(String lang);
  Future<List<AssetItem>> getTopRatedAssets();
  Future<AssetItem> getAssetDetail({required int id, required String lang});
}
