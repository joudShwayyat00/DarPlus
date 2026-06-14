// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackagesResponse _$PackagesResponseFromJson(Map<String, dynamic> json) =>
    PackagesResponse(
      items: (json['data'] as List<dynamic>)
          .map((e) => PackageItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PackagesResponseToJson(PackagesResponse instance) =>
    <String, dynamic>{'data': instance.items};
