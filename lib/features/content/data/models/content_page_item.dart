import 'package:json_annotation/json_annotation.dart';

part 'content_page_item.g.dart';

@JsonSerializable()
class ContentPageItem {
  final String title;
  final String description;

  const ContentPageItem({required this.title, required this.description});

  factory ContentPageItem.fromJson(Map<String, dynamic> json) =>
      _$ContentPageItemFromJson(json);

  Map<String, dynamic> toJson() => _$ContentPageItemToJson(this);
}
