import 'package:json_annotation/json_annotation.dart';

import 'contact_data_item.dart';

part 'contact_data_response.g.dart';

@JsonSerializable()
class ContactDataResponse {
  final ContactDataItem data;

  const ContactDataResponse({required this.data});

  factory ContactDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactDataResponseFromJson(json);
}
