import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/popular_search_service_client.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/repositories/search_repository.dart';

part 'search_providers.g.dart';

@riverpod
PopularSearchServiceClient popularSearchServiceClient(Ref ref) {
  final dio = DioFactory.getDio();
  return PopularSearchServiceClient(dio);
}

@riverpod
SearchRepository searchRepository(Ref ref) {
  final client = ref.watch(popularSearchServiceClientProvider);
  return SearchRepositoryImpl(client);
}

@riverpod
class PopularSearchController extends _$PopularSearchController {
  @override
  FutureOr<List<String>> build() async {
    final repository = ref.read(searchRepositoryProvider);
    return await repository.getPopularSearches();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(searchRepositoryProvider);
      return await repository.getPopularSearches();
    });
  }
}
