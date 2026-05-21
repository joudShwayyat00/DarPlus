import '../../data/models/asset_item.dart';

abstract class AssetsRepository {
  Future<List<AssetItem>> getAssets(String lang);
}
