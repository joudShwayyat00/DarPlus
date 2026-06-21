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

String _$assetsControllerHash() => r'552b27d95c99cfd826501b53e2dc9e0680d237a4';

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

@ProviderFor(TopRatedAssetsController)
const topRatedAssetsControllerProvider = TopRatedAssetsControllerProvider._();

final class TopRatedAssetsControllerProvider
    extends $AsyncNotifierProvider<TopRatedAssetsController, List<AssetItem>> {
  const TopRatedAssetsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topRatedAssetsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topRatedAssetsControllerHash();

  @$internal
  @override
  TopRatedAssetsController create() => TopRatedAssetsController();
}

String _$topRatedAssetsControllerHash() =>
    r'0f2b878641ad72fab4f1f46022bd2609d2f677d6';

abstract class _$TopRatedAssetsController
    extends $AsyncNotifier<List<AssetItem>> {
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

/// Family provider — one instance per [assetId].
/// Usage: ref.watch(assetDetailControllerProvider(assetId))

@ProviderFor(AssetDetailController)
const assetDetailControllerProvider = AssetDetailControllerFamily._();

/// Family provider — one instance per [assetId].
/// Usage: ref.watch(assetDetailControllerProvider(assetId))
final class AssetDetailControllerProvider
    extends $AsyncNotifierProvider<AssetDetailController, AssetItem> {
  /// Family provider — one instance per [assetId].
  /// Usage: ref.watch(assetDetailControllerProvider(assetId))
  const AssetDetailControllerProvider._({
    required AssetDetailControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'assetDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetDetailControllerHash();

  @override
  String toString() {
    return r'assetDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AssetDetailController create() => AssetDetailController();

  @override
  bool operator ==(Object other) {
    return other is AssetDetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetDetailControllerHash() =>
    r'd31d58d8a31591f92be3d2904a4eb4dc66701e35';

/// Family provider — one instance per [assetId].
/// Usage: ref.watch(assetDetailControllerProvider(assetId))

final class AssetDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AssetDetailController,
          AsyncValue<AssetItem>,
          AssetItem,
          FutureOr<AssetItem>,
          int
        > {
  const AssetDetailControllerFamily._()
    : super(
        retry: null,
        name: r'assetDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Family provider — one instance per [assetId].
  /// Usage: ref.watch(assetDetailControllerProvider(assetId))

  AssetDetailControllerProvider call(int assetId) =>
      AssetDetailControllerProvider._(argument: assetId, from: this);

  @override
  String toString() => r'assetDetailControllerProvider';
}

/// Family provider — one instance per [assetId].
/// Usage: ref.watch(assetDetailControllerProvider(assetId))

abstract class _$AssetDetailController extends $AsyncNotifier<AssetItem> {
  late final _$args = ref.$arg as int;
  int get assetId => _$args;

  FutureOr<AssetItem> build(int assetId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<AssetItem>, AssetItem>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AssetItem>, AssetItem>,
              AsyncValue<AssetItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(amenities)
const amenitiesProvider = AmenitiesProvider._();

final class AmenitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AmenityItem>>,
          List<AmenityItem>,
          FutureOr<List<AmenityItem>>
        >
    with
        $FutureModifier<List<AmenityItem>>,
        $FutureProvider<List<AmenityItem>> {
  const AmenitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'amenitiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$amenitiesHash();

  @$internal
  @override
  $FutureProviderElement<List<AmenityItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AmenityItem>> create(Ref ref) {
    return amenities(ref);
  }
}

String _$amenitiesHash() => r'378cae8d0fd4d6a35cc412ed163ffc28d5262e21';

@ProviderFor(AddAssetController)
const addAssetControllerProvider = AddAssetControllerProvider._();

final class AddAssetControllerProvider
    extends $NotifierProvider<AddAssetController, AsyncValue<void>> {
  const AddAssetControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addAssetControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addAssetControllerHash();

  @$internal
  @override
  AddAssetController create() => AddAssetController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$addAssetControllerHash() =>
    r'0e107ddf65d5d314ff9f0add01960decd3306cfa';

abstract class _$AddAssetController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(UpdateAssetController)
const updateAssetControllerProvider = UpdateAssetControllerProvider._();

final class UpdateAssetControllerProvider
    extends $NotifierProvider<UpdateAssetController, AsyncValue<void>> {
  const UpdateAssetControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateAssetControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateAssetControllerHash();

  @$internal
  @override
  UpdateAssetController create() => UpdateAssetController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$updateAssetControllerHash() =>
    r'33d869dddcedf2ed738a860b2beee15eb7aced2d';

abstract class _$UpdateAssetController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DeleteAssetController)
const deleteAssetControllerProvider = DeleteAssetControllerProvider._();

final class DeleteAssetControllerProvider
    extends $NotifierProvider<DeleteAssetController, AsyncValue<void>> {
  const DeleteAssetControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteAssetControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteAssetControllerHash();

  @$internal
  @override
  DeleteAssetController create() => DeleteAssetController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$deleteAssetControllerHash() =>
    r'8f41d6e0f575498ec82ca793ab3eeb9f066f2160';

abstract class _$DeleteAssetController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MyAssetsController)
const myAssetsControllerProvider = MyAssetsControllerProvider._();

final class MyAssetsControllerProvider
    extends $AsyncNotifierProvider<MyAssetsController, List<AssetItem>> {
  const MyAssetsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myAssetsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myAssetsControllerHash();

  @$internal
  @override
  MyAssetsController create() => MyAssetsController();
}

String _$myAssetsControllerHash() =>
    r'452e06210556a80fb4b03fa084bc3d4e95294861';

abstract class _$MyAssetsController extends $AsyncNotifier<List<AssetItem>> {
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

@ProviderFor(FilteredAssetsController)
const filteredAssetsControllerProvider = FilteredAssetsControllerFamily._();

final class FilteredAssetsControllerProvider
    extends $AsyncNotifierProvider<FilteredAssetsController, List<AssetItem>> {
  const FilteredAssetsControllerProvider._({
    required FilteredAssetsControllerFamily super.from,
    required FilterData super.argument,
  }) : super(
         retry: null,
         name: r'filteredAssetsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredAssetsControllerHash();

  @override
  String toString() {
    return r'filteredAssetsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FilteredAssetsController create() => FilteredAssetsController();

  @override
  bool operator ==(Object other) {
    return other is FilteredAssetsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredAssetsControllerHash() =>
    r'2e9768d0b801b06ae2c1f744126420beb3b36706';

final class FilteredAssetsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          FilteredAssetsController,
          AsyncValue<List<AssetItem>>,
          List<AssetItem>,
          FutureOr<List<AssetItem>>,
          FilterData
        > {
  const FilteredAssetsControllerFamily._()
    : super(
        retry: null,
        name: r'filteredAssetsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilteredAssetsControllerProvider call(FilterData filter) =>
      FilteredAssetsControllerProvider._(argument: filter, from: this);

  @override
  String toString() => r'filteredAssetsControllerProvider';
}

abstract class _$FilteredAssetsController
    extends $AsyncNotifier<List<AssetItem>> {
  late final _$args = ref.$arg as FilterData;
  FilterData get filter => _$args;

  FutureOr<List<AssetItem>> build(FilterData filter);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
