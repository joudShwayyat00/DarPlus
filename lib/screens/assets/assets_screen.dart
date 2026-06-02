import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dar_plus_app/features/home/presentation/providers/home_providers.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:dar_plus_app/screens/asset_details/asset_details_screen.dart';
import 'package:dar_plus_app/screens/assets/add_asset_screen.dart';
import 'package:dar_plus_app/screens/search.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AssetsScreen extends ConsumerStatefulWidget {
  final int? initialCategoryId;
  final bool isOwnerView;

  const AssetsScreen({
    super.key,
    this.initialCategoryId,
    this.isOwnerView = false,
  });

  @override
  ConsumerState<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends ConsumerState<AssetsScreen> {
  int? _selectedCategoryId;
  FilterData _activeFilter = FilterData.empty;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategoryId != null) {
      _selectedCategoryId = widget.initialCategoryId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(assetsControllerProvider.notifier)
            .fetchByCategory(widget.initialCategoryId);
      });
    }
  }

  /// Returns assets filtered by listing type only (category filter is server-side).
  List<AssetItem> _filteredAssets(List<AssetItem> all) {
    final listingType = _activeFilter.listingType;
    if (listingType == null || listingType == 'both') return all;
    return all.where((a) {
      if (listingType == 'buy') return a.isForSale;
      return !a.isForSale;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCategoryTabs(),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 1.8.h, 5.w, 1.8.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _IconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => AppNavigator.of(context).pop(),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Builder(
              builder: (context) {
                if (widget.isOwnerView) {
                  return Text(
                    tr.my_assets,
                    style: appTextStyle(
                      context,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withAlpha(240),
                    ),
                  );
                }

                final categories = ref
                    .watch(homeCategoryControllerProvider)
                    .maybeWhen(data: (c) => c, orElse: () => null);

                final title = _selectedCategoryId == null
                    ? tr.all_assets
                    : (categories
                              ?.where((c) => c.id == _selectedCategoryId)
                              .firstOrNull
                              ?.name ??
                          tr.all_assets);

                return Text(
                  title,
                  style: appTextStyle(
                    context,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withAlpha(240),
                  ),
                );
              },
            ),
          ),
          if (widget.isOwnerView)
            _IconButton(
              icon: Icons.add_rounded,
              color: AppColors.goldBrandColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAssetScreen(),
                  ),
                );
              },
            )
          else ...[
            _IconButton(
              icon: Icons.search_rounded,
              color: AppColors.goldBrandColor,
              onTap: () => AppNavigator.of(
                context,
              ).push(const SearchScreen(showBackButton: true)),
            ),
            SizedBox(width: 2.w),
            _FilterIconButton(
              activeCount: _activeFilter.activeCount,
              onTap: () async {
                final result = await showFilterBottomSheet(
                  context,
                  initial: _activeFilter,
                );
                if (result != null) {
                  setState(() => _activeFilter = result);
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  // ── Category Tabs ─────────────────────────────────────────────────────────

  Widget _buildCategoryTabs() {
    final categoriesAsync = ref.watch(homeCategoryControllerProvider);

    return categoriesAsync.when(
      data: (categories) {
        return SizedBox(
          height: 6.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.8.h),
            itemCount: categories.length + 1,
            separatorBuilder: (_, __) => SizedBox(width: 2.w),
            itemBuilder: (context, index) {
              final isAll = index == 0;
              final categoryId = isAll ? null : categories[index - 1].id;
              final label = isAll ? tr.all_assets : categories[index - 1].name;
              final isSelected = _selectedCategoryId == categoryId;
              return GestureDetector(
                onTap: () {
                  if (_selectedCategoryId == categoryId) return;
                  setState(() => _selectedCategoryId = categoryId);
                  ref
                      .read(assetsControllerProvider.notifier)
                      .fetchByCategory(categoryId);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.goldBrandColor : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.goldBrandColor
                          : Colors.black.withAlpha(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.goldBrandColor.withAlpha(60)
                            : Colors.black.withAlpha(8),
                        blurRadius: isSelected ? 12 : 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: appTextStyle(
                        context,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : Colors.black.withAlpha(180),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => SizedBox(
        height: 6.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.8.h),
          itemCount: 4,
          separatorBuilder: (_, __) => SizedBox(width: 2.w),
          itemBuilder: (_, __) => Padding(
            padding: EdgeInsets.only(bottom: 0.4.h),
            child: ShimmerPlaceholder(
              width: 34.w,
              height: 4.2.h,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
      error: (_, __) => SizedBox(height: 6.h, child: const SizedBox.shrink()),
    );
  }

  // ── Grid ──────────────────────────────────────────────────────────────────

  Widget _buildGrid() {
    final assetsAsync = ref.watch(assetsControllerProvider);

    return assetsAsync.when(
      data: (assets) {
        final properties = _filteredAssets(assets);

        if (properties.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 48,
                  color: Colors.black.withAlpha(60),
                ),
                SizedBox(height: 1.5.h),
                Text(
                  tr.search,
                  style: appTextStyle(
                    context,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withAlpha(120),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.goldBrandColor,
          onRefresh: () async =>
              ref.read(assetsControllerProvider.notifier).refresh(),
          child: GridView.builder(
            padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.70,
              mainAxisSpacing: 2.h,
              crossAxisSpacing: 3.w,
            ),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final asset = properties[index];
              return _AssetGridCard(
                asset: asset,
                onTap: () => AppNavigator.of(context).push(
                  AssetDetailsScreen(assetId: asset.id, initialAsset: asset),
                ),
              );
            },
          ),
        );
      },
      loading: () => GridView.builder(
        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.70,
          mainAxisSpacing: 2.h,
          crossAxisSpacing: 3.w,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => ShimmerPlaceholder(
          width: double.infinity,
          height: double.infinity,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      error: (_, __) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: Colors.black.withAlpha(60),
            ),
            SizedBox(height: 1.5.h),
            Text(
              tr.error_occurred,
              style: appTextStyle(
                context,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(120),
              ),
            ),
            SizedBox(height: 1.5.h),
            GestureDetector(
              onTap: () =>
                  ref.read(assetsControllerProvider.notifier).refresh(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  tr.try_again,
                  style: appTextStyle(
                    context,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Asset Grid Card ──────────────────────────────────────────────────────────

class _AssetGridCard extends StatelessWidget {
  final AssetItem asset;
  final VoidCallback onTap;

  const _AssetGridCard({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isForSale = asset.isForSale;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black.withAlpha(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image with badges ──────────────────────────────────
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: asset.image,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: Colors.grey.shade200),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    // Listing type badge (For Sale / For Rent)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isForSale
                              ? const Color(0xFF1B6B2F)
                              : AppColors.goldBrandColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          isForSale ? tr.for_sale : tr.for_rent,
                          style: appTextStyle(
                            context,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Rating badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 1.8.w,
                          vertical: 0.35.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(230),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: AppColors.goldBrandColor,
                            ),
                            SizedBox(width: 0.6.w),
                            Text(
                              asset.rating.toStringAsFixed(1),
                              style: appTextStyle(
                                context,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.black.withAlpha(220),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Info ───────────────────────────────────────────────
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(2.5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        asset.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: appTextStyle(
                          context,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black.withAlpha(230),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.place_rounded,
                            size: 11,
                            color: Colors.black.withAlpha(120),
                          ),
                          SizedBox(width: 0.8.w),
                          Expanded(
                            child: Text(
                              asset.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: appTextStyle(
                                context,
                                fontSize: 8.5.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withAlpha(140),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Owner name
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 11,
                            color: Colors.black.withAlpha(100),
                          ),
                          SizedBox(width: 0.8.w),
                          Expanded(
                            child: Text(
                              asset.owner.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: appTextStyle(
                                context,
                                fontSize: 8.5.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withAlpha(140),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${asset.price} ${tr.currency_jod}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: appTextStyle(
                          context,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.goldBrandColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _IconButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.2.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: color ?? Colors.black.withAlpha(200),
        ),
      ),
    );
  }
}

class _FilterIconButton extends StatelessWidget {
  final int activeCount;
  final VoidCallback onTap;

  const _FilterIconButton({required this.activeCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = activeCount > 0;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(2.2.w),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.goldBrandColor.withAlpha(20)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 20,
              color: isActive
                  ? AppColors.goldBrandColor
                  : Colors.black.withAlpha(140),
            ),
          ),
          if (isActive)
            Positioned(
              top: -3,
              right: -3,
              child: Container(
                width: 15,
                height: 15,
                decoration: const BoxDecoration(
                  color: AppColors.goldBrandColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$activeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
