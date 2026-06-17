import 'package:json_annotation/json_annotation.dart';

part 'booking_currency.g.dart';

@JsonSerializable()
class BookingCurrency {
  final int id;
  final String name;
  final String code;
  final String symbol;
  @JsonKey(name: 'exchange_rate')
  final String exchangeRate;

  const BookingCurrency({
    required this.id,
    required this.name,
    required this.code,
    required this.symbol,
    required this.exchangeRate,
  });

  factory BookingCurrency.fromJson(Map<String, dynamic> json) =>
      _$BookingCurrencyFromJson(json);
}
