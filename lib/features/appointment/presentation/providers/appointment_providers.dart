import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_factory.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/data_sources/appointment_service_client.dart';
import '../../data/models/appointment_response.dart';
import '../../data/models/my_appointment_item.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../domain/appointment_status_filter.dart';
import '../../domain/repositories/appointment_repository.dart';

part 'appointment_providers.g.dart';

@riverpod
AppointmentServiceClient appointmentServiceClient(Ref ref) {
  final dio = DioFactory.getDio();
  return AppointmentServiceClient(dio);
}

@riverpod
AppointmentRepository appointmentRepository(Ref ref) {
  final client = ref.watch(appointmentServiceClientProvider);
  return AppointmentRepositoryImpl(client);
}

@riverpod
class AppointmentController extends _$AppointmentController {
  @override
  FutureOr<AppointmentData?> build() => null;

  Future<void> submit({
    required int assetId,
    required String name,
    required String phone,
    required String email,
    required String date,
    required String time,
    String? note,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<AppointmentData?>(() async {
      final response = await ref
          .read(appointmentRepositoryProvider)
          .addAppointment(
            assetId: assetId,
            name: name,
            phone: phone,
            email: email,
            date: date,
            time: time,
            note: note,
          );
      return response.data;
    });
  }

  void reset() => state = const AsyncData(null);
}

@riverpod
class EditAppointmentController extends _$EditAppointmentController {
  @override
  FutureOr<AppointmentData?> build() => null;

  Future<void> submit({
    required int appointmentId,
    required String name,
    required String phone,
    required String email,
    required String date,
    required String time,
    String? note,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<AppointmentData?>(() async {
      final response = await ref
          .read(appointmentRepositoryProvider)
          .editAppointment(
            appointmentId: appointmentId,
            name: name,
            phone: phone,
            email: email,
            date: date,
            time: time,
            note: note,
          );
      return response.data;
    });
  }

  void reset() => state = const AsyncData(null);
}

/// Appointments the current user requested on properties (buyer/visitor view).
@riverpod
class MyRequestedAppointmentsController
    extends _$MyRequestedAppointmentsController {
  @override
  FutureOr<List<MyAppointmentItem>> build() async {
    if (!ref.read(isLoggedInProvider)) return [];
    return ref.read(appointmentRepositoryProvider).getMyAppointments();
  }

  Future<void> refresh() async {
    if (!ref.read(isLoggedInProvider)) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(appointmentRepositoryProvider).getMyAppointments();
    });
  }

  Future<String> deleteAppointment(int appointmentId) async {
    final message = await ref
        .read(appointmentRepositoryProvider)
        .deleteAppointment(appointmentId: appointmentId);
    await refresh();
    return message;
  }
}

/// Incoming appointment requests on the owner's listed properties.
@riverpod
class OwnerAppointmentsController extends _$OwnerAppointmentsController {
  @override
  FutureOr<List<MyAppointmentItem>> build(
    AppointmentStatusFilter status,
  ) async {
    if (!ref.read(isLoggedInProvider)) return [];
    final user = ref.read(profileControllerProvider).value;
    if (user?.isOwner != true) return [];

    return ref.read(appointmentRepositoryProvider).getOwnerAppointments(
          status: status.apiValue,
        );
  }

  Future<void> refresh() async {
    if (!ref.read(isLoggedInProvider)) {
      state = const AsyncData([]);
      return;
    }
    final user = ref.read(profileControllerProvider).value;
    if (user?.isOwner != true) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(appointmentRepositoryProvider).getOwnerAppointments(
            status: status.apiValue,
          );
    });
  }
}

@riverpod
Future<List<MyAppointmentItem>> ownerAllAppointments(Ref ref) async {
  if (!ref.read(isLoggedInProvider)) return [];
  final user = ref.read(profileControllerProvider).value;
  if (user?.isOwner != true) return [];
  return ref.read(appointmentRepositoryProvider).getOwnerAppointments(
        status: AppointmentStatusFilter.pending.apiValue,
      );
}
