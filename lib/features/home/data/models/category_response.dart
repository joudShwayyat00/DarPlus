import 'package:json_annotation/json_annotation.dart';
import 'category_item.dart';

part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponse {
  final List<CategoryItem> result;
  final List<dynamic> errors;
  final String message;

  CategoryResponse({
    required this.result,
    required this.errors,
    required this.message,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}
