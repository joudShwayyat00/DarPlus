// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recentSearchServiceClient)
const recentSearchServiceClientProvider = RecentSearchServiceClientProvider._();

final class RecentSearchServiceClientProvider
    extends
        $FunctionalProvider<
          RecentSearchServiceClient,
          RecentSearchServiceClient,
          RecentSearchServiceClient
        >
    with $Provider<RecentSearchServiceClient> {
  const RecentSearchServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSearchServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSearchServiceClientHash();

  @$internal
  @override
  $ProviderElement<RecentSearchServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecentSearchServiceClient create(Ref ref) {
    return recentSearchServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecentSearchServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecentSearchServiceClient>(value),
    );
  }
}

String _$recentSearchServiceClientHash() =>
    r'4c8cd1bf0a4bf043ce5f4d2bc2226967d3bcf93a';

@ProviderFor(recentSearchRepository)
const recentSearchRepositoryProvider = RecentSearchRepositoryProvider._();

final class RecentSearchRepositoryProvider
    extends
        $FunctionalProvider<
          RecentSearchRepository,
          RecentSearchRepository,
          RecentSearchRepository
        >
    with $Provider<RecentSearchRepository> {
  const RecentSearchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSearchRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSearchRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecentSearchRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecentSearchRepository create(Ref ref) {
    return recentSearchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecentSearchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecentSearchRepository>(value),
    );
  }
}

String _$recentSearchRepositoryHash() =>
    r'ffec456deb421acb88a0a9b66950b3d71ec37f28';

@ProviderFor(RecentSearchController)
const recentSearchControllerProvider = RecentSearchControllerProvider._();

final class RecentSearchControllerProvider
    extends $AsyncNotifierProvider<RecentSearchController, List<String>> {
  const RecentSearchControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSearchControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSearchControllerHash();

  @$internal
  @override
  RecentSearchController create() => RecentSearchController();
}

String _$recentSearchControllerHash() =>
    r'bbde99c95b2731def275548cee20675b9247fcc8';

abstract class _$RecentSearchController extends $AsyncNotifier<List<String>> {
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
