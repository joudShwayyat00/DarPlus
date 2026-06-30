import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_booking_item.g.dart';

@JsonSerializable()
class MyBookingItem {
  final int id;
  final String? customer;
  @JsonKey(name: 'asset_id')
  final AssetItem asset;
  @JsonKey(name: 'check_in_date')
  final String checkInDate;
  @JsonKey(name: 'check_out_date')
  final String checkOutDate;
  final String? type;
  @JsonKey(fromJson: _stringFromJson)
  final String price;
  @JsonKey(fromJson: _intFromJson)
  final int nights;
  @JsonKey(name: 'months_count', fromJson: _intFromJson)
  final int monthsCount;
  @JsonKey(name: 'years_count', fromJson: _intFromJson)
  final int yearsCount;
  @JsonKey(fromJson: _intFromJson)
  final int guests;
  @JsonKey(name: 'total_price', fromJson: _numFromJson)
  final num totalPrice;
  @JsonKey(name: 'service_fee', fromJson: _numFromJson)
  final num serviceFee;
  @JsonKey(name: 'final_price', fromJson: _numFromJson)
  final num finalPrice;
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  final String? notes;
  final String status;
  @JsonKey(fromJson: _currencyFromJson)
  final String currency;

  const MyBookingItem({
    required this.id,
    this.customer,
    required this.asset,
    required this.checkInDate,
    required this.checkOutDate,
    this.type,
    required this.price,
    required this.nights,
    required this.monthsCount,
    required this.yearsCount,
    required this.guests,
    required this.totalPrice,
    required this.serviceFee,
    required this.finalPrice,
    this.paymentMethod,
    this.notes,
    required this.status,
    required this.currency,
  });

  String get currencySymbol => currency;

  factory MyBookingItem.fromJson(Map<String, dynamic> json) =>
      _$MyBookingItemFromJson(json);

  static int _intFromJson(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static num _numFromJson(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }

  static String _stringFromJson(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static String _currencyFromJson(dynamic value) {
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return value['symbol'] as String? ??
          value['code'] as String? ??
          'JD';
    }
    return 'JD';
  }
}
