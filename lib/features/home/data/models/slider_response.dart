import 'package:json_annotation/json_annotation.dart';
import 'slider_item.dart';

part 'slider_response.g.dart';

@JsonSerializable()
class SliderResponse {
  final List<SliderItem> result;
  final List<dynamic> errors;
  final String message;

  SliderResponse({
    required this.result,
    required this.errors,
    required this.message,
  });

  factory SliderResponse.fromJson(Map<String, dynamic> json) =>
      _$SliderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SliderResponseToJson(this);
}
