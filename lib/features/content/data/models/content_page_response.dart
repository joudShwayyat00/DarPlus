import 'package:json_annotation/json_annotation.dart';
import 'content_page_item.dart';

part 'content_page_response.g.dart';

@JsonSerializable()
class ContentPageResponse {
  final List<ContentPageItem> result;

  const ContentPageResponse({required this.result});

  factory ContentPageResponse.fromJson(Map<String, dynamic> json) =>
      _$ContentPageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContentPageResponseToJson(this);
}
