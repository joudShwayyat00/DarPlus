// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amenity_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmenityItem _$AmenityItemFromJson(Map<String, dynamic> json) => AmenityItem(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  icon: json['icon'] as String,
);

Map<String, dynamic> _$AmenityItemToJson(AmenityItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
    };
