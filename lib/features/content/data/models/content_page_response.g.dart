// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_page_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentPageResponse _$ContentPageResponseFromJson(Map<String, dynamic> json) =>
    ContentPageResponse(
      result: (json['result'] as List<dynamic>)
          .map((e) => ContentPageItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContentPageResponseToJson(
  ContentPageResponse instance,
) => <String, dynamic>{'result': instance.result};
