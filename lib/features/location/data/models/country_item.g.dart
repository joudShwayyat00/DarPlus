// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryItem _$CountryItemFromJson(Map<String, dynamic> json) => CountryItem(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  prefix: json['prefix'] as String,
  isoCode: json['iso_code'] as String,
  image: json['image'] as String,
  order: (json['order'] as num).toInt(),
);

Map<String, dynamic> _$CountryItemToJson(CountryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'prefix': instance.prefix,
      'iso_code': instance.isoCode,
      'image': instance.image,
      'order': instance.order,
    };
