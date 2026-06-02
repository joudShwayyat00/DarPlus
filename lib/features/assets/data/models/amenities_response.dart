import 'package:json_annotation/json_annotation.dart';
import 'amenity_item.dart';

part 'amenities_response.g.dart';

@JsonSerializable()
class AmenitiesResponse {
  final List<AmenityItem> result;
  final List<dynamic> errors;
  final String message;

  const AmenitiesResponse({
    required this.result,
    required this.errors,
    required this.message,
  });

  factory AmenitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$AmenitiesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AmenitiesResponseToJson(this);
}
