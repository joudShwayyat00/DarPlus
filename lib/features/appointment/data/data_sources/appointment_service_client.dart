import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/appointment_response.dart';
import '../models/my_appointments_response.dart';

part 'appointment_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class AppointmentServiceClient {
  factory AppointmentServiceClient(Dio dio, {String baseUrl}) =
      _AppointmentServiceClient;

  @POST(ApiConstants.addAppointment)
  @MultiPart()
  Future<AppointmentResponse> addAppointment({
    @Part(name: 'asset_id') required int assetId,
    @Part(name: 'name') required String name,
    @Part(name: 'phone') required String phone,
    @Part(name: 'email') required String email,
    @Part(name: 'date') required String date,
    @Part(name: 'time') required String time,
    @Part(name: 'note') String? note,
  });

  @GET(ApiConstants.myAppointments)
  Future<MyAppointmentsResponse> getMyAppointments();
}
