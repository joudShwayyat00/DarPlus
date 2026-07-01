import 'package:json_annotation/json_annotation.dart';

part 'subscribe_response.g.dart';

@JsonSerializable()
class SubscribeResponse {
  final String message;

  SubscribeResponse({required this.message});

  factory SubscribeResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscribeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeResponseToJson(this);
}
