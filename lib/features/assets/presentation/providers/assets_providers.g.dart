// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(assetsServiceClient)
const assetsServiceClientProvider = AssetsServiceClientProvider._();

final class AssetsServiceClientProvider
    extends
        $FunctionalProvider<
          AssetsServiceClient,
          AssetsServiceClient,
          AssetsServiceClient
        >
    with $Provider<AssetsServiceClient> {
  const AssetsServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetsServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetsServiceClientHash();

  @$internal
  @override
  $ProviderElement<AssetsServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AssetsServiceClient create(Ref ref) {
    return assetsServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetsServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetsServiceClient>(value),
    );
  }
}

String _$assetsServiceClientHash() =>
    r'09cbda5a6356df24c5865cff2ae1f6d842a32017';

@ProviderFor(assetsRepository)
const assetsRepositoryProvider = AssetsRepositoryProvider._();

final class AssetsRepositoryProvider
    extends
        $FunctionalProvider<
          AssetsRepository,
          AssetsRepository,
          AssetsRepository
        >
    with $Provider<AssetsRepository> {
  const AssetsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AssetsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AssetsRepository create(Ref ref) {
    return assetsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetsRepository>(value),
    );
  }
}

String _$assetsRepositoryHash() => r'9f61e27d7673ec2c8bf32d96fbf98c735e1e9e09';

@ProviderFor(AssetsController)
const assetsControllerProvider = AssetsControllerProvider._();

final class AssetsControllerProvider
    extends $AsyncNotifierProvider<AssetsController, List<AssetItem>> {
  const AssetsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetsControllerHash();

  @$internal
  @override
  AssetsController create() => AssetsController();
}

String _$assetsControllerHash() => r'dfbf887b4f7962f099e48ce51d36b690e77b40bc';

abstract class _$AssetsController extends $AsyncNotifier<List<AssetItem>> {
  FutureOr<List<AssetItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<AssetItem>>, List<AssetItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AssetItem>>, List<AssetItem>>,
              AsyncValue<List<AssetItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
