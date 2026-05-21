// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetItem _$AssetItemFromJson(Map<String, dynamic> json) => AssetItem(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  image: json['image'] as String,
  location: json['location'] as String,
  price: json['price'] as String,
  category: CategoryItem.fromJson(json['category'] as Map<String, dynamic>),
  owner: AssetOwner.fromJson(json['owner'] as Map<String, dynamic>),
  type: json['type'] as String,
);

Map<String, dynamic> _$AssetItemToJson(AssetItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image': instance.image,
  'location': instance.location,
  'price': instance.price,
  'category': instance.category,
  'owner': instance.owner,
  'type': instance.type,
};
