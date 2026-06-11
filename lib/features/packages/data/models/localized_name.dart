import 'package:json_annotation/json_annotation.dart';

part 'localized_name.g.dart';

@JsonSerializable()
class LocalizedName {
  final String ar;
  final String en;

  const LocalizedName({required this.ar, required this.en});

  factory LocalizedName.fromJson(Map<String, dynamic> json) =>
      _$LocalizedNameFromJson(json);

  String forLang(String lang) => lang == 'ar' ? ar : en;
}
