import '../../../assets/data/models/asset_item.dart';
import '../../domain/repositories/search_repository.dart';
import '../data_sources/asset_search_service_client.dart';
import '../data_sources/popular_search_service_client.dart';

class SearchRepositoryImpl implements SearchRepository {
  final PopularSearchServiceClient _client;
  final AssetSearchServiceClient _searchClient;

  SearchRepositoryImpl(this._client, this._searchClient);

  @override
  Future<List<String>> getPopularSearches() async {
    final response = await _client.getPopularSearches();
    return response;
  }

  @override
  Future<List<AssetItem>> searchAssets(String query) async {
    final response = await _searchClient.searchAssets(query);
    return response.result;
  }
}
