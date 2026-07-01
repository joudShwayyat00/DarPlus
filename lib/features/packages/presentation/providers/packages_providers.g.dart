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
    r'928e553cfc92af98a0612e200aeebb5495221229';

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
    r'93b134f577ea3553102689c22b1d67fc688350e2';

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
    r'efa8fbf211ac1b2b99306b7c01677aff29143a89';

abstract class _$PackagesController extends $AsyncNotifier<List<PackageItem>> {
  FutureOr<List<PackageItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<PackageItem>>, List<PackageItem>>;
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

@ProviderFor(MySubscriptionsController)
const mySubscriptionsControllerProvider = MySubscriptionsControllerProvider._();

final class MySubscriptionsControllerProvider
    extends
        $AsyncNotifierProvider<
          MySubscriptionsController,
          List<MySubscriptionItem>
        > {
  const MySubscriptionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mySubscriptionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mySubscriptionsControllerHash();

  @$internal
  @override
  MySubscriptionsController create() => MySubscriptionsController();
}

String _$mySubscriptionsControllerHash() =>
    r'811ce37652a69a87ad143b0c89c9856c5b751173';

abstract class _$MySubscriptionsController
    extends $AsyncNotifier<List<MySubscriptionItem>> {
  FutureOr<List<MySubscriptionItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<MySubscriptionItem>>,
              List<MySubscriptionItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MySubscriptionItem>>,
                List<MySubscriptionItem>
              >,
              AsyncValue<List<MySubscriptionItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PaymentInfoController)
const paymentInfoControllerProvider = PaymentInfoControllerProvider._();

final class PaymentInfoControllerProvider
    extends
        $AsyncNotifierProvider<PaymentInfoController, PaymentInfoResponse?> {
  const PaymentInfoControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentInfoControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentInfoControllerHash();

  @$internal
  @override
  PaymentInfoController create() => PaymentInfoController();
}

String _$paymentInfoControllerHash() =>
    r'4cb666f629e847928348a0990f6af9e3a5f7e29e';

abstract class _$PaymentInfoController
    extends $AsyncNotifier<PaymentInfoResponse?> {
  FutureOr<PaymentInfoResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<PaymentInfoResponse?>, PaymentInfoResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaymentInfoResponse?>,
                PaymentInfoResponse?
              >,
              AsyncValue<PaymentInfoResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SubscriptionStatusController)
const subscriptionStatusControllerProvider =
    SubscriptionStatusControllerProvider._();

final class SubscriptionStatusControllerProvider
    extends
        $AsyncNotifierProvider<
          SubscriptionStatusController,
          SubscriptionStatusResponse?
        > {
  const SubscriptionStatusControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionStatusControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionStatusControllerHash();

  @$internal
  @override
  SubscriptionStatusController create() => SubscriptionStatusController();
}

String _$subscriptionStatusControllerHash() =>
    r'b364e39756b651f2a36c07756798e5c5c400b426';

abstract class _$SubscriptionStatusController
    extends $AsyncNotifier<SubscriptionStatusResponse?> {
  FutureOr<SubscriptionStatusResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<SubscriptionStatusResponse?>,
              SubscriptionStatusResponse?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SubscriptionStatusResponse?>,
                SubscriptionStatusResponse?
              >,
              AsyncValue<SubscriptionStatusResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SubscribeController)
const subscribeControllerProvider = SubscribeControllerProvider._();

final class SubscribeControllerProvider
    extends $AsyncNotifierProvider<SubscribeController, SubscribeResponse?> {
  const SubscribeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscribeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscribeControllerHash();

  @$internal
  @override
  SubscribeController create() => SubscribeController();
}

String _$subscribeControllerHash() =>
    r'ef8a8e015d0637d0c768bd357a11229354ccbfd0';

abstract class _$SubscribeController
    extends $AsyncNotifier<SubscribeResponse?> {
  FutureOr<SubscribeResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<SubscribeResponse?>, SubscribeResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SubscribeResponse?>, SubscribeResponse?>,
              AsyncValue<SubscribeResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(UploadProofController)
const uploadProofControllerProvider = UploadProofControllerProvider._();

final class UploadProofControllerProvider
    extends
        $AsyncNotifierProvider<UploadProofController, UploadProofResponse?> {
  const UploadProofControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadProofControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadProofControllerHash();

  @$internal
  @override
  UploadProofController create() => UploadProofController();
}

String _$uploadProofControllerHash() =>
    r'f0ba293596ae7af117bfc547de48f5014dc9c375';

abstract class _$UploadProofController
    extends $AsyncNotifier<UploadProofResponse?> {
  FutureOr<UploadProofResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<UploadProofResponse?>, UploadProofResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<UploadProofResponse?>,
                UploadProofResponse?
              >,
              AsyncValue<UploadProofResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AwaitingReviewSubscriptions)
const awaitingReviewSubscriptionsProvider =
    AwaitingReviewSubscriptionsProvider._();

final class AwaitingReviewSubscriptionsProvider
    extends $NotifierProvider<AwaitingReviewSubscriptions, Set<int>> {
  const AwaitingReviewSubscriptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'awaitingReviewSubscriptionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$awaitingReviewSubscriptionsHash();

  @$internal
  @override
  AwaitingReviewSubscriptions create() => AwaitingReviewSubscriptions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }
}

String _$awaitingReviewSubscriptionsHash() =>
    r'84b6d67543820ce35435b3a98b22bcf22b0d4849';

abstract class _$AwaitingReviewSubscriptions extends $Notifier<Set<int>> {
  Set<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<int>, Set<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<int>, Set<int>>,
              Set<int>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
