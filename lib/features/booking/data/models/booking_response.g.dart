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
  id: (json['id'] as num).toInt(),
  customer: json['customer'] as String?,
  checkInDate: json['check_in_date'] as String,
  checkOutDate: json['check_out_date'] as String,
  type: json['type'] as String?,
  price: json['price'] as num?,
  nights: BookingData._intFromJson(json['nights']),
  monthsCount: BookingData._stringFromJson(json['months_count']),
  yearsCount: BookingData._intFromJson(json['years_count']),
  guests: BookingData._stringFromJson(json['guests']),
  totalPrice: json['total_price'] as num,
  serviceFee: json['service_fee'] as num,
  finalPrice: json['final_price'] as num,
  paymentMethod: json['payment_method'] as String?,
  notes: json['notes'] as String?,
  status: json['status'] as String,
  currency: json['currency'] as String?,
);

Map<String, dynamic> _$BookingDataToJson(BookingData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer,
      'check_in_date': instance.checkInDate,
      'check_out_date': instance.checkOutDate,
      'type': instance.type,
      'price': instance.price,
      'nights': instance.nights,
      'months_count': instance.monthsCount,
      'years_count': instance.yearsCount,
      'guests': instance.guests,
      'total_price': instance.totalPrice,
      'service_fee': instance.serviceFee,
      'final_price': instance.finalPrice,
      'payment_method': instance.paymentMethod,
      'notes': instance.notes,
      'status': instance.status,
      'currency': instance.currency,
    };
