import 'package:json_annotation/json_annotation.dart';
import 'slider_item.dart';

part 'slider_response.g.dart';

@JsonSerializable()
class SliderResponse {
  final List<SliderItem> result;

  SliderResponse({required this.result});

  factory SliderResponse.fromJson(Map<String, dynamic> json) =>
      _$SliderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SliderResponseToJson(this);
}
