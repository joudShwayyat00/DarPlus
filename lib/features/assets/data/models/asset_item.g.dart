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
  country: json['country'] as String?,
  city: json['city'] as String?,
  region: json['region'] as String?,
  price: json['price'] as String,
  category: CategoryItem.fromJson(json['category'] as Map<String, dynamic>),
  owner: AssetOwner.fromJson(json['owner'] as Map<String, dynamic>),
  type: json['type'] as String,
  description: json['description'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  monthsCount: (json['months_count'] as num?)?.toInt(),
  yearsCount: (json['years_count'] as num?)?.toInt(),
  daysCount: (json['days_count'] as num?)?.toInt(),
  rentType: json['rent_type'] as String?,
  rentPrice: json['rent_price'] as num?,
  dayPrice: AssetItem._nullableDoubleFromJson(json['day_price']),
  video: json['video'] as String?,
  latitude: AssetItem._nullableDoubleFromJson(json['latitude']),
  longitude: AssetItem._nullableDoubleFromJson(json['longitude']),
  countryId: (json['country_id'] as num?)?.toInt(),
  cityId: (json['city_id'] as num?)?.toInt(),
  regionId: (json['region_id'] as num?)?.toInt(),
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
  'country': instance.country,
  'city': instance.city,
  'region': instance.region,
  'price': instance.price,
  'category': instance.category,
  'owner': instance.owner,
  'type': instance.type,
  'description': instance.description,
  'phone': instance.phone,
  'email': instance.email,
  'months_count': instance.monthsCount,
  'years_count': instance.yearsCount,
  'days_count': instance.daysCount,
  'rent_type': instance.rentType,
  'rent_price': instance.rentPrice,
  'day_price': instance.dayPrice,
  'video': instance.video,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'country_id': instance.countryId,
  'city_id': instance.cityId,
  'region_id': instance.regionId,
  'attributes': instance.attributes,
  'amenities': instance.amenities,
};
