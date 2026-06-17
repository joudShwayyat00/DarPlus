// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ratingServiceClient)
const ratingServiceClientProvider = RatingServiceClientProvider._();

final class RatingServiceClientProvider
    extends
        $FunctionalProvider<
          RatingServiceClient,
          RatingServiceClient,
          RatingServiceClient
        >
    with $Provider<RatingServiceClient> {
  const RatingServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ratingServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ratingServiceClientHash();

  @$internal
  @override
  $ProviderElement<RatingServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RatingServiceClient create(Ref ref) {
    return ratingServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RatingServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RatingServiceClient>(value),
    );
  }
}

String _$ratingServiceClientHash() =>
    r'8f53cf650fb76f0e751bbb849919ef3e5e63f3c3';

@ProviderFor(ratingRepository)
const ratingRepositoryProvider = RatingRepositoryProvider._();

final class RatingRepositoryProvider
    extends
        $FunctionalProvider<
          RatingRepository,
          RatingRepository,
          RatingRepository
        >
    with $Provider<RatingRepository> {
  const RatingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ratingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ratingRepositoryHash();

  @$internal
  @override
  $ProviderElement<RatingRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RatingRepository create(Ref ref) {
    return ratingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RatingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RatingRepository>(value),
    );
  }
}

String _$ratingRepositoryHash() => r'402886cd9441856a813448bff424b970c12449d4';

@ProviderFor(RatingController)
const ratingControllerProvider = RatingControllerProvider._();

final class RatingControllerProvider
    extends $NotifierProvider<RatingController, AsyncValue<void>> {
  const RatingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ratingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ratingControllerHash();

  @$internal
  @override
  RatingController create() => RatingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$ratingControllerHash() => r'7b2ea908862642e749b869610b21772b2fa65b70';

abstract class _$RatingController extends $Notifier<AsyncValue<void>> {
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
