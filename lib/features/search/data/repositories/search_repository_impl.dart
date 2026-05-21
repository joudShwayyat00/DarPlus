import '../../domain/repositories/search_repository.dart';
import '../data_sources/popular_search_service_client.dart';

class SearchRepositoryImpl implements SearchRepository {
  final PopularSearchServiceClient _client;

  SearchRepositoryImpl(this._client);

  @override
  Future<List<String>> getPopularSearches() async {
    final response = await _client.getPopularSearches();
    return response;
  }
}
