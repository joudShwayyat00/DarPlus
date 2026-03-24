import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  final UserModel user;

  ProfileResponse({
    required this.user,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}
