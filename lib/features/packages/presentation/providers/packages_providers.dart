import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../controller/local_provider.dart';
import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/packages_service_client.dart';
import '../../data/models/package_item.dart';
import '../../data/repositories/packages_repository_impl.dart';
import '../../domain/repositories/packages_repository.dart';

part 'packages_providers.g.dart';

@riverpod
PackagesServiceClient packagesServiceClient(Ref ref) {
  return PackagesServiceClient(DioFactory.getDio());
}

@riverpod
PackagesRepository packagesRepository(Ref ref) {
  return PackagesRepositoryImpl(ref.watch(packagesServiceClientProvider));
}

@riverpod
class PackagesController extends _$PackagesController {
  @override
  FutureOr<List<PackageItem>> build() async {
    final lang = ref.watch(apiLanguageCodeProvider);
    return ref.read(packagesRepositoryProvider).getPackages(lang);
  }
}
