import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/models/property_item.dart';
import 'package:dar_plus_app/screens/home/widgets/category_card.dart';
import 'package:dar_plus_app/screens/home/widgets/home_slider.dart';
import 'package:dar_plus_app/screens/home/widgets/owner_card.dart';
import 'package:dar_plus_app/screens/home/widgets/property_tile.dart';
import 'package:dar_plus_app/screens/home/widgets/section_header.dart';
import 'package:dar_plus_app/screens/property_details/property_details_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum _ListingType { buy, rent, both }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentRecommendedIndex = 0;
  int _selectedCategoryIndex = 0;
  late _ListingType _listingType;

  final PageController _recommendedController = PageController(
    viewportFraction: 0.92,
  );

  @override
  void initState() {
    super.initState();
    _listingType = _ListingType.both;
  }

  static const List<_CategoryItem> _categories = [
    _CategoryItem(
      title: "Hotel Apartments",
      imageUrl:
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400",
    ),
    _CategoryItem(
      title: "Family Apartments",
      imageUrl:
          "https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=400",
    ),
    _CategoryItem(
      title: "Chalets",
      imageUrl:
          "https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=400",
    ),
    _CategoryItem(
      title: "Farms",
      imageUrl:
          "https://images.unsplash.com/photo-1599423300746-b62533397364?w=400",
    ),
  ];

  static const List<_OwnerItem> _topOwners = [
    _OwnerItem(
      name: "Ahmad Al-Mansouri",
      imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
      rating: 4.9,
      reviewCount: 128,
      specialty: "Luxury Villas",
    ),
    _OwnerItem(
      name: "Sara Al-Khatib",
      imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
      rating: 4.8,
      reviewCount: 97,
      specialty: "Family Chalets",
    ),
    _OwnerItem(
      name: "Omar Nasser",
      imageUrl: "https://randomuser.me/api/portraits/men/65.jpg",
      rating: 4.7,
      reviewCount: 84,
      specialty: "Sea View Apartments",
    ),
    _OwnerItem(
      name: "Lina Haddad",
      imageUrl: "https://randomuser.me/api/portraits/women/21.jpg",
      rating: 4.7,
      reviewCount: 72,
      specialty: "Hotel Apartments",
    ),
    _OwnerItem(
      name: "Khalid Barakat",
      imageUrl: "https://randomuser.me/api/portraits/men/78.jpg",
      rating: 4.6,
      reviewCount: 61,
      specialty: "Farms & Resorts",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),
              const HomeSlider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── What are you interested in? ──────────────────
                    SectionHeader(
                      title: tr.what_are_you_interested_in,
                      seeAll: false,
                    ),
                    SizedBox(height: 1.5.h),
                    Row(
                      children: [
                        CategoryBox(
                          title: tr.buy,
                          isSelected: _listingType == _ListingType.buy,
                          onTap: () =>
                              setState(() => _listingType = _ListingType.buy),
                        ),
                        SizedBox(width: 2.5.w),
                        CategoryBox(
                          title: tr.rent,
                          isSelected: _listingType == _ListingType.rent,
                          onTap: () =>
                              setState(() => _listingType = _ListingType.rent),
                        ),
                        SizedBox(width: 2.5.w),
                        CategoryBox(
                          title: tr.both,
                          isSelected: _listingType == _ListingType.both,
                          onTap: () =>
                              setState(() => _listingType = _ListingType.both),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.5.h),
                    // ── Categories ──────────────────────────────────────
                    SectionHeader(title: tr.browse_by_category, seeAll: false),
                    SizedBox(height: 1.5.h),
                    SizedBox(
                      height: 13.5.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => SizedBox(width: 2.5.w),
                        itemBuilder: (context, index) {
                          final localizedTitle = index == 0
                              ? tr.hotel_apartments
                              : index == 1
                              ? tr.family_apartments
                              : index == 2
                              ? tr.chalets
                              : tr.farms;
                          return CategoryImageCard(
                            title: localizedTitle,
                            imageUrl: _categories[index].imageUrl,
                            isSelected: _selectedCategoryIndex == index,
                            onTap: () =>
                                setState(() => _selectedCategoryIndex = index),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 2.5.h),

                    // ── Top Rated Properties ────────────────────────────
                    SectionHeader(title: tr.top_rated, onSeeAll: () {}),
                    SizedBox(
                      height: 43.h,
                      child: GestureDetector(
                        onTap: () {
                          final selected =
                              recommendedProperties[_currentRecommendedIndex];
                          AppNavigator.of(
                            context,
                          ).push(PropertyDetailsScreen(item: selected));
                        },
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollUpdateNotification) {
                              final page = _recommendedController.page ?? 0;
                              final newIndex = page.round();
                              if (newIndex != _currentRecommendedIndex) {
                                setState(
                                  () => _currentRecommendedIndex = newIndex,
                                );
                              }
                            }
                            return false;
                          },
                          child: PageView.builder(
                            controller: _recommendedController,
                            itemCount: recommendedProperties.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      index == recommendedProperties.length - 1
                                      ? 0
                                      : 3.w,
                                ),
                                child: PropertyTile(
                                  item: recommendedProperties[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        recommendedProperties.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentRecommendedIndex == index ? 18 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: _currentRecommendedIndex == index
                                ? AppColors.goldBrandColor
                                : AppColors.grayBrandColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 2.5.h),

                    // ── Top Rated Owners ────────────────────────────────
                    SectionHeader(title: tr.top_rated_owners, onSeeAll: () {}),
                    SizedBox(height: 1.5.h),
                    SizedBox(
                      height: 24.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: _topOwners.length,
                        separatorBuilder: (_, __) => SizedBox(width: 3.w),
                        itemBuilder: (context, index) {
                          final o = _topOwners[index];
                          return OwnerCard(
                            name: o.name,
                            imageUrl: o.imageUrl,
                            rating: o.rating,
                            reviewCount: o.reviewCount,
                            specialty: o.specialty,
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Data Models ─────────────────────────────────────────────────────────────

class _CategoryItem {
  final String title;
  final String imageUrl;

  const _CategoryItem({required this.title, required this.imageUrl});
}

class _OwnerItem {
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String specialty;

  const _OwnerItem({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.specialty,
  });
}
