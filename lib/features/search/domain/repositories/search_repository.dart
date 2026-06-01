import '../../../assets/data/models/asset_item.dart';

abstract class SearchRepository {
  Future<List<String>> getPopularSearches();
  Future<List<AssetItem>> searchAssets(String query);
}
