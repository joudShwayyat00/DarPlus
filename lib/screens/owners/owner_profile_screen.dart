import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:dar_plus_app/features/owners/presentation/providers/owners_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/asset_details/asset_details_screen.dart';
import 'package:dar_plus_app/screens/home/widgets/owner_avatar.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/rate_owner_dialog.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class OwnerProfileScreen extends ConsumerWidget {
  final int ownerId;
  final AssetOwner? initialOwner;

  const OwnerProfileScreen({
    super.key,
    required this.ownerId,
    this.initialOwner,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(ownerDetailControllerProvider(ownerId));
    final detail = detailAsync.whenOrNull(data: (d) => d);

    if (detail == null && initialOwner == null && detailAsync.isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F7F4),
        body: SafeArea(child: _buildShimmer()),
      );
    }

    final profile = detail?.profile ?? initialOwner!;
    final assets = detail?.assets ?? const <AssetItem>[];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),
      body: RefreshIndicator(
        color: AppColors.goldBrandColor,
        onRefresh: () =>
            ref.read(ownerDetailControllerProvider(ownerId).notifier).refresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _ProfileHeader(profile: profile)),
            if (detailAsync.isLoading && detail == null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: const LinearProgressIndicator(
                    color: AppColors.goldBrandColor,
                    backgroundColor: Color(0x22E07B00),
                    minHeight: 2,
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 1.h),
                child: _ContactSection(profile: profile),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 1.h),
                child: _RateOwnerButton(ownerId: ownerId, profile: profile),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 1.h),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.goldBrandColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        tr.owner_properties,
                        style: appTextStyle(
                          context,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black.withAlpha(230),
                        ),
                      ),
                    ),
                    Text(
                      tr.owner_properties_count(assets.length),
                      style: appTextStyle(
                        context,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(120),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (assets.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      tr.no_owner_properties,
                      textAlign: TextAlign.center,
                      style: appTextStyle(
                        context,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(120),
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 3.h),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3.w,
                    mainAxisSpacing: 2.h,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final asset = assets[index];
                      return _OwnerAssetCard(
                        asset: asset,
                        onTap: () => AppNavigator.of(context).push(
                          AssetDetailsScreen(
                            assetId: asset.id,
                            initialAsset: asset,
                          ),
                        ),
                      );
                    },
                    childCount: assets.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: EdgeInsets.all(5.w),
      child: Column(
        children: [
          ShimmerPlaceholder(
            width: double.infinity,
            height: 28.h,
            borderRadius: BorderRadius.circular(24),
          ),
          SizedBox(height: 2.h),
          ShimmerPlaceholder(
            width: double.infinity,
            height: 14.h,
            borderRadius: BorderRadius.circular(18),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final AssetOwner profile;

  const _ProfileHeader({required this.profile});

  String get _statusLabel {
    if (profile.status.isEmpty) return profile.role;
    return profile.status[0].toUpperCase() + profile.status.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 30.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.goldBrandColor,
                AppColors.goldBrandColor.withAlpha(200),
                const Color(0xFFB35700),
              ],
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(230),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 5.w,
          right: 5.w,
          bottom: 2.5.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OwnerAvatar(owner: profile, size: 78),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle(
                        context,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 0.6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.8.w,
                        vertical: 0.4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _statusLabel,
                        style: appTextStyle(
                          context,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (profile.rating != null) ...[
                      SizedBox(height: 0.6.h),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            profile.rating!.toStringAsFixed(1),
                            style: appTextStyle(
                              context,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RateOwnerButton extends StatelessWidget {
  final int ownerId;
  final AssetOwner profile;

  const _RateOwnerButton({
    required this.ownerId,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () => showRateOwnerDialog(
          context,
          ownerId: ownerId,
          owner: profile,
        ),
        icon: const Icon(Icons.star_rounded, size: 20),
        label: Text(
          tr.rate_owner,
          style: appTextStyle(
            context,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.goldBrandColor,
          side: BorderSide(color: AppColors.goldBrandColor.withAlpha(180)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  final AssetOwner profile;

  const _ContactSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withAlpha(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr.contact_and_social,
            style: appTextStyle(
              context,
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black.withAlpha(220),
            ),
          ),
          SizedBox(height: 1.2.h),
          _ContactRow(
            icon: Icons.email_outlined,
            label: tr.email,
            value: profile.email,
          ),
          Divider(height: 2.h, color: Colors.black.withAlpha(12)),
          _ContactRow(
            icon: Icons.phone_outlined,
            label: tr.phone,
            value: profile.phoneNumber,
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.5.w),
          decoration: BoxDecoration(
            color: AppColors.goldBrandColor.withAlpha(18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: AppColors.goldBrandColor),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: appTextStyle(
                  context,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withAlpha(110),
                ),
              ),
              SizedBox(height: 0.2.h),
              Text(
                value,
                style: appTextStyle(
                  context,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withAlpha(210),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OwnerAssetCard extends StatelessWidget {
  final AssetItem asset;
  final VoidCallback onTap;

  const _OwnerAssetCard({required this.asset, required this.onTap});

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
              color: Colors.black.withAlpha(8),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.3.h,
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
                            fontSize: 7.5.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2.5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle(
                        context,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withAlpha(220),
                      ),
                    ),
                    SizedBox(height: 0.3.h),
                    Text(
                      asset.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle(
                        context,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withAlpha(120),
                      ),
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      '${asset.price} ${tr.currency_jod}',
                      style: appTextStyle(
                        context,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.goldBrandColor,
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
