import 'package:dar_plus_app/features/home/data/models/category_item.dart';
import 'package:dar_plus_app/models/property_item.dart';
import 'package:json_annotation/json_annotation.dart';

import 'asset_amenity.dart';
import 'asset_attribute.dart';
import 'asset_owner.dart';

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
  final List<AssetAttribute>? attributes;
  final List<AssetAmenity>? amenities;

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
    this.attributes,
    this.amenities,
  });

  bool get isForSale => type == 'sale';

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
    title: name,
    location: location,
    country: country,
    city: city,
    region: region,
    price: price,
    rating: rating,
    images: [image],
    description: description ?? '',
    guests: 0,
    bedrooms: 0,
    bathrooms: 0,
    size: 0,
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
