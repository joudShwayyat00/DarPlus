import '../../data/models/content_page_item.dart';

abstract class ContentRepository {
  Future<List<ContentPageItem>> getTerms(String lang);
  Future<List<ContentPageItem>> getPrivacyPolicy(String lang);
}
