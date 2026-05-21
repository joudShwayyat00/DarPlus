import '../../domain/repositories/recent_search_repository.dart';
import '../data_sources/recent_search_service_client.dart';

class RecentSearchRepositoryImpl implements RecentSearchRepository {
  final RecentSearchServiceClient _client;

  RecentSearchRepositoryImpl(this._client);

  @override
  Future<List<String>> getRecentSearches() async {
    final response = await _client.getRecentSearches();
    return response;
  }
}
