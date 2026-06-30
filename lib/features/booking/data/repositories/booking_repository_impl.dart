import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/calendar_block_response.dart';
import '../data_sources/booking_service_client.dart';
import '../models/asset_calendar.dart';
import '../models/booking_response.dart';
import '../models/my_booking_item.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingServiceClient _serviceClient;

  BookingRepositoryImpl(this._serviceClient);

  @override
  Future<BookingResponse> bookAsset({
    required int assetId,
    required String checkIn,
    required String checkOut,
    required int guests,
    required String paymentMethod,
    int? nights,
    int? monthsCount,
    int? yearsCount,
    String? notes,
  }) async {
    try {
      return await _serviceClient.bookAsset(
        assetId: assetId,
        checkIn: checkIn,
        checkOut: checkOut,
        nights: nights,
        monthsCount: monthsCount,
        yearsCount: yearsCount,
        guests: guests,
        paymentMethod: paymentMethod,
        notes: notes,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? (data['message'] as String? ?? 'Booking failed')
          : 'Booking failed';
      throw Exception(message);
    }
  }

  @override
  Future<List<MyBookingItem>> getMyBookings({required String status}) async {
    try {
      return await _serviceClient.getMyBookings(status: status);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? (data['message'] as String? ?? 'Failed to load bookings')
          : 'Failed to load bookings';
      throw Exception(message);
    }
  }

  @override
  Future<AssetCalendarData> getAssetCalendar(int assetId) async {
    try {
      final response = await _serviceClient.getAssetCalendar(assetId);
      return response.data;
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? (data['message'] as String? ?? 'Failed to load calendar')
          : 'Failed to load calendar';
      throw Exception(message);
    }
  }

  @override
  Future<String> updateCalendarDates({
    required int assetId,
    required List<DateTime> dates,
    required String status,
  }) async {
    if (dates.isEmpty) {
      throw Exception('Select at least one date');
    }

    final formData = FormData();
    formData.fields.add(MapEntry('asset_id', assetId.toString()));
    formData.fields.add(MapEntry('status', status));
    for (var i = 0; i < dates.length; i++) {
      final day = dates[i];
      final formatted =
          '${day.year.toString().padLeft(4, '0')}-'
          '${day.month.toString().padLeft(2, '0')}-'
          '${day.day.toString().padLeft(2, '0')}';
      formData.fields.add(MapEntry('dates[$i]', formatted));
    }

    try {
      final response = await DioFactory.getDio().post<Map<String, dynamic>>(
        ApiConstants.calendarBlock,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final data = response.data;
      if (data == null) {
        throw Exception('Failed to update calendar');
      }
      final parsed = CalendarBlockResponse.fromJson(data);
      if (!parsed.status) {
        throw Exception(parsed.message);
      }
      return parsed.message;
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? (data['message'] as String? ?? 'Failed to update calendar')
          : 'Failed to update calendar';
      throw Exception(message);
    }
  }
}
