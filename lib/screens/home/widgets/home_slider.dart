import 'package:carousel_slider/carousel_slider.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_net_image.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/main.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 24.h,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            viewportFraction: 0.82,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          items: List.generate(_slides.length, (index) {
            final slide = _slides[index];
            final title = index == 0 ? tr.luxury_living : index == 1 ? tr.modern_apartments : tr.find_your_space;
            final subtitle = index == 0 ? tr.discover_premium_villas : index == 1 ? tr.comfort_elegance : tr.homes_match_lifestyle;
            return _SliderItem(
              imageUrl: slide.imageUrl,
              title: title,
              subtitle: subtitle,
            );
          }),
        ),

        SizedBox(height: 1.2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _slides.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 18 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppColors.goldBrandColor
                    : AppColors.grayBrandColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Slide Item
class _SliderItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const _SliderItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetImage(url: imageUrl),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withAlpha(170), Colors.transparent],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTextStyle(
                    context,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 0.6.h),
                Text(
                  subtitle,
                  style: appTextStyle(
                    context,
                    fontSize: 10.5.sp,
                    color: Colors.white.withAlpha(210),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Slider Data
class _HomeSlide {
  final String imageUrl;
  final String title;
  final String subtitle;

  const _HomeSlide({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });
}

const List<_HomeSlide> _slides = [
  _HomeSlide(
    imageUrl: "https://images.unsplash.com/photo-1564013799919-ab600027ffc6",
    title: "Luxury Living",
    subtitle: "Discover premium villas & apartments",
  ),
  _HomeSlide(
    imageUrl: "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688",
    title: "Modern Apartments",
    subtitle: "Comfort & elegance in one place",
  ),
  _HomeSlide(
    imageUrl: "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
    title: "Find Your Space",
    subtitle: "Homes that match your lifestyle",
  ),
];
