// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingCurrency _$BookingCurrencyFromJson(Map<String, dynamic> json) =>
    BookingCurrency(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      code: json['code'] as String,
      symbol: json['symbol'] as String,
      exchangeRate: json['exchange_rate'] as String,
    );

Map<String, dynamic> _$BookingCurrencyToJson(BookingCurrency instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'symbol': instance.symbol,
      'exchange_rate': instance.exchangeRate,
    };
