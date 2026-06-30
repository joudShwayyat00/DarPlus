// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_booking_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyBookingItem _$MyBookingItemFromJson(Map<String, dynamic> json) =>
    MyBookingItem(
      id: (json['id'] as num).toInt(),
      customer: json['customer'] as String?,
      asset: AssetItem.fromJson(json['asset_id'] as Map<String, dynamic>),
      checkInDate: json['check_in_date'] as String,
      checkOutDate: json['check_out_date'] as String,
      type: json['type'] as String?,
      price: MyBookingItem._stringFromJson(json['price']),
      nights: MyBookingItem._intFromJson(json['nights']),
      monthsCount: MyBookingItem._intFromJson(json['months_count']),
      yearsCount: MyBookingItem._intFromJson(json['years_count']),
      guests: MyBookingItem._intFromJson(json['guests']),
      totalPrice: MyBookingItem._numFromJson(json['total_price']),
      serviceFee: MyBookingItem._numFromJson(json['service_fee']),
      finalPrice: MyBookingItem._numFromJson(json['final_price']),
      paymentMethod: json['payment_method'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String,
      currency: MyBookingItem._currencyFromJson(json['currency']),
    );

Map<String, dynamic> _$MyBookingItemToJson(MyBookingItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer,
      'asset_id': instance.asset,
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
