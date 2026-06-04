import 'package:json_annotation/json_annotation.dart';

part 'booking_response.g.dart';

@JsonSerializable()
class BookingResponse {
  final String message;
  final BookingData data;

  BookingResponse({required this.message, required this.data});

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookingResponseToJson(this);
}

@JsonSerializable()
class BookingData {
  @JsonKey(name: 'booking_id')
  final int bookingId;
  @JsonKey(name: 'check_in')
  final String checkIn;
  @JsonKey(name: 'check_out')
  final String checkOut;
  final String nights;
  final String guests;
  @JsonKey(name: 'total_price')
  final num totalPrice;
  @JsonKey(name: 'service_fee')
  final num serviceFee;
  @JsonKey(name: 'final_price')
  final num finalPrice;
  final String status;

  BookingData({
    required this.bookingId,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.guests,
    required this.totalPrice,
    required this.serviceFee,
    required this.finalPrice,
    required this.status,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) =>
      _$BookingDataFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDataToJson(this);
}
