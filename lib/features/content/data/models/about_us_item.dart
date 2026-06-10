import 'package:json_annotation/json_annotation.dart';

part 'about_us_item.g.dart';

@JsonSerializable()
class AboutUsItem {
  final int id;
  final String title;
  final String description;
  final String image;

  const AboutUsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  factory AboutUsItem.fromJson(Map<String, dynamic> json) =>
      _$AboutUsItemFromJson(json);

  Map<String, dynamic> toJson() => _$AboutUsItemToJson(this);
}
