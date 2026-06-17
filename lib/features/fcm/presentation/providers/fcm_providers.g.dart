// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fcmServiceClient)
const fcmServiceClientProvider = FcmServiceClientProvider._();

final class FcmServiceClientProvider
    extends
        $FunctionalProvider<
          FcmServiceClient,
          FcmServiceClient,
          FcmServiceClient
        >
    with $Provider<FcmServiceClient> {
  const FcmServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fcmServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fcmServiceClientHash();

  @$internal
  @override
  $ProviderElement<FcmServiceClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FcmServiceClient create(Ref ref) {
    return fcmServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FcmServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FcmServiceClient>(value),
    );
  }
}

String _$fcmServiceClientHash() => r'bc153f3dbb55438fdae10b9b714322e91660837b';

@ProviderFor(fcmRepository)
const fcmRepositoryProvider = FcmRepositoryProvider._();

final class FcmRepositoryProvider
    extends $FunctionalProvider<FcmRepository, FcmRepository, FcmRepository>
    with $Provider<FcmRepository> {
  const FcmRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fcmRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fcmRepositoryHash();

  @$internal
  @override
  $ProviderElement<FcmRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FcmRepository create(Ref ref) {
    return fcmRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FcmRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FcmRepository>(value),
    );
  }
}

String _$fcmRepositoryHash() => r'23dc67c6fb6130ec8cc874031f18f477710fd256';
