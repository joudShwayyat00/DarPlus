import '../../data/models/asset_calendar.dart';
import '../../data/models/booking_response.dart';
import '../../data/models/my_booking_item.dart';

abstract class BookingRepository {
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
  });

  Future<List<MyBookingItem>> getMyBookings({required String status});

  Future<AssetCalendarData> getAssetCalendar(int assetId);

  Future<String> updateCalendarDates({
    required int assetId,
    required List<DateTime> dates,
    required String status,
  });
}
