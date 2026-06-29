// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_gallery_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetGalleryImage _$AssetGalleryImageFromJson(Map<String, dynamic> json) =>
    AssetGalleryImage(
      id: (json['id'] as num).toInt(),
      assetId: (json['asset_id'] as num?)?.toInt(),
      image: json['image'] as String,
    );

Map<String, dynamic> _$AssetGalleryImageToJson(AssetGalleryImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'asset_id': instance.assetId,
      'image': instance.image,
    };
