// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditProfileRequest _$EditProfileRequestFromJson(Map<String, dynamic> json) =>
    EditProfileRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
    );

Map<String, dynamic> _$EditProfileRequestToJson(EditProfileRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
    };
