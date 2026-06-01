// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetAttribute _$AssetAttributeFromJson(Map<String, dynamic> json) =>
    AssetAttribute(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$AssetAttributeToJson(AssetAttribute instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'icon': instance.icon,
    };
