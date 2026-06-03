import 'package:json_annotation/json_annotation.dart';

import 'asset_item.dart';

part 'paged_assets_response.g.dart';

@JsonSerializable()
class PagedAssetsResponse {
  @JsonKey(name: 'data')
  final List<AssetItem> items;
  final PagedMeta meta;

  PagedAssetsResponse({required this.items, required this.meta});

  factory PagedAssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$PagedAssetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PagedAssetsResponseToJson(this);
}

@JsonSerializable()
class PagedMeta {
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'last_page')
  final int lastPage;
  final int total;
  @JsonKey(name: 'per_page')
  final int perPage;

  PagedMeta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  bool get hasNextPage => currentPage < lastPage;

  factory PagedMeta.fromJson(Map<String, dynamic> json) =>
      _$PagedMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PagedMetaToJson(this);
}
