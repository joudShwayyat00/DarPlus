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
  description: json['description'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  monthsCount: (json['months_count'] as num?)?.toInt(),
  rentType: json['rent_type'] as String?,
  rentPrice: json['rent_price'] as num?,
  attributes: (json['attributes'] as List<dynamic>?)
      ?.map((e) => AssetAttribute.fromJson(e as Map<String, dynamic>))
      .toList(),
  amenities: (json['amenities'] as List<dynamic>?)
      ?.map((e) => AssetAmenity.fromJson(e as Map<String, dynamic>))
      .toList(),
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
  'description': instance.description,
  'phone': instance.phone,
  'email': instance.email,
  'months_count': instance.monthsCount,
  'rent_type': instance.rentType,
  'rent_price': instance.rentPrice,
  'attributes': instance.attributes,
  'amenities': instance.amenities,
};
