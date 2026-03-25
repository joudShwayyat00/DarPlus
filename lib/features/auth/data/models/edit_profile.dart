import 'package:json_annotation/json_annotation.dart';

part 'edit_profile.g.dart';

@JsonSerializable()
class EditProfileRequest {
  final String name;
  final String email;

  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  EditProfileRequest({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory EditProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$EditProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EditProfileRequestToJson(this);
}
