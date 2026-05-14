// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SliderItem _$SliderItemFromJson(Map<String, dynamic> json) => SliderItem(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  image: json['image'] as String,
);

Map<String, dynamic> _$SliderItemToJson(SliderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
    };
