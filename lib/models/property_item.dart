enum ListingType { rent, sale }

class PropertyItem {
  final String title;
  final String location;
  final String price;
  final double rating;
  final List<String> images;
  final String description;

  final int guests;
  final int bedrooms;
  final int bathrooms;
  final double size;

  final bool hasPool;
  final bool hasBbq;
  final bool hasWifi;
  final ListingType listingType;

  // ✅ معلومات التواصل
  final String? phone;
  final String? email;

  // Rent details
  final String? rentType; // 'daily', 'monthly', 'yearly'
  final num? rentPrice;

  // ✅ روابط السوشيال / الفيديو
  final String? youtubeUrl;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? snapchatUrl;
  final String? tiktokUrl;

  const PropertyItem({
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.images,
    required this.description,
    required this.guests,
    required this.bedrooms,
    required this.bathrooms,
    required this.size,
    required this.hasPool,
    required this.hasBbq,
    required this.hasWifi,
    this.listingType = ListingType.rent,

    // optional
    this.phone,
    this.email,
    this.rentType,
    this.rentPrice,
    this.youtubeUrl,
    this.facebookUrl,
    this.instagramUrl,
    this.snapchatUrl,
    this.tiktokUrl,
  });
}

final List<PropertyItem> recommendedProperties = [
  PropertyItem(
    title: "Sea View Chalet",
    location: "Dead Sea",
    price: "120",
    rating: 4.8,
    images: [
      "https://eu2.contabostorage.com/e4d9c3eca4674c9dbce474abbb48ddea:files/avatar/images/7iZoVcVpWCBG2nGDZ478xVBu7HHPraaH47cS7f8a.jpg",
      "https://i.imgur.com/De8nmSC.jpg",
      "https://i.imgur.com/vJ8pnZp.jpg",
      "https://i.imgur.com/9R6A7eg.jpg",
      "https://i.imgur.com/SPQo5RO.jpg",
      "https://i.imgur.com/U9qdhq2.jpg",
    ],
    description:
        "Luxury sea view chalet located at the Dead Sea. Perfect for families and couples looking for relaxation, featuring a private pool and stunning sunset views.",
    guests: 6,
    bedrooms: 2,
    bathrooms: 2,
    size: 140,
    hasPool: true,
    hasBbq: true,
    hasWifi: true,
    listingType: ListingType.rent,

    phone: "+962 79 123 4567",
    email: "info@seaviewchalet.com",
    youtubeUrl: "https://www.youtube.com/watch?v=abcd1234",
    facebookUrl: "https://www.facebook.com/seaviewchalet",
    instagramUrl: "https://www.instagram.com/seaviewchalet",
    snapchatUrl: "https://www.snapchat.com/add/seaviewchalet",
    tiktokUrl: "https://www.tiktok.com/@seaviewchalet",
  ),

  PropertyItem(
    title: "Cozy Nature Chalet",
    location: "Jerash",
    price: "70",
    rating: 4.2,
    images: [
      "https://md4000.com/wp-content/uploads/1497_8_B-768x432.jpg",
      "https://md4000.com/wp-content/uploads/1497_2_B-768x432.jpg",
    ],
    description:
        "A peaceful chalet surrounded by nature and forests. Ideal for weekend getaways, fresh air lovers, and small families.",
    guests: 4,
    bedrooms: 1,
    bathrooms: 1,
    size: 90,
    hasPool: false,
    hasBbq: true,
    hasWifi: true,
    listingType: ListingType.sale,

    phone: "+962 78 555 8899",
    email: "contact@cozynaturejo.com",
    facebookUrl: "https://www.facebook.com/cozynaturechalet",
    instagramUrl: "https://www.instagram.com/cozynaturechalet",
    snapchatUrl: "https://www.snapchat.com/add/cozynature",
  ),

  PropertyItem(
    title: "Family Chalet with Pool",
    location: "Aqaba",
    price: "150",
    rating: 4.9,
    images: ["https://images.unsplash.com/photo-1512917774080-9991f1c4c750"],
    description:
        "Spacious family chalet in Aqaba with a private pool and garden. Close to the beach and perfect for large families and gatherings.",
    guests: 8,
    bedrooms: 3,
    bathrooms: 3,
    size: 180,
    hasPool: true,
    hasBbq: true,
    hasWifi: true,
    listingType: ListingType.rent,

    phone: "+962 77 888 2222",
    email: "booking@familychaletaqaba.com",
    youtubeUrl: "https://www.youtube.com/watch?v=family987",
    facebookUrl: "https://www.facebook.com/familychaletaqaba",
    tiktokUrl: "https://www.tiktok.com/@familychaletaqaba",
  ),
];
