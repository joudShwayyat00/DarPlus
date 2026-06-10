import 'package:json_annotation/json_annotation.dart';
import 'category_item.dart';

part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponse {
  @JsonKey(name: 'data')
  final List<CategoryItem> result;

  CategoryResponse({required this.result});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}
