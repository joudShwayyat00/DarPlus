// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_asset_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentAssetSummary _$AppointmentAssetSummaryFromJson(
  Map<String, dynamic> json,
) => AppointmentAssetSummary(
  id: (json['id'] as num).toInt(),
  name: AppointmentAssetSummary._localizedNameFromJson(json['name']),
  image: json['image'] as String,
  location: json['location'] as String,
  price: json['price'] as String,
  type: json['type'] as String,
  rentType: json['rent_type'] as String?,
);

Map<String, dynamic> _$AppointmentAssetSummaryToJson(
  AppointmentAssetSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image': instance.image,
  'location': instance.location,
  'price': instance.price,
  'type': instance.type,
  'rent_type': instance.rentType,
};
