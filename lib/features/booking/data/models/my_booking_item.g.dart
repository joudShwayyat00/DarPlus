// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_booking_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyBookingItem _$MyBookingItemFromJson(Map<String, dynamic> json) =>
    MyBookingItem(
      id: (json['id'] as num).toInt(),
      user: UserModel.fromJson(json['user_id'] as Map<String, dynamic>),
      asset: AssetItem.fromJson(json['asset_id'] as Map<String, dynamic>),
      checkInDate: json['check_in_date'] as String,
      checkOutDate: json['check_out_date'] as String,
      nights: (json['nights'] as num).toInt(),
      guests: (json['guests'] as num).toInt(),
      pricePerNight: json['price_per_night'] as String,
      totalPrice: json['total_price'] as num,
      serviceFee: json['service_fee'] as String,
      finalPrice: json['final_price'] as num,
      paymentMethod: json['payment_method'] as String,
      notes: json['notes'] as String?,
      status: json['status'] as String,
      currency: BookingCurrency.fromJson(
        json['currency'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$MyBookingItemToJson(MyBookingItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user,
      'asset_id': instance.asset,
      'check_in_date': instance.checkInDate,
      'check_out_date': instance.checkOutDate,
      'nights': instance.nights,
      'guests': instance.guests,
      'price_per_night': instance.pricePerNight,
      'total_price': instance.totalPrice,
      'service_fee': instance.serviceFee,
      'final_price': instance.finalPrice,
      'payment_method': instance.paymentMethod,
      'notes': instance.notes,
      'status': instance.status,
      'currency': instance.currency,
    };
