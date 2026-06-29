import 'package:dar_plus_app/features/home/data/models/category_item.dart';
import 'package:dar_plus_app/models/property_item.dart';
import 'package:json_annotation/json_annotation.dart';

import 'asset_amenity.dart';
import 'asset_attribute.dart';
import 'asset_gallery_image.dart';
import 'asset_owner.dart';
import '../../../../utils/helpers/asset_time_helper.dart';

part 'asset_item.g.dart';

@JsonSerializable()
class AssetItem {
  final int id;
  final String name;
  final String image;
  final String location;
  final String? country;
  final String? city;
  final String? region;
  @JsonKey(fromJson: _priceFromJson)
  final String price;
  final CategoryItem category;
  final AssetOwner owner;
  // "sale" or "rent"
  final String type;

  // Fields returned by the top-rated and detail endpoints (nullable on list endpoint)
  final String? description;
  final String? phone;
  final String? email;
  @JsonKey(name: 'months_count')
  final int? monthsCount;
  @JsonKey(name: 'years_count')
  final int? yearsCount;
  @JsonKey(name: 'days_count')
  final int? daysCount;
  @JsonKey(name: 'rent_type')
  final String? rentType;
  @JsonKey(name: 'rent_price')
  final num? rentPrice;
  @JsonKey(name: 'day_price', fromJson: _nullableDoubleFromJson)
  final double? dayPrice;
  @JsonKey(name: 'check_in_time')
  final String? checkInTime;
  @JsonKey(name: 'check_out_time')
  final String? checkOutTime;
  final String? video;
  @JsonKey(fromJson: _nullableDoubleFromJson)
  final double? latitude;
  @JsonKey(fromJson: _nullableDoubleFromJson)
  final double? longitude;
  @JsonKey(name: 'country_id')
  final int? countryId;
  @JsonKey(name: 'city_id')
  final int? cityId;
  @JsonKey(name: 'region_id')
  final int? regionId;
  final List<AssetAttribute>? attributes;
  final List<AssetAmenity>? amenities;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? space;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? rooms;
  @JsonKey(fromJson: _imagesFromJson)
  final List<AssetGalleryImage>? images;
  @JsonKey(name: 'is_available', fromJson: _boolFromJson)
  final bool? isAvailable;

  static String _priceFromJson(dynamic value) {
    if (value is String) return value;
    if (value is num) return value.toString();
    return value?.toString() ?? '';
  }

  static bool? _boolFromJson(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == '1' || normalized == 'true') return true;
      if (normalized == '0' || normalized == 'false') return false;
    }
    return null;
  }

  static List<AssetGalleryImage>? _imagesFromJson(dynamic value) {
    if (value == null) return null;
    if (value is! List) return null;

    final images = <AssetGalleryImage>[];
    for (var i = 0; i < value.length; i++) {
      final item = value[i];
      if (item is String) {
        images.add(AssetGalleryImage(id: i, image: item));
      } else if (item is Map<String, dynamic>) {
        images.add(AssetGalleryImage.fromJson(item));
      } else if (item is Map) {
        images.add(AssetGalleryImage.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return images.isEmpty ? null : images;
  }

  static int? _nullableIntFromJson(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.round();
    if (value is String) {
      final asDouble = double.tryParse(value);
      if (asDouble != null) return asDouble.round();
      return int.tryParse(value);
    }
    return null;
  }

  static double? _nullableDoubleFromJson(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  const AssetItem({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    this.country,
    this.city,
    this.region,
    required this.price,
    required this.category,
    required this.owner,
    required this.type,
    this.description,
    this.phone,
    this.email,
    this.monthsCount,
    this.yearsCount,
    this.daysCount,
    this.rentType,
    this.rentPrice,
    this.dayPrice,
    this.checkInTime,
    this.checkOutTime,
    this.video,
    this.latitude,
    this.longitude,
    this.countryId,
    this.cityId,
    this.regionId,
    this.attributes,
    this.amenities,
    this.space,
    this.rooms,
    this.images,
    this.isAvailable,
  });

  bool get isForSale => type == 'sale';

  bool get isUnavailable => isAvailable == false;

  List<String> get galleryImageUrls {
    final urls = <String>[];
    void addUrl(String? url) {
      final trimmed = url?.trim();
      if (trimmed == null || trimmed.isEmpty || urls.contains(trimmed)) return;
      urls.add(trimmed);
    }

    addUrl(image);
    for (final item in images ?? const <AssetGalleryImage>[]) {
      addUrl(item.image);
    }
    return urls;
  }

  String get displayPrice {
    final parsed = double.tryParse(price);
    if (parsed == null) return price;
    if (parsed == parsed.roundToDouble()) {
      return parsed.round().toString();
    }
    return parsed.toStringAsFixed(2);
  }

  String? get displayCheckInTime => formatAssetTimeForDisplay(checkInTime);

  String? get displayCheckOutTime => formatAssetTimeForDisplay(checkOutTime);

  bool get hasCheckTimes =>
      hasAssetCheckTimes(checkInTime: checkInTime, checkOutTime: checkOutTime);

  /// Owner rating, defaults to 0.0 if not available.
  double get rating => owner.rating ?? 0.0;

  /// Country, city, and region joined for display when available.
  String? get locationAreaLine {
    final parts = [country, city, region]
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    return parts.isEmpty ? null : parts.join(' · ');
  }

  factory AssetItem.fromJson(Map<String, dynamic> json) =>
      _$AssetItemFromJson(json);

  Map<String, dynamic> toJson() => _$AssetItemToJson(this);

  /// Converts to [PropertyItem] for compatibility with existing detail screens.
  PropertyItem toPropertyItem() => PropertyItem(
    assetId: id,
    ownerId: owner.id,
    title: name,
    location: location,
    country: country,
    city: city,
    region: region,
    price: price,
    rating: rating,
    images: [image, ...?images?.map((e) => e.image)],
    description: description ?? '',
    guests: 0,
    bedrooms: rooms ?? 0,
    bathrooms: 0,
    size: (space ?? 0).toDouble(),
    hasPool: false,
    hasBbq: false,
    hasWifi: false,
    listingType: isForSale ? ListingType.sale : ListingType.rent,
    phone: phone ?? owner.phoneNumber,
    email: email ?? owner.email,
    rentType: rentType,
    rentPrice: rentPrice,
    monthsCount: monthsCount,
    yearsCount: yearsCount,
    daysCount: daysCount,
  );
}
