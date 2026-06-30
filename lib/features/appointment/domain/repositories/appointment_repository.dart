import '../../data/models/appointment_response.dart';
import '../../data/models/my_appointment_item.dart';

abstract class AppointmentRepository {
  Future<AppointmentResponse> addAppointment({
    required int assetId,
    required String name,
    required String phone,
    required String email,
    required String date,
    required String time,
    String? note,
  });

  Future<List<MyAppointmentItem>> getOwnerAppointments({
    required String status,
    int? assetId,
    int page = 1,
  });

  Future<List<MyAppointmentItem>> getMyAppointments();

  Future<AppointmentResponse> editAppointment({
    required int appointmentId,
    required String name,
    required String phone,
    required String email,
    required String date,
    required String time,
    String? note,
  });

  Future<String> deleteAppointment({required int appointmentId});
}
