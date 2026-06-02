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
    required this.price,
    required this.category,
    required this.owner,
    required this.type,
    this.description,
    this.phone,
    this.email,
    this.monthsCount,
    this.rentType,
    this.rentPrice,
    this.attributes,
    this.amenities,
  });

  bool get isForSale => type == 'sale';

  /// Owner rating, defaults to 0.0 if not available.
  double get rating => owner.rating ?? 0.0;

  factory AssetItem.fromJson(Map<String, dynamic> json) =>
      _$AssetItemFromJson(json);

  Map<String, dynamic> toJson() => _$AssetItemToJson(this);

  /// Converts to [PropertyItem] for compatibility with existing detail screens.
  PropertyItem toPropertyItem() => PropertyItem(
    title: name,
    location: location,
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
  );
}
