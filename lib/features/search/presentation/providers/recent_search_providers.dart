import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/recent_search_service_client.dart';
import '../../data/repositories/recent_search_repository_impl.dart';
import '../../domain/repositories/recent_search_repository.dart';

part 'recent_search_providers.g.dart';

@riverpod
RecentSearchServiceClient recentSearchServiceClient(Ref ref) {
  final dio = DioFactory.getDio();
  return RecentSearchServiceClient(dio);
}

@riverpod
RecentSearchRepository recentSearchRepository(Ref ref) {
  final client = ref.watch(recentSearchServiceClientProvider);
  return RecentSearchRepositoryImpl(client);
}

@riverpod
class RecentSearchController extends _$RecentSearchController {
  @override
  FutureOr<List<String>> build() async {
    final repository = ref.read(recentSearchRepositoryProvider);
    return await repository.getRecentSearches();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(recentSearchRepositoryProvider);
      return await repository.getRecentSearches();
    });
  }
}
