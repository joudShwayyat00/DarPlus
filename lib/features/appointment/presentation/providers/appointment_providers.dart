import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/appointment_service_client.dart';
import '../../data/models/appointment_response.dart';
import '../../data/repositories/appointment_repository_impl.dart';
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
