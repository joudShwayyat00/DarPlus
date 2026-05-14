import 'package:json_annotation/json_annotation.dart';

part 'slider_item.g.dart';

@JsonSerializable()
class SliderItem {
  final int id;
  final String title;
  final String image;

  SliderItem({required this.id, required this.title, required this.image});

  factory SliderItem.fromJson(Map<String, dynamic> json) =>
      _$SliderItemFromJson(json);

  Map<String, dynamic> toJson() => _$SliderItemToJson(this);
}
