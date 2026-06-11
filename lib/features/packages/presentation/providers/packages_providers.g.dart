// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packages_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(packagesServiceClient)
const packagesServiceClientProvider = PackagesServiceClientProvider._();

final class PackagesServiceClientProvider
    extends
        $FunctionalProvider<
          PackagesServiceClient,
          PackagesServiceClient,
          PackagesServiceClient
        >
    with $Provider<PackagesServiceClient> {
  const PackagesServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packagesServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packagesServiceClientHash();

  @$internal
  @override
  $ProviderElement<PackagesServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PackagesServiceClient create(Ref ref) {
    return packagesServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PackagesServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PackagesServiceClient>(value),
    );
  }
}

String _$packagesServiceClientHash() =>
    r'a1b2c3d4e5f6789012345678abcdef9012345678';

@ProviderFor(packagesRepository)
const packagesRepositoryProvider = PackagesRepositoryProvider._();

final class PackagesRepositoryProvider
    extends
        $FunctionalProvider<
          PackagesRepository,
          PackagesRepository,
          PackagesRepository
        >
    with $Provider<PackagesRepository> {
  const PackagesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packagesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packagesRepositoryHash();

  @$internal
  @override
  $ProviderElement<PackagesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PackagesRepository create(Ref ref) {
    return packagesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PackagesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PackagesRepository>(value),
    );
  }
}

String _$packagesRepositoryHash() =>
    r'b2c3d4e5f6789012345678abcdef901234567890';

@ProviderFor(PackagesController)
const packagesControllerProvider = PackagesControllerProvider._();

final class PackagesControllerProvider
    extends $AsyncNotifierProvider<PackagesController, List<PackageItem>> {
  const PackagesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packagesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packagesControllerHash();

  @$internal
  @override
  PackagesController create() => PackagesController();
}

String _$packagesControllerHash() =>
    r'c3d4e5f6789012345678abcdef901234567890ab';

abstract class _$PackagesController extends $AsyncNotifier<List<PackageItem>> {
  FutureOr<List<PackageItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<PackageItem>>, List<PackageItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PackageItem>>, List<PackageItem>>,
              AsyncValue<List<PackageItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
