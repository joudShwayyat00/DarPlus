import '../../data/models/about_us_item.dart';
import '../../data/models/contact_data_item.dart';
import '../../data/models/contact_us_submit_response.dart';
import '../../data/models/content_page_item.dart';

abstract class ContentRepository {
  Future<List<ContentPageItem>> getTerms(String lang);
  Future<List<ContentPageItem>> getPrivacyPolicy(String lang);
  Future<AboutUsItem> getAboutUs(String lang);
  Future<ContactDataItem> getContactData();
  Future<ContactUsSubmitResponse> submitContactUs({
    required String name,
    required String email,
    required String phone,
    required String message,
  });
}
