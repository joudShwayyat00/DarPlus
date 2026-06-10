import 'package:json_annotation/json_annotation.dart';

import 'about_us_item.dart';

part 'about_us_response.g.dart';

@JsonSerializable()
class AboutUsResponse {
  final AboutUsItem data;

  const AboutUsResponse({required this.data});

  factory AboutUsResponse.fromJson(Map<String, dynamic> json) =>
      _$AboutUsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AboutUsResponseToJson(this);
}
