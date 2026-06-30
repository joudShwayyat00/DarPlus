import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/asset_calendar.dart';
import '../models/booking_response.dart';
import '../models/my_booking_item.dart';

part 'booking_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class BookingServiceClient {
  factory BookingServiceClient(Dio dio, {String baseUrl}) =
      _BookingServiceClient;

  @POST(ApiConstants.bookAsset)
  @MultiPart()
  Future<BookingResponse> bookAsset({
    @Part(name: 'asset_id') required int assetId,
    @Part(name: 'check_in') required String checkIn,
    @Part(name: 'check_out') required String checkOut,
    @Part(name: 'nights') int? nights,
    @Part(name: 'months_count') int? monthsCount,
    @Part(name: 'years_count') int? yearsCount,
    @Part(name: 'guests') required int guests,
    @Part(name: 'payment_method') required String paymentMethod,
    @Part(name: 'notes') String? notes,
  });

  @POST(ApiConstants.myBookings)
  @MultiPart()
  Future<List<MyBookingItem>> getMyBookings({
    @Part(name: 'status') required String status,
  });

  @GET('${ApiConstants.assetCalendar}/{assetId}')
  Future<AssetCalendarResponse> getAssetCalendar(
    @Path('assetId') int assetId,
  );
}
