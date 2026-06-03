// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_assets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedAssetsResponse _$PagedAssetsResponseFromJson(Map<String, dynamic> json) =>
    PagedAssetsResponse(
      items: (json['data'] as List<dynamic>)
          .map((e) => AssetItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PagedMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PagedAssetsResponseToJson(
  PagedAssetsResponse instance,
) => <String, dynamic>{'data': instance.items, 'meta': instance.meta};

PagedMeta _$PagedMetaFromJson(Map<String, dynamic> json) => PagedMeta(
  currentPage: (json['current_page'] as num).toInt(),
  lastPage: (json['last_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
);

Map<String, dynamic> _$PagedMetaToJson(PagedMeta instance) => <String, dynamic>{
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'total': instance.total,
  'per_page': instance.perPage,
};
