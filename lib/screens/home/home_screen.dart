import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/features/owners/presentation/providers/owners_providers.dart';
import 'package:dar_plus_app/screens/assets/assets_screen.dart';
import 'package:dar_plus_app/screens/assets/top_rated_screen.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/home/presentation/providers/home_providers.dart';
import 'package:dar_plus_app/features/packages/presentation/providers/packages_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/asset_details/asset_details_screen.dart';
import 'package:dar_plus_app/screens/home/widgets/category_card.dart';
import 'package:dar_plus_app/screens/home/widgets/home_slider.dart';
import 'package:dar_plus_app/screens/home/widgets/owner_card.dart';
import 'package:dar_plus_app/screens/home/widgets/property_tile.dart';
import 'package:dar_plus_app/screens/home/widgets/section_header.dart';
import 'package:dar_plus_app/screens/home/widgets/subscription_expiry_reminder.dart';
import 'package:dar_plus_app/screens/profile/my_subscriptions_screen.dart';
import 'package:dar_plus_app/screens/profile/subscriptions_screen.dart';
import 'package:dar_plus_app/screens/owners/all_owners_screen.dart';
import 'package:dar_plus_app/screens/owners/owner_profile_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

enum _ListingType { buy, rent, both }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentRecommendedIndex = 0;
  int? _selectedCategoryIndex;
  late _ListingType _listingType;
  bool _subscriptionReminderDismissed = false;

  final PageController _recommendedController = PageController(
    viewportFraction: 0.92,
  );

  @override
  void initState() {
    super.initState();
    _listingType = _ListingType.both;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileControllerProvider).value;
    final isOwner = user?.isOwner == true;
    final subscriptionStatusAsync = isOwner
        ? ref.watch(subscriptionStatusControllerProvider)
        : const AsyncValue.data(null);
    final subscriptionStatus = subscriptionStatusAsync.value;
    final showSubscriptionReminder = isOwner &&
        !_subscriptionReminderDismissed &&
        subscriptionStatus != null &&
        subscriptionStatus.shouldShowHomeReminder;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),
              const HomeSlider(),
              if (showSubscriptionReminder)
                SubscriptionExpiryReminder(
                  status: subscriptionStatus!,
                  onAction: () {
                    if (subscriptionStatus.isPending) {
                      AppNavigator.of(context).push(
                        const MySubscriptionsScreen(),
                      );
                    } else {
                      AppNavigator.of(context).push(const SubscriptionsScreen());
                    }
                  },
                  onDismiss: () {
                    setState(() => _subscriptionReminderDismissed = true);
                  },
                ),
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
                    SectionHeader(
                      title: tr.browse_by_category,
                      onSeeAll: () {
                        AppNavigator.of(context).push(const AssetsScreen());
                      },
                    ),
                    SizedBox(height: 1.5.h),
                    SizedBox(
                      height: 13.5.h,
                      child: ref
                          .watch(homeCategoryControllerProvider)
                          .when(
                            data: (categories) => ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              itemCount: categories.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(width: 2.5.w),
                              itemBuilder: (context, index) {
                                final item = categories[index];
                                return CategoryImageCard(
                                  title: item.name,
                                  imageUrl: item.image,
                                  isSelected: _selectedCategoryIndex == index,
                                  onTap: () {
                                    setState(
                                      () => _selectedCategoryIndex = index,
                                    );
                                    debugPrint(
                                      'Category tapped: id=${item.id}, name=${item.name}',
                                    );
                                    AppNavigator.of(context).push(
                                      AssetsScreen(initialCategoryId: item.id),
                                    );
                                  },
                                );
                              },
                            ),
                            loading: () => ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              itemCount: 4,
                              separatorBuilder: (_, __) =>
                                  SizedBox(width: 2.5.w),
                              itemBuilder: (_, __) => ShimmerPlaceholder(
                                width: 34.w,
                                height: 13.5.h,
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                    ),

                    SizedBox(height: 2.5.h),

                    // ── Top Rated Properties ────────────────────────────
                    SectionHeader(
                      title: tr.top_rated,
                      onSeeAll: () =>
                          AppNavigator.of(context).push(const TopRatedScreen()),
                    ),
                    _buildTopRated(),

                    SizedBox(height: 2.5.h),

                    // ── Top Rated Owners ────────────────────────────────
                    SectionHeader(
                      title: tr.top_rated_owners,
                      onSeeAll: () => AppNavigator.of(context).push(
                        const AllOwnersScreen(),
                      ),
                    ),
                    _buildTopOwners(),

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

  // ── Top Rated ─────────────────────────────────────────────────────────────

  Widget _buildTopRated() {
    final topRatedAsync = ref.watch(topRatedAssetsControllerProvider);

    return topRatedAsync.when(
      data: (assets) {
        if (assets.isEmpty) return const SizedBox.shrink();

        // Show only the first 5 on the home screen
        final preview = assets.take(5).toList();

        return Column(
          children: [
            SizedBox(
              height: 43.h,
              child: GestureDetector(
                onTap: () => AppNavigator.of(context).push(
                  AssetDetailsScreen(
                    assetId: preview[_currentRecommendedIndex].id,
                    initialAsset: preview[_currentRecommendedIndex],
                  ),
                ),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      final page = _recommendedController.page ?? 0;
                      final newIndex = page.round();
                      if (newIndex != _currentRecommendedIndex) {
                        setState(() => _currentRecommendedIndex = newIndex);
                      }
                    }
                    return false;
                  },
                  child: PageView.builder(
                    controller: _recommendedController,
                    itemCount: preview.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == preview.length - 1 ? 0 : 3.w,
                        ),
                        child: PropertyTile(
                          item: preview[index].toPropertyItem(),
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
                preview.length,
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
        );
      },
      loading: () => SizedBox(
        height: 43.h,
        child: ShimmerPlaceholder(
          width: double.infinity,
          height: double.infinity,
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildTopOwners() {
    final ownersAsync = ref.watch(ownersControllerProvider);

    return ownersAsync.when(
      data: (owners) {
        if (owners.isEmpty) return const SizedBox.shrink();

        final preview = owners.take(5).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < preview.length; i++) ...[
                if (i > 0) SizedBox(width: 3.w),
                OwnerCard(
                  owner: preview[i],
                  onTap: () => AppNavigator.of(context).push(
                    OwnerProfileScreen(
                      ownerId: preview[i].id,
                      initialOwner: preview[i],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) SizedBox(width: 3.w),
              ShimmerPlaceholder(
                width: 36.w,
                height: 18.h,
                borderRadius: BorderRadius.circular(20),
              ),
            ],
          ],
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
