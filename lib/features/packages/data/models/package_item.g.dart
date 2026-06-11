// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageItem _$PackageItemFromJson(Map<String, dynamic> json) => PackageItem(
  id: (json['id'] as num).toInt(),
  name: LocalizedName.fromJson(json['name'] as Map<String, dynamic>),
  price: json['price'] as String,
  durationDays: (json['duration_days'] as num).toInt(),
  saleAssetsLimit: (json['sale_assets_limit'] as num).toInt(),
  rentAssetsLimit: (json['rent_assets_limit'] as num).toInt(),
);

Map<String, dynamic> _$PackageItemToJson(PackageItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'duration_days': instance.durationDays,
      'sale_assets_limit': instance.saleAssetsLimit,
      'rent_assets_limit': instance.rentAssetsLimit,
    };
