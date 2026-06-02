import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../controller/shared_prefs.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../assets/data/models/asset_item.dart';
import '../../data/data_sources/asset_search_service_client.dart';
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
AssetSearchServiceClient assetSearchServiceClient(Ref ref) {
  final dio = DioFactory.getDio();
  return AssetSearchServiceClient(dio);
}

@riverpod
SearchRepository searchRepository(Ref ref) {
  final client = ref.watch(popularSearchServiceClientProvider);
  final searchClient = ref.watch(assetSearchServiceClientProvider);
  return SearchRepositoryImpl(client, searchClient);
}

@riverpod
class PopularSearchController extends _$PopularSearchController {
  @override
  FutureOr<List<String>> build() async {
    if (!SharedPerfManager().isLoggedIn) return [];
    final repository = ref.read(searchRepositoryProvider);
    return await repository.getPopularSearches();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (!SharedPerfManager().isLoggedIn) return <String>[];
      final repository = ref.read(searchRepositoryProvider);
      return await repository.getPopularSearches();
    });
  }
}

/// Family provider — one instance per query string.
/// Returns empty list immediately for empty queries.
@riverpod
class AssetSearchController extends _$AssetSearchController {
  @override
  FutureOr<List<AssetItem>> build(String query) async {
    if (query.trim().isEmpty) return [];
    final repository = ref.read(searchRepositoryProvider);
    return await repository.searchAssets(query.trim());
  }
}
