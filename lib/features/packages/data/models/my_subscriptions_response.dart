import 'package:json_annotation/json_annotation.dart';

import 'my_subscription_item.dart';

part 'my_subscriptions_response.g.dart';

@JsonSerializable()
class MySubscriptionsResponse {
  final List<MySubscriptionItem> data;

  const MySubscriptionsResponse({required this.data});

  factory MySubscriptionsResponse.fromJson(Map<String, dynamic> json) =>
      _$MySubscriptionsResponseFromJson(json);
}
