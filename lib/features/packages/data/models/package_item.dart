import 'package:json_annotation/json_annotation.dart';

import 'localized_name.dart';

part 'package_item.g.dart';

@JsonSerializable()
class PackageItem {
  final int id;
  final LocalizedName name;
  final String price;
  @JsonKey(name: 'duration_days')
  final int durationDays;
  @JsonKey(name: 'sale_assets_limit')
  final int saleAssetsLimit;
  @JsonKey(name: 'rent_assets_limit')
  final int rentAssetsLimit;

  const PackageItem({
    required this.id,
    required this.name,
    required this.price,
    required this.durationDays,
    required this.saleAssetsLimit,
    required this.rentAssetsLimit,
  });

  factory PackageItem.fromJson(Map<String, dynamic> json) =>
      _$PackageItemFromJson(json);
}
