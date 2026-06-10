// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_us_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutUsItem _$AboutUsItemFromJson(Map<String, dynamic> json) => AboutUsItem(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  image: json['image'] as String,
);

Map<String, dynamic> _$AboutUsItemToJson(AboutUsItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
    };
