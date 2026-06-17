import 'package:json_annotation/json_annotation.dart';

part 'update_device_token_response.g.dart';

@JsonSerializable()
class UpdateDeviceTokenResponse {
  final String message;

  const UpdateDeviceTokenResponse({required this.message});

  factory UpdateDeviceTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateDeviceTokenResponseFromJson(json);
}
