import 'package:dar_plus_app/core/network/api_constants.dart';
import 'package:dar_plus_app/features/packages/data/models/localized_name.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment_asset_summary.g.dart';

@JsonSerializable()
class AppointmentAssetSummary {
  final int id;
  @JsonKey(fromJson: _localizedNameFromJson)
  final LocalizedName? name;
  final String image;
  final String location;
  final String price;
  final String type;
  @JsonKey(name: 'rent_type')
  final String? rentType;

  const AppointmentAssetSummary({
    required this.id,
    this.name,
    required this.image,
    required this.location,
    required this.price,
    required this.type,
    this.rentType,
  });

  String displayName(String lang) => name?.forLang(lang) ?? '';

  String get resolvedImageUrl {
    final trimmed = image.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final normalized =
        trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    if (normalized.startsWith('public/')) {
      return '${ApiConstants.baseUrl}$normalized';
    }
    return '${ApiConstants.baseUrl}public/storage/$normalized';
  }

  factory AppointmentAssetSummary.fromJson(Map<String, dynamic> json) =>
      _$AppointmentAssetSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentAssetSummaryToJson(this);

  static LocalizedName? _localizedNameFromJson(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return LocalizedName(en: value, ar: value);
    }
    if (value is Map) {
      return LocalizedName.fromJson(Map<String, dynamic>.from(value));
    }
    return null;
  }
}
