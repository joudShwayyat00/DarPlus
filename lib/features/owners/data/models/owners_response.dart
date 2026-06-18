import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:json_annotation/json_annotation.dart';

part 'owners_response.g.dart';

@JsonSerializable()
class OwnersResponse {
  final List<AssetOwner> data;

  const OwnersResponse({required this.data});

  factory OwnersResponse.fromJson(Map<String, dynamic> json) =>
      _$OwnersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OwnersResponseToJson(this);
}
