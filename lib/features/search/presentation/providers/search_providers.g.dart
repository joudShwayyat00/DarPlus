// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(popularSearchServiceClient)
const popularSearchServiceClientProvider =
    PopularSearchServiceClientProvider._();

final class PopularSearchServiceClientProvider
    extends
        $FunctionalProvider<
          PopularSearchServiceClient,
          PopularSearchServiceClient,
          PopularSearchServiceClient
        >
    with $Provider<PopularSearchServiceClient> {
  const PopularSearchServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularSearchServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularSearchServiceClientHash();

  @$internal
  @override
  $ProviderElement<PopularSearchServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PopularSearchServiceClient create(Ref ref) {
    return popularSearchServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PopularSearchServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PopularSearchServiceClient>(value),
    );
  }
}

String _$popularSearchServiceClientHash() =>
    r'5392833a3970ac4d851c71e265ecb87625273826';

@ProviderFor(assetSearchServiceClient)
const assetSearchServiceClientProvider = AssetSearchServiceClientProvider._();

final class AssetSearchServiceClientProvider
    extends
        $FunctionalProvider<
          AssetSearchServiceClient,
          AssetSearchServiceClient,
          AssetSearchServiceClient
        >
    with $Provider<AssetSearchServiceClient> {
  const AssetSearchServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetSearchServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetSearchServiceClientHash();

  @$internal
  @override
  $ProviderElement<AssetSearchServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AssetSearchServiceClient create(Ref ref) {
    return assetSearchServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetSearchServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetSearchServiceClient>(value),
    );
  }
}

String _$assetSearchServiceClientHash() =>
    r'0f3801e38840a62263209c7422f35bfc97999311';

@ProviderFor(searchRepository)
const searchRepositoryProvider = SearchRepositoryProvider._();

final class SearchRepositoryProvider
    extends
        $FunctionalProvider<
          SearchRepository,
          SearchRepository,
          SearchRepository
        >
    with $Provider<SearchRepository> {
  const SearchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchRepositoryHash();

  @$internal
  @override
  $ProviderElement<SearchRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SearchRepository create(Ref ref) {
    return searchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchRepository>(value),
    );
  }
}

String _$searchRepositoryHash() => r'951b3e8c1eedfaee984459b44f80f7d3e7f12f76';

@ProviderFor(PopularSearchController)
const popularSearchControllerProvider = PopularSearchControllerProvider._();

final class PopularSearchControllerProvider
    extends $AsyncNotifierProvider<PopularSearchController, List<String>> {
  const PopularSearchControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularSearchControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularSearchControllerHash();

  @$internal
  @override
  PopularSearchController create() => PopularSearchController();
}

String _$popularSearchControllerHash() =>
    r'b6f8dbb8ff298fe984e5bb3fe31685468d3d11d6';

abstract class _$PopularSearchController extends $AsyncNotifier<List<String>> {
  FutureOr<List<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>, List<String>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Family provider — one instance per query string.
/// Returns empty list immediately for empty queries.

@ProviderFor(AssetSearchController)
const assetSearchControllerProvider = AssetSearchControllerFamily._();

/// Family provider — one instance per query string.
/// Returns empty list immediately for empty queries.
final class AssetSearchControllerProvider
    extends $AsyncNotifierProvider<AssetSearchController, List<AssetItem>> {
  /// Family provider — one instance per query string.
  /// Returns empty list immediately for empty queries.
  const AssetSearchControllerProvider._({
    required AssetSearchControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'assetSearchControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetSearchControllerHash();

  @override
  String toString() {
    return r'assetSearchControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AssetSearchController create() => AssetSearchController();

  @override
  bool operator ==(Object other) {
    return other is AssetSearchControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetSearchControllerHash() =>
    r'dfbef290d84bfd374f5eebb4cde8ea9e1f0726f4';

/// Family provider — one instance per query string.
/// Returns empty list immediately for empty queries.

final class AssetSearchControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AssetSearchController,
          AsyncValue<List<AssetItem>>,
          List<AssetItem>,
          FutureOr<List<AssetItem>>,
          String
        > {
  const AssetSearchControllerFamily._()
    : super(
        retry: null,
        name: r'assetSearchControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Family provider — one instance per query string.
  /// Returns empty list immediately for empty queries.

  AssetSearchControllerProvider call(String query) =>
      AssetSearchControllerProvider._(argument: query, from: this);

  @override
  String toString() => r'assetSearchControllerProvider';
}

/// Family provider — one instance per query string.
/// Returns empty list immediately for empty queries.

abstract class _$AssetSearchController extends $AsyncNotifier<List<AssetItem>> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<List<AssetItem>> build(String query);
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
