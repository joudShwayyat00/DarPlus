// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeResponse _$SubscribeResponseFromJson(Map<String, dynamic> json) =>
    SubscribeResponse(
      status: json['status'] as bool?,
      message: json['message'] as String,
      subscriptionId: (json['subscription_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SubscribeResponseToJson(SubscribeResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'subscription_id': instance.subscriptionId,
    };
