import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../controller/local_provider.dart';
import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/assets_service_client.dart';
import '../../data/models/asset_item.dart';
import '../../data/repositories/assets_repository_impl.dart';
import '../../domain/repositories/assets_repository.dart';

part 'assets_providers.g.dart';

@riverpod
AssetsServiceClient assetsServiceClient(Ref ref) {
  final dio = DioFactory.getDio();
  return AssetsServiceClient(dio);
}

@riverpod
AssetsRepository assetsRepository(Ref ref) {
  final client = ref.watch(assetsServiceClientProvider);
  return AssetsRepositoryImpl(client);
}

@riverpod
class AssetsController extends _$AssetsController {
  @override
  FutureOr<List<AssetItem>> build() async {
    final lang = ref.read(localeProvider).languageCode;
    final repository = ref.read(assetsRepositoryProvider);
    return await repository.getAssets(lang);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final lang = ref.read(localeProvider).languageCode;
      final repository = ref.read(assetsRepositoryProvider);
      return await repository.getAssets(lang);
    });
  }
}
