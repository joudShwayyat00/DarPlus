import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../controller/local_provider.dart';
import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/assets_service_client.dart';
import '../../data/models/amenity_item.dart';
import '../../data/models/asset_item.dart';
import '../../data/repositories/assets_repository_impl.dart';
import '../../domain/repositories/assets_repository.dart';
import 'package:dar_plus_app/utils/widgets/filter_bottom_sheet.dart';

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
  int _currentPage = 1;
  bool _hasMore = false;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  FutureOr<List<AssetItem>> build() async {
    _currentPage = 1;
    final lang = ref.read(localeProvider).languageCode;
    final result = await ref
        .read(assetsRepositoryProvider)
        .getAssets(lang, categoryId: _currentCategoryId, page: 1);
    _hasMore = result.hasMore;
    return result.items;
  }

  Future<void> fetchByCategory(int? categoryId) async {
    _currentCategoryId = categoryId;
    _currentPage = 1;
    _hasMore = false;
    state = const AsyncLoading();
    final next = await AsyncValue.guard(() async {
      final lang = ref.read(localeProvider).languageCode;
      final result = await ref
          .read(assetsRepositoryProvider)
          .getAssets(lang, categoryId: categoryId, page: 1);
      _hasMore = result.hasMore;
      return result.items;
    });
    if (ref.mounted) state = next;
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = false;
    state = const AsyncLoading();
    final next = await AsyncValue.guard(() async {
      final lang = ref.read(localeProvider).languageCode;
      final result = await ref
          .read(assetsRepositoryProvider)
          .getAssets(lang, categoryId: _currentCategoryId, page: 1);
      _hasMore = result.hasMore;
      return result.items;
    });
    if (ref.mounted) state = next;
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    final current = state.when(
      data: (d) => d,
      loading: () => null,
      error: (_, __) => null,
    );
    if (current == null) return;
    _isLoadingMore = true;
    try {
      final lang = ref.read(localeProvider).languageCode;
      final result = await ref
          .read(assetsRepositoryProvider)
          .getAssets(
            lang,
            categoryId: _currentCategoryId,
            page: _currentPage + 1,
          );
      if (!ref.mounted) return;
      _currentPage += 1;
      _hasMore = result.hasMore;
      state = AsyncData([...current, ...result.items]);
    } finally {
      _isLoadingMore = false;
    }
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
    final next = await AsyncValue.guard(
      () => ref.read(assetsRepositoryProvider).getTopRatedAssets(),
    );
    if (ref.mounted) state = next;
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
    final next = await AsyncValue.guard(() async {
      final lang = ref.read(localeProvider).languageCode;
      final repository = ref.read(assetsRepositoryProvider);
      return await repository.getAssetDetail(id: assetId, lang: lang);
    });
    if (ref.mounted) state = next;
  }
}

@riverpod
Future<List<AmenityItem>> amenities(Ref ref) async {
  final lang = ref.read(localeProvider).languageCode;
  final client = ref.read(assetsServiceClientProvider);
  final response = await client.getAmenities(lang);
  return response.data;
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
    int? daysCount,
    double? rentPrice,
    double? dayPrice,
    required double latitude,
    required double longitude,
    required List<int> amenityIds,
    required int countryId,
    required int cityId,
    required int regionId,
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
        daysCount: daysCount,
        rentPrice: rentPrice,
        dayPrice: dayPrice,
        latitude: latitude,
        longitude: longitude,
        amenityIds: amenityIds,
        countryId: countryId,
        cityId: cityId,
        regionId: regionId,
      );
    });
    if (ref.mounted) state = result;
    return result is AsyncData;
  }
}

@riverpod
class MyAssetsController extends _$MyAssetsController {
  int? _currentCategoryId;
  int _currentPage = 1;
  bool _hasMore = false;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  FutureOr<List<AssetItem>> build() async {
    _currentPage = 1;
    final lang = ref.read(localeProvider).languageCode;
    final result = await ref
        .read(assetsRepositoryProvider)
        .getMyAssets(lang, categoryId: _currentCategoryId, page: 1);
    _hasMore = result.hasMore;
    return result.items;
  }

  Future<void> fetchByCategory(int? categoryId) async {
    _currentCategoryId = categoryId;
    _currentPage = 1;
    _hasMore = false;
    state = const AsyncLoading();
    final next = await AsyncValue.guard(() async {
      final lang = ref.read(localeProvider).languageCode;
      final result = await ref
          .read(assetsRepositoryProvider)
          .getMyAssets(lang, categoryId: categoryId, page: 1);
      _hasMore = result.hasMore;
      return result.items;
    });
    if (ref.mounted) state = next;
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = false;
    state = const AsyncLoading();
    final next = await AsyncValue.guard(() async {
      final lang = ref.read(localeProvider).languageCode;
      final result = await ref
          .read(assetsRepositoryProvider)
          .getMyAssets(lang, categoryId: _currentCategoryId, page: 1);
      _hasMore = result.hasMore;
      return result.items;
    });
    if (ref.mounted) state = next;
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    final current = state.when(
      data: (d) => d,
      loading: () => null,
      error: (_, __) => null,
    );
    if (current == null) return;
    _isLoadingMore = true;
    try {
      final lang = ref.read(localeProvider).languageCode;
      final result = await ref
          .read(assetsRepositoryProvider)
          .getMyAssets(
            lang,
            categoryId: _currentCategoryId,
            page: _currentPage + 1,
          );
      if (!ref.mounted) return;
      _currentPage += 1;
      _hasMore = result.hasMore;
      state = AsyncData([...current, ...result.items]);
    } finally {
      _isLoadingMore = false;
    }
  }
}

@riverpod
class FilteredAssetsController extends _$FilteredAssetsController {
  int _currentPage = 1;
  bool _hasMore = false;
  bool _isLoadingMore = false;
  late FilterData _filter;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  FutureOr<List<AssetItem>> build(FilterData filter) async {
    if (!filter.hasActiveFilters) return [];
    _filter = filter;
    _currentPage = 1;
    return _fetchPage(filter, 1);
  }

  Future<List<AssetItem>> _fetchPage(FilterData filter, int page) async {
    final lang = ref.read(localeProvider).languageCode;
    final result = await ref.read(assetsRepositoryProvider).filterAssets(
          lang,
          cityId: filter.cityId,
          regionId: filter.regionId,
          location: filter.apiLocation,
          type: filter.apiType,
          categoryId: filter.apiCategoryId,
          page: page,
        );
    _hasMore = result.hasMore;
    return result.items;
  }

  Future<void> refresh(FilterData filter) async {
    if (!filter.hasActiveFilters) {
      state = const AsyncData([]);
      return;
    }
    _filter = filter;
    _currentPage = 1;
    _hasMore = false;
    state = const AsyncLoading();
    final next = await AsyncValue.guard(() => _fetchPage(filter, 1));
    if (ref.mounted) state = next;
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    final current = state.when(
      data: (d) => d,
      loading: () => null,
      error: (_, __) => null,
    );
    if (current == null) return;
    _isLoadingMore = true;
    try {
      final nextPage = _currentPage + 1;
      final more = await _fetchPage(_filter, nextPage);
      if (!ref.mounted) return;
      _currentPage = nextPage;
      state = AsyncData([...current, ...more]);
    } finally {
      _isLoadingMore = false;
    }
  }
}
