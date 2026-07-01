import 'package:json_annotation/json_annotation.dart';

part 'subscribe_response.g.dart';

@JsonSerializable()
class SubscribeResponse {
  final bool? status;
  final String message;
  @JsonKey(name: 'subscription_id')
  final int? subscriptionId;

  SubscribeResponse({
    this.status,
    required this.message,
    this.subscriptionId,
  });

  factory SubscribeResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscribeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeResponseToJson(this);
}
