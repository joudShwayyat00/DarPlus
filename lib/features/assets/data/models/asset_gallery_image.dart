import 'package:json_annotation/json_annotation.dart';

part 'asset_gallery_image.g.dart';

@JsonSerializable()
class AssetGalleryImage {
  final int id;
  @JsonKey(name: 'asset_id')
  final int? assetId;
  final String image;

  const AssetGalleryImage({
    required this.id,
    this.assetId,
    required this.image,
  });

  factory AssetGalleryImage.fromJson(Map<String, dynamic> json) =>
      _$AssetGalleryImageFromJson(json);

  Map<String, dynamic> toJson() => _$AssetGalleryImageToJson(this);
}
