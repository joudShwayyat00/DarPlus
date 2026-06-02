import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_amenity.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_attribute.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/book_now_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class AssetDetailsScreen extends ConsumerWidget {
  final int assetId;

  /// Optional snapshot already fetched from the list — shown instantly
  /// while the detail API loads.
  final AssetItem? initialAsset;

  const AssetDetailsScreen({
    super.key,
    required this.assetId,
    this.initialAsset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(assetDetailControllerProvider(assetId));

    // Use fresh API data if loaded, otherwise show the initial snapshot
    final asset = detailAsync.whenOrNull(data: (a) => a) ?? initialAsset;

    if (asset == null) {
      // Still loading and no snapshot → full shimmer screen
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(child: _buildShimmer()),
      );
    }

    return _AssetDetailsBody(asset: asset, isRefreshing: detailAsync.isLoading);
  }

  Widget _buildShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShimmerPlaceholder(
            width: double.infinity,
            height: 33.h,
            borderRadius: BorderRadius.zero,
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                ShimmerPlaceholder(
                  width: double.infinity,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(18),
                ),
                SizedBox(height: 2.h),
                ShimmerPlaceholder(
                  width: double.infinity,
                  height: 8.h,
                  borderRadius: BorderRadius.circular(18),
                ),
                SizedBox(height: 2.h),
                ShimmerPlaceholder(
                  width: double.infinity,
                  height: 15.h,
                  borderRadius: BorderRadius.circular(18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _AssetDetailsBody extends StatelessWidget {
  final AssetItem asset;
  final bool isRefreshing;

  const _AssetDetailsBody({required this.asset, required this.isRefreshing});

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
                  if (isRefreshing)
                    LinearProgressIndicator(
                      color: AppColors.goldBrandColor,
                      backgroundColor: AppColors.goldBrandColor.withAlpha(30),
                      minHeight: 2,
                    ),
                  SizedBox(height: 1.2.h),
                  _InfoCard(asset: asset),
                  SizedBox(height: 2.h),
                  _OwnerCard(owner: asset.owner),
                  if (_hasDescription) ...[
                    SizedBox(height: 2.h),
                    _SectionTitle(title: tr.overview),
                    SizedBox(height: 1.h),
                    Text(
                      _strippedDescription,
                      style: appTextStyle(
                        context,
                        fontSize: 11.5.sp,
                        height: 1.55,
                        color: Colors.black.withAlpha(175),
                      ),
                    ),
                  ],
                  if (_hasAttributes) ...[
                    SizedBox(height: 2.2.h),
                    _SectionTitle(title: tr.attributes),
                    SizedBox(height: 1.h),
                    _AttributesList(attributes: asset.attributes!),
                  ],
                  if (_hasAmenities) ...[
                    SizedBox(height: 2.2.h),
                    _SectionTitle(title: tr.amenities),
                    SizedBox(height: 1.h),
                    _AmenitiesGrid(amenities: asset.amenities!),
                  ],
                  SizedBox(height: 2.2.h),
                  _SectionTitle(title: tr.contact_and_social),
                  SizedBox(height: 1.h),
                  _ContactCard(asset: asset),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomBar(asset: asset),
    );
  }

  bool get _hasDescription =>
      asset.description != null && asset.description!.trim().isNotEmpty;

  bool get _hasAttributes =>
      asset.attributes != null && asset.attributes!.isNotEmpty;

  bool get _hasAmenities =>
      asset.amenities != null && asset.amenities!.isNotEmpty;

  String get _strippedDescription =>
      (asset.description ?? '').replaceAll(RegExp(r'<[^>]*>'), '').trim();

  SliverAppBar _buildAppBar(BuildContext context) {
    final isForSale = asset.isForSale;

    return SliverAppBar(
      expandedHeight: 33.h,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.only(left: 2.w),
        child: IconButton(
          onPressed: () => AppNavigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          iconSize: 20,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withAlpha(235),
            shape: const CircleBorder(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: asset.image,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: Colors.grey.shade200),
              errorWidget: (_, __, ___) => Container(
                color: Colors.grey.shade200,
                child: Icon(
                  Icons.image_not_supported_rounded,
                  color: Colors.grey.shade400,
                  size: 48,
                ),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(15),
                    Colors.black.withAlpha(90),
                  ],
                ),
              ),
            ),
            // Listing-type badge
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.5.w,
                  vertical: 0.7.h,
                ),
                decoration: BoxDecoration(
                  color: isForSale
                      ? const Color(0xFF1B6B2F)
                      : AppColors.goldBrandColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isForSale ? tr.for_sale : tr.for_rent,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            // Category badge
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(220),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  asset.category.name,
                  style: TextStyle(
                    color: Colors.black.withAlpha(220),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w800,
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

// ─── Info Card ────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final AssetItem asset;

  const _InfoCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(70)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withAlpha(10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            asset.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: appTextStyle(
              context,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(245),
            ),
          ),
          SizedBox(height: 0.8.h),
          Row(
            children: [
              Icon(
                Icons.place_rounded,
                size: 16,
                color: Colors.black.withAlpha(130),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  asset.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: appTextStyle(
                    context,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withAlpha(160),
                  ),
                ),
              ),
              // Rating pill
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.8.w,
                  vertical: 0.5.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor.withAlpha(28),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 15,
                      color: AppColors.goldBrandColor,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      asset.rating.toStringAsFixed(1),
                      style: appTextStyle(
                        context,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withAlpha(225),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Owner Card ───────────────────────────────────────────────────────────────

class _OwnerCard extends StatelessWidget {
  final AssetOwner owner;

  const _OwnerCard({required this.owner});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: Colors.black.withAlpha(8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 11.w,
            height: 11.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.goldBrandColor.withAlpha(30),
              border: Border.all(color: AppColors.goldBrandColor.withAlpha(80)),
              image: owner.image != null
                  ? DecorationImage(
                      image: NetworkImage(owner.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: owner.image == null
                ? Icon(
                    Icons.person_rounded,
                    size: 22,
                    color: AppColors.goldBrandColor,
                  )
                : null,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owner.name,
                  style: appTextStyle(
                    context,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withAlpha(230),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  owner.email,
                  style: appTextStyle(
                    context,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withAlpha(140),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppColors.goldBrandColor.withAlpha(20),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              tr.owner,
              style: appTextStyle(
                context,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.goldBrandColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Attributes List ──────────────────────────────────────────────────────────

class _AttributesList extends StatelessWidget {
  final List<AssetAttribute> attributes;

  const _AttributesList({required this.attributes});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2.5.w,
      runSpacing: 1.2.h,
      children: attributes.map((attr) => _AttributeChip(attr: attr)).toList(),
    );
  }
}

class _AttributeChip extends StatelessWidget {
  final AssetAttribute attr;

  const _AttributeChip({required this.attr});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withAlpha(15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            imageUrl: attr.icon,
            width: 18,
            height: 18,
            fit: BoxFit.contain,
            errorWidget: (_, __, ___) => Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: Colors.black.withAlpha(120),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            attr.name,
            style: appTextStyle(
              context,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black.withAlpha(210),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Amenities Grid ───────────────────────────────────────────────────────────

class _AmenitiesGrid extends StatelessWidget {
  final List<AssetAmenity> amenities;

  const _AmenitiesGrid({required this.amenities});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3.w,
      runSpacing: 1.5.h,
      children: amenities.map((a) => _AmenityTile(amenity: a)).toList(),
    );
  }
}

class _AmenityTile extends StatelessWidget {
  final AssetAmenity amenity;

  const _AmenityTile({required this.amenity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26.w,
      padding: EdgeInsets.symmetric(vertical: 1.4.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: amenity.icon,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorWidget: (_, __, ___) => Icon(
              Icons.check_circle_outline_rounded,
              size: 28,
              color: AppColors.goldBrandColor,
            ),
          ),
          SizedBox(height: 0.8.h),
          Text(
            amenity.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: appTextStyle(
              context,
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black.withAlpha(210),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Contact Card ─────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final AssetItem asset;

  const _ContactCard({required this.asset});

  bool _has(String? v) => v != null && v.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final phone = _has(asset.phone) ? asset.phone! : asset.owner.phoneNumber;
    final email = _has(asset.email) ? asset.email! : asset.owner.email;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: Colors.black.withAlpha(8),
          ),
        ],
      ),
      child: Column(
        children: [
          _ContactRow(icon: Icons.phone_rounded, label: tr.phone, value: phone),
          Divider(height: 2.h, color: Colors.black.withAlpha(12)),
          _ContactRow(
            icon: Icons.email_outlined,
            label: tr.email,
            value: email,
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
          padding: EdgeInsets.all(2.4.w),
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
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withAlpha(130),
                ),
              ),
              Text(
                value,
                style: appTextStyle(
                  context,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withAlpha(225),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Bottom Bar ───────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final AssetItem asset;

  const _BottomBar({required this.asset});

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
            // Price column
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr.price_label,
                    style: appTextStyle(
                      context,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withAlpha(140),
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  Text(
                    '${asset.price} ${tr.currency_jod}',
                    style: appTextStyle(
                      context,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withAlpha(240),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            // Book Now button
            GestureDetector(
              onTap: () => AppNavigator.of(
                context,
              ).push(BookingScreen(item: asset.toPropertyItem())),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.6.h),
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldBrandColor.withAlpha(80),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      asset.isForSale ? tr.request_appointment : tr.book_now,
                      style: appTextStyle(
                        context,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
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

// ─── Shared ───────────────────────────────────────────────────────────────────

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
