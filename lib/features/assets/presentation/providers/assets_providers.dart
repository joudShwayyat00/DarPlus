import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../controller/local_provider.dart';
import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/assets_service_client.dart';
import '../../data/models/amenity_item.dart';
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
  int? _currentCategoryId;

  @override
  FutureOr<List<AssetItem>> build() async {
    final lang = ref.read(localeProvider).languageCode;
    final repository = ref.read(assetsRepositoryProvider);
    return await repository.getAssets(lang, categoryId: _currentCategoryId);
  }

  Future<void> fetchByCategory(int? categoryId) async {
    _currentCategoryId = categoryId;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final lang = ref.read(localeProvider).languageCode;
      final repository = ref.read(assetsRepositoryProvider);
      return await repository.getAssets(lang, categoryId: categoryId);
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final lang = ref.read(localeProvider).languageCode;
      final repository = ref.read(assetsRepositoryProvider);
      return await repository.getAssets(lang, categoryId: _currentCategoryId);
    });
  }
}

@riverpod
class TopRatedAssetsController extends _$TopRatedAssetsController {
  @override
  FutureOr<List<AssetItem>> build() async {
    final repository = ref.read(assetsRepositoryProvider);
    return await repository.getTopRatedAssets();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(assetsRepositoryProvider).getTopRatedAssets(),
    );
  }
}

/// Family provider — one instance per [assetId].
/// Usage: ref.watch(assetDetailControllerProvider(assetId))
@riverpod
class AssetDetailController extends _$AssetDetailController {
  @override
  FutureOr<AssetItem> build(int assetId) async {
    final lang = ref.read(localeProvider).languageCode;
    final repository = ref.read(assetsRepositoryProvider);
    return await repository.getAssetDetail(id: assetId, lang: lang);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final lang = ref.read(localeProvider).languageCode;
      final repository = ref.read(assetsRepositoryProvider);
      return await repository.getAssetDetail(id: assetId, lang: lang);
    });
  }
}

@riverpod
Future<List<AmenityItem>> amenities(Ref ref) async {
  final lang = ref.read(localeProvider).languageCode;
  final client = ref.read(assetsServiceClientProvider);
  final response = await client.getAmenities(lang);
  return response.result;
}

@riverpod
class AddAssetController extends _$AddAssetController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> submit({
    required String nameEn,
    required String nameAr,
    required String descriptionEn,
    required String descriptionAr,
    required int categoryId,
    required double price,
    required String imagePath,
    String? video,
    required String location,
    required String email,
    required String phone,
    required String type,
    String? rentType,
    int? monthsCount,
    int? yearsCount,
    double? rentPrice,
    required double latitude,
    required double longitude,
    required List<int> amenityIds,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final repository = ref.read(assetsRepositoryProvider);
      await repository.addAsset(
        nameEn: nameEn,
        nameAr: nameAr,
        descriptionEn: descriptionEn,
        descriptionAr: descriptionAr,
        categoryId: categoryId,
        price: price,
        imagePath: imagePath,
        video: video,
        location: location,
        email: email,
        phone: phone,
        type: type,
        rentType: rentType,
        monthsCount: monthsCount,
        yearsCount: yearsCount,
        rentPrice: rentPrice,
        latitude: latitude,
        longitude: longitude,
        amenityIds: amenityIds,
      );
    });
    state = result;
    return result is AsyncData;
  }
}
