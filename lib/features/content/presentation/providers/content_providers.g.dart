// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contentServiceClient)
const contentServiceClientProvider = ContentServiceClientProvider._();

final class ContentServiceClientProvider
    extends
        $FunctionalProvider<
          ContentServiceClient,
          ContentServiceClient,
          ContentServiceClient
        >
    with $Provider<ContentServiceClient> {
  const ContentServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentServiceClientHash();

  @$internal
  @override
  $ProviderElement<ContentServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContentServiceClient create(Ref ref) {
    return contentServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContentServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContentServiceClient>(value),
    );
  }
}

String _$contentServiceClientHash() =>
    r'8cab5119ceec5de0aa3137949cf03d845c440031';

@ProviderFor(contentRepository)
const contentRepositoryProvider = ContentRepositoryProvider._();

final class ContentRepositoryProvider
    extends
        $FunctionalProvider<
          ContentRepository,
          ContentRepository,
          ContentRepository
        >
    with $Provider<ContentRepository> {
  const ContentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentRepositoryHash();

  @$internal
  @override
  $ProviderElement<ContentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContentRepository create(Ref ref) {
    return contentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContentRepository>(value),
    );
  }
}

String _$contentRepositoryHash() => r'906fb5298d3e8e79505bf129767f18bde5b21d35';

@ProviderFor(TermsController)
const termsControllerProvider = TermsControllerProvider._();

final class TermsControllerProvider
    extends $AsyncNotifierProvider<TermsController, List<ContentPageItem>> {
  const TermsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'termsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$termsControllerHash();

  @$internal
  @override
  TermsController create() => TermsController();
}

String _$termsControllerHash() => r'760193b5e6de4453864464970c8c80adab4f3bfa';

abstract class _$TermsController extends $AsyncNotifier<List<ContentPageItem>> {
  FutureOr<List<ContentPageItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ContentPageItem>>, List<ContentPageItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ContentPageItem>>,
                List<ContentPageItem>
              >,
              AsyncValue<List<ContentPageItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PrivacyPolicyController)
const privacyPolicyControllerProvider = PrivacyPolicyControllerProvider._();

final class PrivacyPolicyControllerProvider
    extends
        $AsyncNotifierProvider<PrivacyPolicyController, List<ContentPageItem>> {
  const PrivacyPolicyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'privacyPolicyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privacyPolicyControllerHash();

  @$internal
  @override
  PrivacyPolicyController create() => PrivacyPolicyController();
}

String _$privacyPolicyControllerHash() =>
    r'5d290462e2d2949d379e818ef501bb594ac4f6e8';

abstract class _$PrivacyPolicyController
    extends $AsyncNotifier<List<ContentPageItem>> {
  FutureOr<List<ContentPageItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ContentPageItem>>, List<ContentPageItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ContentPageItem>>,
                List<ContentPageItem>
              >,
              AsyncValue<List<ContentPageItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
