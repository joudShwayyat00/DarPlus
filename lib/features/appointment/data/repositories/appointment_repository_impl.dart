import 'package:dio/dio.dart';

import '../../domain/repositories/appointment_repository.dart';
import '../data_sources/appointment_service_client.dart';
import '../models/appointment_response.dart';
import '../models/my_appointment_item.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentServiceClient _serviceClient;

  AppointmentRepositoryImpl(this._serviceClient);

  @override
  Future<AppointmentResponse> addAppointment({
    required int assetId,
    required String name,
    required String phone,
    required String email,
    required String date,
    required String time,
    String? note,
  }) async {
    try {
      return await _serviceClient.addAppointment(
        assetId: assetId,
        name: name,
        phone: phone,
        email: email,
        date: date,
        time: time,
        note: note,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? (data['message'] as String? ?? 'Appointment failed')
          : 'Appointment failed';
      throw Exception(message);
    }
  }

  @override
  Future<List<MyAppointmentItem>> getMyAppointments() async {
    try {
      final response = await _serviceClient.getMyAppointments();
      return response.data;
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? (data['message'] as String? ?? 'Failed to load appointments')
          : 'Failed to load appointments';
      throw Exception(message);
    }
  }
}
