import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:json_annotation/json_annotation.dart';

part 'owner_detail.g.dart';

@JsonSerializable(createToJson: false)
class OwnerDetailResponse {
  @JsonKey(fromJson: _ownerDetailFromJson)
  final OwnerDetail data;

  const OwnerDetailResponse({required this.data});

  factory OwnerDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$OwnerDetailResponseFromJson(json);
}

OwnerDetail _ownerDetailFromJson(Map<String, dynamic> json) =>
    OwnerDetail.fromJson(json);

class OwnerDetail {
  final AssetOwner profile;
  final List<AssetItem> assets;

  const OwnerDetail({required this.profile, required this.assets});

  factory OwnerDetail.fromJson(Map<String, dynamic> json) {
    return OwnerDetail(
      profile: AssetOwner.fromJson(json),
      assets: (json['assets'] as List<dynamic>?)
              ?.map((e) => AssetItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
