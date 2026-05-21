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

String _$searchRepositoryHash() => r'c4e7b672f5bec963821fc643f614fbbc19c6ef92';

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
    r'e892149cde596c69fa89e9fc176920fe38c1f610';

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
