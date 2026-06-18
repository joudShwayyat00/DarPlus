import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/rating_service_client.dart';
import '../../data/models/rate_asset_response.dart';
import '../../data/models/rate_owner_response.dart';
import '../../data/repositories/rating_repository_impl.dart';
import '../../domain/repositories/rating_repository.dart';

part 'rating_providers.g.dart';

@riverpod
RatingServiceClient ratingServiceClient(Ref ref) {
  return RatingServiceClient(DioFactory.getDio());
}

@riverpod
RatingRepository ratingRepository(Ref ref) {
  return RatingRepositoryImpl(ref.watch(ratingServiceClientProvider));
}

@riverpod
class RatingController extends _$RatingController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<RateAssetResponse> submit({
    required int assetId,
    required int rating,
    String? comment,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      return ref.read(ratingRepositoryProvider).rateAsset(
            assetId: assetId,
            rating: rating,
            comment: comment,
          );
    });
    if (ref.mounted) {
      state = result.when(
        data: (_) => const AsyncData(null),
        error: (error, stackTrace) => AsyncError(error, stackTrace),
        loading: () => const AsyncLoading(),
      );
    }
    return result.requireValue;
  }

  Future<RateOwnerResponse> submitOwner({
    required int ownerId,
    required int rating,
    String? comment,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      return ref.read(ratingRepositoryProvider).rateOwner(
            ownerId: ownerId,
            rating: rating,
            comment: comment,
          );
    });
    if (ref.mounted) {
      state = result.when(
        data: (_) => const AsyncData(null),
        error: (error, stackTrace) => AsyncError(error, stackTrace),
        loading: () => const AsyncLoading(),
      );
    }
    return result.requireValue;
  }
}
