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

@ProviderFor(EditAppointmentController)
const editAppointmentControllerProvider = EditAppointmentControllerProvider._();

final class EditAppointmentControllerProvider
    extends
        $AsyncNotifierProvider<EditAppointmentController, AppointmentData?> {
  const EditAppointmentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editAppointmentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editAppointmentControllerHash();

  @$internal
  @override
  EditAppointmentController create() => EditAppointmentController();
}

String _$editAppointmentControllerHash() =>
    r'72b226974832818bea34ff09ac1fc6d7638c1d43';

abstract class _$EditAppointmentController
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

/// Appointments the current user requested on properties (buyer/visitor view).

@ProviderFor(MyRequestedAppointmentsController)
const myRequestedAppointmentsControllerProvider =
    MyRequestedAppointmentsControllerProvider._();

/// Appointments the current user requested on properties (buyer/visitor view).
final class MyRequestedAppointmentsControllerProvider
    extends
        $AsyncNotifierProvider<
          MyRequestedAppointmentsController,
          List<MyAppointmentItem>
        > {
  /// Appointments the current user requested on properties (buyer/visitor view).
  const MyRequestedAppointmentsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myRequestedAppointmentsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$myRequestedAppointmentsControllerHash();

  @$internal
  @override
  MyRequestedAppointmentsController create() =>
      MyRequestedAppointmentsController();
}

String _$myRequestedAppointmentsControllerHash() =>
    r'cc96792998b8c7d639748376c9a1ef2bfd474bc0';

/// Appointments the current user requested on properties (buyer/visitor view).

abstract class _$MyRequestedAppointmentsController
    extends $AsyncNotifier<List<MyAppointmentItem>> {
  FutureOr<List<MyAppointmentItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<MyAppointmentItem>>,
              List<MyAppointmentItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MyAppointmentItem>>,
                List<MyAppointmentItem>
              >,
              AsyncValue<List<MyAppointmentItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Incoming appointment requests on the owner's listed properties.

@ProviderFor(OwnerAppointmentsController)
const ownerAppointmentsControllerProvider =
    OwnerAppointmentsControllerFamily._();

/// Incoming appointment requests on the owner's listed properties.
final class OwnerAppointmentsControllerProvider
    extends
        $AsyncNotifierProvider<
          OwnerAppointmentsController,
          List<MyAppointmentItem>
        > {
  /// Incoming appointment requests on the owner's listed properties.
  const OwnerAppointmentsControllerProvider._({
    required OwnerAppointmentsControllerFamily super.from,
    required AppointmentStatusFilter super.argument,
  }) : super(
         retry: null,
         name: r'ownerAppointmentsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ownerAppointmentsControllerHash();

  @override
  String toString() {
    return r'ownerAppointmentsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OwnerAppointmentsController create() => OwnerAppointmentsController();

  @override
  bool operator ==(Object other) {
    return other is OwnerAppointmentsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ownerAppointmentsControllerHash() =>
    r'a0e2074b4174ccab23c4a3d87fa25985521502e7';

/// Incoming appointment requests on the owner's listed properties.

final class OwnerAppointmentsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          OwnerAppointmentsController,
          AsyncValue<List<MyAppointmentItem>>,
          List<MyAppointmentItem>,
          FutureOr<List<MyAppointmentItem>>,
          AppointmentStatusFilter
        > {
  const OwnerAppointmentsControllerFamily._()
    : super(
        retry: null,
        name: r'ownerAppointmentsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Incoming appointment requests on the owner's listed properties.

  OwnerAppointmentsControllerProvider call(AppointmentStatusFilter status) =>
      OwnerAppointmentsControllerProvider._(argument: status, from: this);

  @override
  String toString() => r'ownerAppointmentsControllerProvider';
}

/// Incoming appointment requests on the owner's listed properties.

abstract class _$OwnerAppointmentsController
    extends $AsyncNotifier<List<MyAppointmentItem>> {
  late final _$args = ref.$arg as AppointmentStatusFilter;
  AppointmentStatusFilter get status => _$args;

  FutureOr<List<MyAppointmentItem>> build(AppointmentStatusFilter status);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<MyAppointmentItem>>,
              List<MyAppointmentItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MyAppointmentItem>>,
                List<MyAppointmentItem>
              >,
              AsyncValue<List<MyAppointmentItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ownerAllAppointments)
const ownerAllAppointmentsProvider = OwnerAllAppointmentsProvider._();

final class OwnerAllAppointmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MyAppointmentItem>>,
          List<MyAppointmentItem>,
          FutureOr<List<MyAppointmentItem>>
        >
    with
        $FutureModifier<List<MyAppointmentItem>>,
        $FutureProvider<List<MyAppointmentItem>> {
  const OwnerAllAppointmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownerAllAppointmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownerAllAppointmentsHash();

  @$internal
  @override
  $FutureProviderElement<List<MyAppointmentItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MyAppointmentItem>> create(Ref ref) {
    return ownerAllAppointments(ref);
  }
}

String _$ownerAllAppointmentsHash() =>
    r'fbc94e895fe48837057dd798d1e7baf669a30d74';
