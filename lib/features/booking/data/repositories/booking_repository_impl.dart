import '../../domain/repositories/booking_repository.dart';
import '../data_sources/booking_service_client.dart';
import '../models/booking_response.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingServiceClient _serviceClient;

  BookingRepositoryImpl(this._serviceClient);

  @override
  Future<BookingResponse> bookAsset({
    required int assetId,
    required String checkIn,
    required String checkOut,
    required int nights,
    required int guests,
    required String paymentMethod,
    String? notes,
  }) async {
    return await _serviceClient.bookAsset(
      assetId: assetId,
      checkIn: checkIn,
      checkOut: checkOut,
      nights: nights,
      guests: guests,
      paymentMethod: paymentMethod,
      notes: notes,
    );
  }
}
