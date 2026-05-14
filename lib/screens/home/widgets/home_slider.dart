import 'package:carousel_slider/carousel_slider.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_net_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import '../../../features/home/presentation/providers/home_providers.dart';

class HomeSlider extends ConsumerStatefulWidget {
  const HomeSlider({super.key});

  @override
  ConsumerState<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends ConsumerState<HomeSlider> {
  int _currentIndex = 0;

  final CarouselOptions _carouselOptions = CarouselOptions(
    height: 24.h,
    autoPlay: true,
    autoPlayInterval: Duration(seconds: 4),
    enlargeCenterPage: true,
    viewportFraction: 0.82,
  );

  @override
  Widget build(BuildContext context) {
    final slidersAsync = ref.watch(homeSliderControllerProvider);

    return Column(
      children: [
        slidersAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return SizedBox(height: 24.h, child: Center());
            }

            return Column(
              children: [
                CarouselSlider(
                  options: _carouselOptions.copyWith(
                    onPageChanged: (index, _) {
                      setState(() => _currentIndex = index);
                    },
                  ),
                  items: items.map((item) {
                    return _SliderItem(imageUrl: item.image);
                  }).toList(),
                ),
                SizedBox(height: 1.2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    items.length,
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
          },
          loading: () => Column(
            children: [
              SizedBox(
                height: 24.h,
                child: Center(child: CircularProgressIndicator()),
              ),
              SizedBox(height: 1.2.h),
            ],
          ),
          error: (_, __) => SizedBox(height: 24.h, child: Center()),
        ),
      ],
    );
  }
}

/// Slide Item
class _SliderItem extends StatelessWidget {
  final String imageUrl;

  const _SliderItem({required this.imageUrl});

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
                colors: [Colors.black.withAlpha(120), Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
