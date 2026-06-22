import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:dar_plus_app/features/owners/presentation/providers/owners_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/asset_details/asset_details_screen.dart';
import 'package:dar_plus_app/screens/home/widgets/owner_avatar.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/helpers/owner_labels.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:dar_plus_app/utils/widgets/rate_owner_dialog.dart';
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
    final profile = detail?.profile ?? initialOwner;

    if (profile == null) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(child: _buildShimmer()),
      );
    }

    return _OwnerProfileBody(
      ownerId: ownerId,
      profile: profile,
      assets: detail?.assets ?? const <AssetItem>[],
      isRefreshing: detailAsync.isLoading,
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: EdgeInsets.all(5.w),
      child: Column(
        children: [
          ShimmerPlaceholder(
            width: double.infinity,
            height: 10.h,
            borderRadius: BorderRadius.circular(18),
          ),
          SizedBox(height: 2.h),
          ShimmerPlaceholder(
            width: double.infinity,
            height: 12.h,
            borderRadius: BorderRadius.circular(18),
          ),
        ],
      ),
    );
  }
}

class _OwnerProfileBody extends StatelessWidget {
  final int ownerId;
  final AssetOwner profile;
  final List<AssetItem> assets;
  final bool isRefreshing;

  const _OwnerProfileBody({
    required this.ownerId,
    required this.profile,
    required this.assets,
    required this.isRefreshing,
  });

  String get _statusLabel => localizedOwnerStatusOrRole(
        status: profile.status,
        role: profile.role,
      );

  String get _roleLabel => localizedOwnerRole(profile.role);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isRefreshing) ...[
                    LinearProgressIndicator(
                      color: AppColors.goldBrandColor,
                      backgroundColor: AppColors.goldBrandColor.withAlpha(30),
                      minHeight: 2,
                    ),
                    SizedBox(height: 1.2.h),
                  ],
                  _ProfileCard(
                    profile: profile,
                    roleLabel: _roleLabel,
                    statusLabel: _statusLabel,
                    propertiesCount: assets.length,
                  ),
                  SizedBox(height: 2.2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _SectionTitle(title: tr.owner_properties),
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
                  if (assets.isEmpty) ...[
                    SizedBox(height: 2.h),
                    _EmptyPropertiesState(),
                  ],
                  SizedBox(height: assets.isEmpty ? 2.h : 1.2.h),
                ],
              ),
            ),
          ),
          if (assets.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 10.h),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: 0.74,
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
      bottomNavigationBar: _BottomBar(profile: profile, ownerId: ownerId),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => AppNavigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
      ),
      title: Text(
        profile.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: appTextStyle(
          context,
          fontSize: 14.sp,
          fontWeight: FontWeight.w800,
          color: Colors.black.withAlpha(230),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final AssetOwner profile;
  final String roleLabel;
  final String statusLabel;
  final int propertiesCount;

  const _ProfileCard({
    required this.profile,
    required this.roleLabel,
    required this.statusLabel,
    required this.propertiesCount,
  });

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(profile.status);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withAlpha(10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OwnerAvatar(owner: profile, size: 60, showRing: false),
          SizedBox(width: 3.5.w),
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
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withAlpha(240),
                  ),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  roleLabel,
                  style: appTextStyle(
                    context,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withAlpha(130),
                  ),
                ),
                SizedBox(height: 0.8.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 0.6.h,
                  children: [
                    _StatusChip(
                      label: statusLabel,
                      backgroundColor: statusStyle.background,
                      foregroundColor: statusStyle.foreground,
                      icon: statusStyle.icon,
                    ),
                    if (profile.rating != null)
                      _MetaChip(
                        icon: Icons.star_rounded,
                        label:
                            '${profile.rating!.toStringAsFixed(1)} ${tr.rating_score}',
                      ),
                    _MetaChip(
                      icon: Icons.home_work_outlined,
                      label: tr.owner_properties_count(propertiesCount),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  final Color background;
  final Color foreground;
  final IconData icon;

  const _StatusStyle({
    required this.background,
    required this.foreground,
    required this.icon,
  });
}

_StatusStyle _statusStyle(String status) {
  final normalized = status.toLowerCase();
  if (normalized.contains('block')) {
    return _StatusStyle(
      background: const Color(0xFFFFE8E8),
      foreground: const Color(0xFFC62828),
      icon: Icons.block_rounded,
    );
  }
  if (normalized.contains('active') || normalized.contains('verified')) {
    return _StatusStyle(
      background: const Color(0xFFE8F5E9),
      foreground: const Color(0xFF2E7D32),
      icon: Icons.verified_rounded,
    );
  }
  return _StatusStyle(
    background: Colors.black.withAlpha(12),
    foreground: Colors.black.withAlpha(170),
    icon: Icons.info_outline_rounded,
  );
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;

  const _StatusChip({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: foregroundColor),
          SizedBox(width: 1.w),
          Text(
            label,
            style: appTextStyle(
              context,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.4.h),
      decoration: BoxDecoration(
        color: AppColors.goldBrandColor.withAlpha(18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.goldBrandColor),
          SizedBox(width: 1.w),
          Text(
            label,
            style: appTextStyle(
              context,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.goldBrandColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: appTextStyle(
        context,
        fontSize: 13.sp,
        fontWeight: FontWeight.w900,
        color: Colors.black.withAlpha(240),
      ),
    );
  }
}

class _EmptyPropertiesState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAF8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withAlpha(8)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 36,
            color: Colors.black.withAlpha(60),
          ),
          SizedBox(height: 1.h),
          Text(
            tr.no_owner_properties,
            textAlign: TextAlign.center,
            style: appTextStyle(
              context,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black.withAlpha(120),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final AssetOwner profile;
  final int ownerId;

  const _BottomBar({required this.profile, required this.ownerId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.6.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, -6),
              color: Colors.black.withAlpha(12),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: appTextStyle(
                      context,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withAlpha(230),
                    ),
                  ),
                  if (profile.rating != null) ...[
                    SizedBox(height: 0.2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: AppColors.goldBrandColor,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          profile.rating!.toStringAsFixed(1),
                          style: appTextStyle(
                            context,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withAlpha(150),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 3.w),
            GestureDetector(
              onTap: () => showRateOwnerDialog(
                context,
                ownerId: ownerId,
                owner: profile,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      tr.rate_owner,
                      style: appTextStyle(
                        context,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
