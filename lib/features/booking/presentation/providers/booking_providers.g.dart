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
    r'6f0208620027afa811c0d534ed3125c1f074e0ee';

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

String _$bookingRepositoryHash() => r'db99a6c7ec49d5553f9956ccb65238366813119e';

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

String _$bookingControllerHash() => r'c6f4eb459bf9045a127fc82105e988e9e55a6584';

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

@ProviderFor(assetCalendar)
const assetCalendarProvider = AssetCalendarFamily._();

final class AssetCalendarProvider
    extends
        $FunctionalProvider<
          AsyncValue<AssetCalendarData>,
          AssetCalendarData,
          FutureOr<AssetCalendarData>
        >
    with
        $FutureModifier<AssetCalendarData>,
        $FutureProvider<AssetCalendarData> {
  const AssetCalendarProvider._({
    required AssetCalendarFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'assetCalendarProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetCalendarHash();

  @override
  String toString() {
    return r'assetCalendarProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AssetCalendarData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AssetCalendarData> create(Ref ref) {
    final argument = this.argument as int;
    return assetCalendar(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetCalendarProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetCalendarHash() => r'4ce8313749abffaf4e28e78fea6f3f1ed61ffd4a';

final class AssetCalendarFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AssetCalendarData>, int> {
  const AssetCalendarFamily._()
    : super(
        retry: null,
        name: r'assetCalendarProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetCalendarProvider call(int assetId) =>
      AssetCalendarProvider._(argument: assetId, from: this);

  @override
  String toString() => r'assetCalendarProvider';
}

@ProviderFor(MyBookingsController)
const myBookingsControllerProvider = MyBookingsControllerFamily._();

final class MyBookingsControllerProvider
    extends $AsyncNotifierProvider<MyBookingsController, List<MyBookingItem>> {
  const MyBookingsControllerProvider._({
    required MyBookingsControllerFamily super.from,
    required BookingStatusFilter super.argument,
  }) : super(
         retry: null,
         name: r'myBookingsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$myBookingsControllerHash();

  @override
  String toString() {
    return r'myBookingsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MyBookingsController create() => MyBookingsController();

  @override
  bool operator ==(Object other) {
    return other is MyBookingsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$myBookingsControllerHash() =>
    r'e01a21bf9284d241eb081f0eea506e0fb7d4c2ee';

final class MyBookingsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          MyBookingsController,
          AsyncValue<List<MyBookingItem>>,
          List<MyBookingItem>,
          FutureOr<List<MyBookingItem>>,
          BookingStatusFilter
        > {
  const MyBookingsControllerFamily._()
    : super(
        retry: null,
        name: r'myBookingsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MyBookingsControllerProvider call(BookingStatusFilter status) =>
      MyBookingsControllerProvider._(argument: status, from: this);

  @override
  String toString() => r'myBookingsControllerProvider';
}

abstract class _$MyBookingsController
    extends $AsyncNotifier<List<MyBookingItem>> {
  late final _$args = ref.$arg as BookingStatusFilter;
  BookingStatusFilter get status => _$args;

  FutureOr<List<MyBookingItem>> build(BookingStatusFilter status);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<MyBookingItem>>, List<MyBookingItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MyBookingItem>>, List<MyBookingItem>>,
              AsyncValue<List<MyBookingItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
