// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_subscriptions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MySubscriptionsResponse _$MySubscriptionsResponseFromJson(
  Map<String, dynamic> json,
) => MySubscriptionsResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => MySubscriptionItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MySubscriptionsResponseToJson(
  MySubscriptionsResponse instance,
) => <String, dynamic>{'data': instance.data};
