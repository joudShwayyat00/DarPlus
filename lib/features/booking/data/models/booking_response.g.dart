// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingResponse _$BookingResponseFromJson(Map<String, dynamic> json) =>
    BookingResponse(
      message: json['message'] as String,
      data: BookingData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingResponseToJson(BookingResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

BookingData _$BookingDataFromJson(Map<String, dynamic> json) => BookingData(
  bookingId: (json['booking_id'] as num).toInt(),
  checkIn: json['check_in'] as String,
  checkOut: json['check_out'] as String,
  nights: json['nights'] as String,
  guests: json['guests'] as String,
  totalPrice: json['total_price'] as num,
  serviceFee: json['service_fee'] as num,
  finalPrice: json['final_price'] as num,
  status: json['status'] as String,
);

Map<String, dynamic> _$BookingDataToJson(BookingData instance) =>
    <String, dynamic>{
      'booking_id': instance.bookingId,
      'check_in': instance.checkIn,
      'check_out': instance.checkOut,
      'nights': instance.nights,
      'guests': instance.guests,
      'total_price': instance.totalPrice,
      'service_fee': instance.serviceFee,
      'final_price': instance.finalPrice,
      'status': instance.status,
    };
