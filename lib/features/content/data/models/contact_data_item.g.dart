// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_data_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactDataItem _$ContactDataItemFromJson(Map<String, dynamic> json) =>
    ContactDataItem(
      id: (json['id'] as num).toInt(),
      appName: json['app_name'] as String?,
      commissionRate: json['comission_rate'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      facebook: json['facebook'] as String?,
      instagram: json['instagram'] as String?,
      youtube: json['youtube'] as String?,
      x: json['x'] as String?,
    );

Map<String, dynamic> _$ContactDataItemToJson(ContactDataItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'app_name': instance.appName,
      'comission_rate': instance.commissionRate,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'youtube': instance.youtube,
      'x': instance.x,
    };
