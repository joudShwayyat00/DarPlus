import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../controller/local_provider.dart';
import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/content_service_client.dart';
import '../../data/models/about_us_item.dart';
import '../../data/models/contact_data_item.dart';
import '../../data/models/contact_us_submit_response.dart';
import '../../data/models/content_page_item.dart';
import '../../data/repositories/content_repository_impl.dart';
import '../../domain/repositories/content_repository.dart';

part 'content_providers.g.dart';

@riverpod
ContentServiceClient contentServiceClient(Ref ref) {
  return ContentServiceClient(DioFactory.getDio());
}

@riverpod
ContentRepository contentRepository(Ref ref) {
  return ContentRepositoryImpl(ref.watch(contentServiceClientProvider));
}

@riverpod
class TermsController extends _$TermsController {
  @override
  FutureOr<List<ContentPageItem>> build() async {
    final lang = ref.read(localeProvider).languageCode;
    return await ref.read(contentRepositoryProvider).getTerms(lang);
  }
}

@riverpod
class PrivacyPolicyController extends _$PrivacyPolicyController {
  @override
  FutureOr<List<ContentPageItem>> build() async {
    final lang = ref.read(localeProvider).languageCode;
    return await ref.read(contentRepositoryProvider).getPrivacyPolicy(lang);
  }
}

@riverpod
class AboutUsController extends _$AboutUsController {
  @override
  FutureOr<AboutUsItem> build() async {
    final lang = ref.read(localeProvider).languageCode;
    return await ref.read(contentRepositoryProvider).getAboutUs(lang);
  }
}

@riverpod
class ContactDataController extends _$ContactDataController {
  @override
  FutureOr<ContactDataItem> build() async {
    return await ref.read(contentRepositoryProvider).getContactData();
  }
}

@riverpod
class ContactUsSubmitController extends _$ContactUsSubmitController {
  @override
  FutureOr<ContactUsSubmitResponse?> build() => null;

  Future<void> submit({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(contentRepositoryProvider).submitContactUs(
            name: name,
            email: email,
            phone: phone,
            message: message,
          );
    });
  }
}
