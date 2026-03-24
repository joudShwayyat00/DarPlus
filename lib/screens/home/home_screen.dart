import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/models/property_item.dart';
import 'package:dar_plus_app/screens/home/widgets/category_card.dart';
import 'package:dar_plus_app/screens/home/widgets/home_slider.dart';
import 'package:dar_plus_app/screens/home/widgets/property_tile.dart';
import 'package:dar_plus_app/screens/home/widgets/section_header.dart';
import 'package:dar_plus_app/screens/property_details/property_details_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentRecommendedIndex = 0;

  final PageController _recommendedController = PageController(
    viewportFraction: 0.92,
  );
  final List<_CategoryItem> _categories = [
    _CategoryItem(
      title: "Hotel Apartments",
      imageUrl: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
    ),
    _CategoryItem(
      title: "Family Apartments",
      imageUrl: "https://images.unsplash.com/photo-1570129477492-45c003edd2be",
    ),
    _CategoryItem(
      title: "Chalets",
      imageUrl: "https://images.unsplash.com/photo-1505691938895-1758d7feb511",
    ),
    _CategoryItem(
      title: "Farms",
      imageUrl: "https://images.unsplash.com/photo-1599423300746-b62533397364",
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
                    SectionHeader(
                      title: tr.browse_by_category,

                      //  "Browse by Category",
                      seeAll: false,
                    ),
                    SizedBox(height: 1.5.h),
                    SizedBox(
                      height: 6.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => SizedBox(width: 2.w),
                        itemBuilder: (context, index) {
                          final localizedTitle = index == 0
                              ? tr.hotel_apartments
                              : index == 1
                              ? tr.family_apartments
                              : index == 2
                              ? tr.chalets
                              : tr.farms;
                          return CategoryBox(
                            title: localizedTitle,
                            onTap: () {
                              // TODO: Filter by category
                            },
                          );
                        },
                      ),
                    ),
                    SectionHeader(
                      title: tr.top_rated,
                      // "Top Rated",
                      onSeeAll: () {},
                    ),
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

class _CategoryItem {
  final String title;
  final String imageUrl;

  const _CategoryItem({required this.title, required this.imageUrl});
}
