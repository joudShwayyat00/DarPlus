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

@ProviderFor(AboutUsController)
const aboutUsControllerProvider = AboutUsControllerProvider._();

final class AboutUsControllerProvider
    extends $AsyncNotifierProvider<AboutUsController, AboutUsItem> {
  const AboutUsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aboutUsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aboutUsControllerHash();

  @$internal
  @override
  AboutUsController create() => AboutUsController();
}

String _$aboutUsControllerHash() => r'ea0b866cf55c05d77058e140428923b2ae177eaa';

abstract class _$AboutUsController extends $AsyncNotifier<AboutUsItem> {
  FutureOr<AboutUsItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AboutUsItem>, AboutUsItem>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AboutUsItem>, AboutUsItem>,
              AsyncValue<AboutUsItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ContactDataController)
const contactDataControllerProvider = ContactDataControllerProvider._();

final class ContactDataControllerProvider
    extends $AsyncNotifierProvider<ContactDataController, ContactDataItem> {
  const ContactDataControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactDataControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactDataControllerHash();

  @$internal
  @override
  ContactDataController create() => ContactDataController();
}

String _$contactDataControllerHash() =>
    r'98ba4e8e3f6e3e0798ada56abdc111e55d2a1638';

abstract class _$ContactDataController extends $AsyncNotifier<ContactDataItem> {
  FutureOr<ContactDataItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ContactDataItem>, ContactDataItem>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ContactDataItem>, ContactDataItem>,
              AsyncValue<ContactDataItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ContactUsSubmitController)
const contactUsSubmitControllerProvider = ContactUsSubmitControllerProvider._();

final class ContactUsSubmitControllerProvider
    extends
        $AsyncNotifierProvider<
          ContactUsSubmitController,
          ContactUsSubmitResponse?
        > {
  const ContactUsSubmitControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactUsSubmitControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactUsSubmitControllerHash();

  @$internal
  @override
  ContactUsSubmitController create() => ContactUsSubmitController();
}

String _$contactUsSubmitControllerHash() =>
    r'762861f83d3c87d420d4979228892a861250763e';

abstract class _$ContactUsSubmitController
    extends $AsyncNotifier<ContactUsSubmitResponse?> {
  FutureOr<ContactUsSubmitResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ContactUsSubmitResponse?>,
              ContactUsSubmitResponse?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ContactUsSubmitResponse?>,
                ContactUsSubmitResponse?
              >,
              AsyncValue<ContactUsSubmitResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
