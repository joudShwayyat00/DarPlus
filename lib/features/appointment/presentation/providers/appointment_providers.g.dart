// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appointmentServiceClient)
const appointmentServiceClientProvider = AppointmentServiceClientProvider._();

final class AppointmentServiceClientProvider
    extends
        $FunctionalProvider<
          AppointmentServiceClient,
          AppointmentServiceClient,
          AppointmentServiceClient
        >
    with $Provider<AppointmentServiceClient> {
  const AppointmentServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentServiceClientHash();

  @$internal
  @override
  $ProviderElement<AppointmentServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppointmentServiceClient create(Ref ref) {
    return appointmentServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppointmentServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppointmentServiceClient>(value),
    );
  }
}

String _$appointmentServiceClientHash() =>
    r'6b9a0606f2daefee08384591c8fc0070484968e1';

@ProviderFor(appointmentRepository)
const appointmentRepositoryProvider = AppointmentRepositoryProvider._();

final class AppointmentRepositoryProvider
    extends
        $FunctionalProvider<
          AppointmentRepository,
          AppointmentRepository,
          AppointmentRepository
        >
    with $Provider<AppointmentRepository> {
  const AppointmentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentRepositoryHash();

  @$internal
  @override
  $ProviderElement<AppointmentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppointmentRepository create(Ref ref) {
    return appointmentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppointmentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppointmentRepository>(value),
    );
  }
}

String _$appointmentRepositoryHash() =>
    r'b8413b7b79863b3777cfbb28660dc0774fc14d3f';

@ProviderFor(AppointmentController)
const appointmentControllerProvider = AppointmentControllerProvider._();

final class AppointmentControllerProvider
    extends $AsyncNotifierProvider<AppointmentController, AppointmentData?> {
  const AppointmentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentControllerHash();

  @$internal
  @override
  AppointmentController create() => AppointmentController();
}

String _$appointmentControllerHash() =>
    r'2d7325326ce2b7ce593b3284b1659765d3cc145f';

abstract class _$AppointmentController
    extends $AsyncNotifier<AppointmentData?> {
  FutureOr<AppointmentData?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<AppointmentData?>, AppointmentData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppointmentData?>, AppointmentData?>,
              AsyncValue<AppointmentData?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
