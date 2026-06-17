import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/features/auth/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'booking_currency.dart';

part 'my_booking_item.g.dart';

@JsonSerializable()
class MyBookingItem {
  final int id;
  @JsonKey(name: 'user_id')
  final UserModel user;
  @JsonKey(name: 'asset_id')
  final AssetItem asset;
  @JsonKey(name: 'check_in_date')
  final String checkInDate;
  @JsonKey(name: 'check_out_date')
  final String checkOutDate;
  final int nights;
  final int guests;
  @JsonKey(name: 'price_per_night')
  final String pricePerNight;
  @JsonKey(name: 'total_price')
  final num totalPrice;
  @JsonKey(name: 'service_fee')
  final String serviceFee;
  @JsonKey(name: 'final_price')
  final num finalPrice;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  final String? notes;
  final String status;
  final BookingCurrency currency;

  const MyBookingItem({
    required this.id,
    required this.user,
    required this.asset,
    required this.checkInDate,
    required this.checkOutDate,
    required this.nights,
    required this.guests,
    required this.pricePerNight,
    required this.totalPrice,
    required this.serviceFee,
    required this.finalPrice,
    required this.paymentMethod,
    required this.notes,
    required this.status,
    required this.currency,
  });

  factory MyBookingItem.fromJson(Map<String, dynamic> json) =>
      _$MyBookingItemFromJson(json);
}
