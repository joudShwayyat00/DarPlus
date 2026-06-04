import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/booking_response.dart';

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
    @Part(name: 'nights') required int nights,
    @Part(name: 'guests') required int guests,
    @Part(name: 'payment_method') required String paymentMethod,
    @Part(name: 'notes') String? notes,
  });
}
