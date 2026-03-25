import 'package:json_annotation/json_annotation.dart';

part 'update_password_response.g.dart';

@JsonSerializable()
class UpdatePasswordResponse {
  final String message;

  UpdatePasswordResponse({required this.message});

  factory UpdatePasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdatePasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePasswordResponseToJson(this);
}
