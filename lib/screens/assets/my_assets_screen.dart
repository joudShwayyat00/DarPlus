import 'package:dar_plus_app/core/network/asset_api_exception.dart';
import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/features/home/presentation/providers/home_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/asset_details/asset_details_screen.dart';
import 'package:dar_plus_app/screens/assets/add_asset_screen.dart';
import 'package:dar_plus_app/screens/profile/subscriptions_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_net_image.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class MyAssetsScreen extends ConsumerStatefulWidget {
  const MyAssetsScreen({super.key});

  @override
  ConsumerState<MyAssetsScreen> createState() => _MyAssetsScreenState();
}

class _MyAssetsScreenState extends ConsumerState<MyAssetsScreen> {
  int? _selectedCategoryId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(myAssetsControllerProvider.notifier).loadMore();
    }
  }

  Future<void> _openEditAsset(AssetItem asset) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddAssetScreen(assetId: asset.id)),
    );
    if (mounted) {
      ref.read(myAssetsControllerProvider.notifier).refresh();
    }
  }

  Future<void> _confirmDeleteAsset(AssetItem asset) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withAlpha(140),
      builder: (ctx) => _DeleteAssetDialog(asset: asset),
    );

    if (confirmed != true || !mounted) return;

    EasyLoading.show();
    final success = await ref
        .read(deleteAssetControllerProvider.notifier)
        .submit(assetId: asset.id);
    EasyLoading.dismiss();

    if (!mounted) return;
    if (success) {
      EasyLoading.showSuccess(tr.asset_deleted_successfully);
      ref.invalidate(myAssetsControllerProvider);
      ref.invalidate(assetsControllerProvider);
      ref.invalidate(assetDetailControllerProvider(asset.id));
    } else {
      final err = ref.read(deleteAssetControllerProvider).error;
      if (err is AssetApiException && err.isSubscriptionRequired) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(tr.subscription_required_title),
            content: Text(err.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(tr.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SubscriptionsScreen(),
                    ),
                  );
                },
                child: Text(tr.renew_now),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              formatAssetApiError(err, fallback: tr.something_went_wrong),
            ),
          ),
        );
      }
    }
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

  // ── Header ─────────────────────────────────────────────────────────────────

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
            child: Text(
              tr.my_assets,
              style: appTextStyle(
                context,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(240),
              ),
            ),
          ),
          _IconButton(
            icon: Icons.add_rounded,
            color: AppColors.goldBrandColor,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddAssetScreen()),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Tabs ──────────────────────────────────────────────────────────

  Widget _buildCategoryTabs() {
    return ref
        .watch(homeCategoryControllerProvider)
        .when(
          data: (categories) => SizedBox(
            height: 6.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.8.h),
              itemCount: categories.length + 1,
              separatorBuilder: (_, __) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final categoryId = isAll ? null : categories[index - 1].id;
                final label = isAll
                    ? tr.all_assets
                    : categories[index - 1].name;
                final isSelected = _selectedCategoryId == categoryId;
                return GestureDetector(
                  onTap: () {
                    if (_selectedCategoryId == categoryId) return;
                    setState(() => _selectedCategoryId = categoryId);
                    ref
                        .read(myAssetsControllerProvider.notifier)
                        .fetchByCategory(categoryId);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.goldBrandColor
                          : Colors.white,
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
          ),
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
          error: (_, __) => SizedBox(height: 6.h),
        );
  }

  // ── Grid ───────────────────────────────────────────────────────────────────

  Widget _buildGrid() {
    final assetsAsync = ref.watch(myAssetsControllerProvider);

    return assetsAsync.when(
      data: (assets) {
        if (assets.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset(appLogo, height: 12.h, fit: BoxFit.contain),
                // SizedBox(height: 2.h),
                Text(
                  tr.no_more_results,
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

        final notifier = ref.read(myAssetsControllerProvider.notifier);

        return RefreshIndicator(
          color: AppColors.goldBrandColor,
          onRefresh: () async =>
              ref.read(myAssetsControllerProvider.notifier).refresh(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    mainAxisSpacing: 2.h,
                    crossAxisSpacing: 3.w,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final asset = assets[index];
                    return _MyAssetGridCard(
                      asset: asset,
                      onTap: () => AppNavigator.of(context).push(
                        AssetDetailsScreen(
                          assetId: asset.id,
                          initialAsset: asset,
                        ),
                      ),
                      onEdit: () => _openEditAsset(asset),
                      onDelete: () => _confirmDeleteAsset(asset),
                    );
                  }, childCount: assets.length),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: notifier.isLoadingMore
                      ? Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.goldBrandColor,
                            ),
                          ),
                        )
                      : notifier.hasMore
                      ? const SizedBox.shrink()
                      : Center(
                          child: Text(
                            tr.no_more_results,
                            style: appTextStyle(
                              context,
                              fontSize: 10.sp,
                              color: Colors.black.withAlpha(100),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => GridView.builder(
        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
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
                  ref.read(myAssetsControllerProvider.notifier).refresh(),
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

class _DeleteAssetDialog extends StatelessWidget {
  final AssetItem asset;

  const _DeleteAssetDialog({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 7.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(35),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2.8.h),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_forever_rounded,
                size: 32,
                color: Colors.red.shade500,
              ),
            ),
            SizedBox(height: 1.8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Text(
                tr.delete_asset,
                textAlign: TextAlign.center,
                style: appTextStyle(
                  context,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withAlpha(235),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Text(
                tr.delete_asset_confirm,
                textAlign: TextAlign.center,
                style: appTextStyle(
                  context,
                  fontSize: 10.8.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withAlpha(130),
                  height: 1.45,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F7F4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withAlpha(12)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: AppNetImage(url: asset.image),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            asset.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: appTextStyle(
                              context,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.black.withAlpha(220),
                            ),
                          ),
                          SizedBox(height: 0.4.h),
                          Row(
                            children: [
                              Icon(
                                Icons.place_rounded,
                                size: 13,
                                color: Colors.black.withAlpha(110),
                              ),
                              SizedBox(width: 0.8.w),
                              Expanded(
                                child: Text(
                                  asset.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: appTextStyle(
                                    context,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withAlpha(120),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.4.h),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.8.h),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      height: 5.5.h,
                      backgroundColor: Colors.grey.shade100,
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        tr.cancel,
                        style: appTextStyle(
                          context,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withAlpha(170),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: AppButton(
                      height: 5.5.h,
                      backgroundColor: Colors.red.shade500,
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        tr.delete,
                        style: appTextStyle(
                          context,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
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
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _MyAssetGridCard extends StatelessWidget {
  final AssetItem asset;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MyAssetGridCard({
    required this.asset,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

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
              // ── Image + badges ────────────────────────────────────
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppNetImage(url: asset.image),
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

              // ── Info ─────────────────────────────────────────────
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
                      Text(
                        formatPrice(asset.price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: appTextStyle(
                          context,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.goldBrandColor,
                        ),
                      ),
                      SizedBox(height: 0.6.h),
                      Row(
                        children: [
                          Expanded(
                            child: _AssetActionButton(
                              icon: Icons.edit_outlined,
                              label: tr.edit,
                              color: AppColors.goldBrandColor,
                              onTap: onEdit,
                            ),
                          ),
                          SizedBox(width: 1.5.w),
                          Expanded(
                            child: _AssetActionButton(
                              icon: Icons.delete_outline_rounded,
                              label: tr.delete,
                              color: Colors.red.shade500,
                              onTap: onDelete,
                            ),
                          ),
                        ],
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

class _AssetActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AssetActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0.55.h),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: color),
            SizedBox(width: 1.w),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: appTextStyle(
                  context,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helper ───────────────────────────────────────────────────────────────────

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
