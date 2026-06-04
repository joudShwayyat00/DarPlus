// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookingServiceClient)
const bookingServiceClientProvider = BookingServiceClientProvider._();

final class BookingServiceClientProvider
    extends
        $FunctionalProvider<
          BookingServiceClient,
          BookingServiceClient,
          BookingServiceClient
        >
    with $Provider<BookingServiceClient> {
  const BookingServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingServiceClientHash();

  @$internal
  @override
  $ProviderElement<BookingServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingServiceClient create(Ref ref) {
    return bookingServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingServiceClient>(value),
    );
  }
}

String _$bookingServiceClientHash() =>
    r'b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0';

@ProviderFor(bookingRepository)
const bookingRepositoryProvider = BookingRepositoryProvider._();

final class BookingRepositoryProvider
    extends
        $FunctionalProvider<
          BookingRepository,
          BookingRepository,
          BookingRepository
        >
    with $Provider<BookingRepository> {
  const BookingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingRepository create(Ref ref) {
    return bookingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingRepository>(value),
    );
  }
}

String _$bookingRepositoryHash() => r'c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1';

@ProviderFor(BookingController)
const bookingControllerProvider = BookingControllerProvider._();

final class BookingControllerProvider
    extends $AsyncNotifierProvider<BookingController, BookingData?> {
  const BookingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingControllerHash();

  @$internal
  @override
  BookingController create() => BookingController();
}

String _$bookingControllerHash() => r'd3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2';

abstract class _$BookingController extends $AsyncNotifier<BookingData?> {
  FutureOr<BookingData?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<BookingData?>, BookingData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BookingData?>, BookingData?>,
              AsyncValue<BookingData?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
