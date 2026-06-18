import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:dar_plus_app/features/owners/data/models/owner_detail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/owners_service_client.dart';
import '../../data/repositories/owners_repository_impl.dart';
import '../../domain/repositories/owners_repository.dart';

part 'owners_providers.g.dart';

@riverpod
OwnersServiceClient ownersServiceClient(Ref ref) {
  return OwnersServiceClient(DioFactory.getDio());
}

@riverpod
OwnersRepository ownersRepository(Ref ref) {
  return OwnersRepositoryImpl(ref.watch(ownersServiceClientProvider));
}

@riverpod
class OwnersController extends _$OwnersController {
  @override
  FutureOr<List<AssetOwner>> build() async {
    return ref.read(ownersRepositoryProvider).getOwners();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final next = await AsyncValue.guard(
      () => ref.read(ownersRepositoryProvider).getOwners(),
    );
    if (ref.mounted) state = next;
  }
}

@riverpod
class OwnerDetailController extends _$OwnerDetailController {
  @override
  FutureOr<OwnerDetail> build(int ownerId) async {
    return ref.read(ownersRepositoryProvider).getOwnerDetail(ownerId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final next = await AsyncValue.guard(
      () => ref.read(ownersRepositoryProvider).getOwnerDetail(ownerId),
    );
    if (ref.mounted) state = next;
  }
}
