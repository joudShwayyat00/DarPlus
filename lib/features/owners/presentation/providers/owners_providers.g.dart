// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owners_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ownersServiceClient)
const ownersServiceClientProvider = OwnersServiceClientProvider._();

final class OwnersServiceClientProvider
    extends
        $FunctionalProvider<
          OwnersServiceClient,
          OwnersServiceClient,
          OwnersServiceClient
        >
    with $Provider<OwnersServiceClient> {
  const OwnersServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownersServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownersServiceClientHash();

  @$internal
  @override
  $ProviderElement<OwnersServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OwnersServiceClient create(Ref ref) {
    return ownersServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OwnersServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OwnersServiceClient>(value),
    );
  }
}

String _$ownersServiceClientHash() =>
    r'87548a3fb75f2e0aff5fb79306a8500c8fd0488b';

@ProviderFor(ownersRepository)
const ownersRepositoryProvider = OwnersRepositoryProvider._();

final class OwnersRepositoryProvider
    extends
        $FunctionalProvider<
          OwnersRepository,
          OwnersRepository,
          OwnersRepository
        >
    with $Provider<OwnersRepository> {
  const OwnersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownersRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownersRepositoryHash();

  @$internal
  @override
  $ProviderElement<OwnersRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OwnersRepository create(Ref ref) {
    return ownersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OwnersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OwnersRepository>(value),
    );
  }
}

String _$ownersRepositoryHash() => r'a7b2b2b347cb72c68128a3e1a0defd96c5c60e8a';

@ProviderFor(OwnersController)
const ownersControllerProvider = OwnersControllerProvider._();

final class OwnersControllerProvider
    extends $AsyncNotifierProvider<OwnersController, List<AssetOwner>> {
  const OwnersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownersControllerHash();

  @$internal
  @override
  OwnersController create() => OwnersController();
}

String _$ownersControllerHash() => r'84d165b927473df5a67c9feb5150a4c3ae8597e6';

abstract class _$OwnersController extends $AsyncNotifier<List<AssetOwner>> {
  FutureOr<List<AssetOwner>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<AssetOwner>>, List<AssetOwner>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AssetOwner>>, List<AssetOwner>>,
              AsyncValue<List<AssetOwner>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OwnerDetailController)
const ownerDetailControllerProvider = OwnerDetailControllerFamily._();

final class OwnerDetailControllerProvider
    extends $AsyncNotifierProvider<OwnerDetailController, OwnerDetail> {
  const OwnerDetailControllerProvider._({
    required OwnerDetailControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'ownerDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ownerDetailControllerHash();

  @override
  String toString() {
    return r'ownerDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OwnerDetailController create() => OwnerDetailController();

  @override
  bool operator ==(Object other) {
    return other is OwnerDetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ownerDetailControllerHash() =>
    r'ad2a684c41372c25570d3d343c52db2373796ca4';

final class OwnerDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          OwnerDetailController,
          AsyncValue<OwnerDetail>,
          OwnerDetail,
          FutureOr<OwnerDetail>,
          int
        > {
  const OwnerDetailControllerFamily._()
    : super(
        retry: null,
        name: r'ownerDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OwnerDetailControllerProvider call(int ownerId) =>
      OwnerDetailControllerProvider._(argument: ownerId, from: this);

  @override
  String toString() => r'ownerDetailControllerProvider';
}

abstract class _$OwnerDetailController extends $AsyncNotifier<OwnerDetail> {
  late final _$args = ref.$arg as int;
  int get ownerId => _$args;

  FutureOr<OwnerDetail> build(int ownerId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<OwnerDetail>, OwnerDetail>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<OwnerDetail>, OwnerDetail>,
              AsyncValue<OwnerDetail>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
