import 'package:json_annotation/json_annotation.dart';

part 'booking_response.g.dart';

@JsonSerializable()
class BookingResponse {
  final String message;
  final BookingData data;

  const BookingResponse({required this.message, required this.data});

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookingResponseToJson(this);
}

@JsonSerializable()
class BookingData {
  final int id;
  final String? customer;
  @JsonKey(name: 'check_in_date')
  final String checkInDate;
  @JsonKey(name: 'check_out_date')
  final String checkOutDate;
  final String? type;
  final num? price;
  @JsonKey(fromJson: _intFromJson)
  final int nights;
  @JsonKey(name: 'months_count', fromJson: _stringFromJson)
  final String monthsCount;
  @JsonKey(name: 'years_count', fromJson: _intFromJson)
  final int yearsCount;
  @JsonKey(fromJson: _stringFromJson)
  final String guests;
  @JsonKey(name: 'total_price')
  final num totalPrice;
  @JsonKey(name: 'service_fee')
  final num serviceFee;
  @JsonKey(name: 'final_price')
  final num finalPrice;
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  final String? notes;
  final String status;
  final String? currency;

  const BookingData({
    required this.id,
    this.customer,
    required this.checkInDate,
    required this.checkOutDate,
    this.type,
    this.price,
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
    this.currency,
  });

  int get bookingId => id;

  factory BookingData.fromJson(Map<String, dynamic> json) =>
      _$BookingDataFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDataToJson(this);

  static int _intFromJson(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _stringFromJson(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}
