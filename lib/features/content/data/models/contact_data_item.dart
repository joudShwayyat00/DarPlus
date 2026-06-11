import 'package:json_annotation/json_annotation.dart';

part 'contact_data_item.g.dart';

@JsonSerializable()
class ContactDataItem {
  final int id;
  @JsonKey(name: 'app_name')
  final String? appName;
  @JsonKey(name: 'comission_rate')
  final String? commissionRate;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? facebook;
  final String? instagram;
  final String? youtube;
  final String? x;

  const ContactDataItem({
    required this.id,
    this.appName,
    this.commissionRate,
    this.createdAt,
    this.updatedAt,
    this.phoneNumber,
    this.email,
    this.address,
    this.facebook,
    this.instagram,
    this.youtube,
    this.x,
  });

  factory ContactDataItem.fromJson(Map<String, dynamic> json) =>
      _$ContactDataItemFromJson(json);

  String? get displayPhone => _nonEmpty(phoneNumber);
  String? get displayEmail => _nonEmpty(email);
  String? get displayAddress => _nonEmpty(address);

  String? get instagramUrl => _socialUrl(instagram, 'https://instagram.com/');
  String? get facebookUrl => _socialUrl(facebook, 'https://facebook.com/');
  String? get youtubeUrl => _socialUrl(youtube, 'https://youtube.com/@');
  String? get xUrl => _socialUrl(x, 'https://x.com/');

  bool get hasContactInfo =>
      displayPhone != null || displayEmail != null || displayAddress != null;

  bool get hasSocialLinks =>
      instagramUrl != null ||
      facebookUrl != null ||
      youtubeUrl != null ||
      xUrl != null;

  static String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  static String? _socialUrl(String? value, String baseUrl) {
    final trimmed = _nonEmpty(value);
    if (trimmed == null) return null;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final handle = trimmed.replaceFirst('@', '');
    return '$baseUrl$handle';
  }
}
