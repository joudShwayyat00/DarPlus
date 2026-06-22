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

  Future<List<MyAppointmentItem>> getMyAppointments();
}
