import '../../domain/repositories/content_repository.dart';
import '../data_sources/content_service_client.dart';
import '../models/about_us_item.dart';
import '../models/content_page_item.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentServiceClient _client;

  ContentRepositoryImpl(this._client);

  @override
  Future<List<ContentPageItem>> getTerms(String lang) async {
    final response = await _client.getTerms(lang);
    return response.result;
  }

  @override
  Future<List<ContentPageItem>> getPrivacyPolicy(String lang) async {
    final response = await _client.getPrivacyPolicy(lang);
    return response.result;
  }

  @override
  Future<AboutUsItem> getAboutUs(String lang) async {
    final response = await _client.getAboutUs(lang);
    return response.data;
  }
}
