import '../../data/models/booking_response.dart';

abstract class BookingRepository {
  Future<BookingResponse> bookAsset({
    required int assetId,
    required String checkIn,
    required String checkOut,
    required int nights,
    required int guests,
    required String paymentMethod,
    String? notes,
  });
}
