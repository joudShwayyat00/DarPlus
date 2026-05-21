// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetOwner _$AssetOwnerFromJson(Map<String, dynamic> json) => AssetOwner(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  phoneNumber: json['phone_number'] as String,
  image: json['image'] as String?,
  status: json['status'] as String,
  role: json['role'] as String,
  rating: (json['rating'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AssetOwnerToJson(AssetOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'image': instance.image,
      'status': instance.status,
      'role': instance.role,
      'rating': instance.rating,
    };
