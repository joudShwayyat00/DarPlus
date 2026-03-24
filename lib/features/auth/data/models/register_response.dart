import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  final UserModel user;
  @JsonKey(name: 'access_token')
  final String accessToken;

  RegisterResponse({
    required this.user,
    required this.accessToken,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}
