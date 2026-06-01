// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_amenity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetAmenity _$AssetAmenityFromJson(Map<String, dynamic> json) => AssetAmenity(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  icon: json['icon'] as String,
);

Map<String, dynamic> _$AssetAmenityToJson(AssetAmenity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
    };
