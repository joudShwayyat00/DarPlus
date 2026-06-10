import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../controller/local_provider.dart';
import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/content_service_client.dart';
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
