import 'package:dio/dio.dart';

import '../../domain/repositories/booking_repository.dart';
import '../data_sources/booking_service_client.dart';
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
      return await _serviceClient.getMyBookings(status);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? (data['message'] as String? ?? 'Failed to load bookings')
          : 'Failed to load bookings';
      throw Exception(message);
    }
  }
}
