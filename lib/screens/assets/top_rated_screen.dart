import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/asset_details/asset_details_screen.dart';
import 'package:dar_plus_app/screens/home/widgets/property_tile.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class TopRatedScreen extends ConsumerWidget {
  const TopRatedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(topRatedAssetsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _TopRatedHeader(
              onRefresh: () =>
                  ref.read(topRatedAssetsControllerProvider.notifier).refresh(),
            ),
            Expanded(
              child: assetsAsync.when(
                data: (assets) => _buildList(context, assets),
                loading: () => _buildShimmer(),
                error: (_, __) => _buildError(
                  context,
                  () => ref
                      .read(topRatedAssetsControllerProvider.notifier)
                      .refresh(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── List ───────────────────────────────────────────────────────────────────

  Widget _buildList(BuildContext context, List<AssetItem> assets) {
    if (assets.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_outline_rounded,
              size: 56,
              color: AppColors.grayBrandColor.withAlpha(100),
            ),
            SizedBox(height: 2.h),
            Text(
              tr.no_more_results,
              style: appTextStyle(
                context,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.grayBrandColor,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.goldBrandColor,
      onRefresh: () async {
        // Provider will rebuild automatically when invalidated from outside
      },
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
        itemCount: assets.length,
        separatorBuilder: (_, __) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final asset = assets[index];
          return GestureDetector(
            onTap: () => AppNavigator.of(
              context,
            ).push(AssetDetailsScreen(assetId: asset.id, initialAsset: asset)),
            child: PropertyTile(item: asset.toPropertyItem()),
          );
        },
      ),
    );
  }

  // ── Shimmer ────────────────────────────────────────────────────────────────

  Widget _buildShimmer() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
      itemCount: 4,
      separatorBuilder: (_, __) => SizedBox(height: 2.h),
      itemBuilder: (_, __) => ShimmerPlaceholder(
        width: double.infinity,
        height: 43.h,
        borderRadius: BorderRadius.circular(22),
      ),
    );
  }

  // ── Error ──────────────────────────────────────────────────────────────────

  Widget _buildError(BuildContext context, VoidCallback onRetry) {
    return Center(
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
            onTap: onRetry,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.2.h),
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
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _TopRatedHeader extends StatelessWidget {
  final VoidCallback onRefresh;

  const _TopRatedHeader({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
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
          const AppBackButton(),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              tr.top_rated,
              style: appTextStyle(
                context,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(240),
              ),
            ),
          ),
          // Star badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
            decoration: BoxDecoration(
              color: AppColors.goldBrandColor.withAlpha(20),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.goldBrandColor.withAlpha(80)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: AppColors.goldBrandColor,
                ),
                SizedBox(width: 1.w),
                Text(
                  tr.top_rated,
                  style: appTextStyle(
                    context,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.goldBrandColor,
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
