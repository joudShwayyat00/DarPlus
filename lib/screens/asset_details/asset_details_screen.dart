import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/appointment/data/models/appointment_response.dart';
import 'package:dar_plus_app/features/appointment/presentation/providers/appointment_providers.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_amenity.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_attribute.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/book_now_screen.dart';
import 'package:dar_plus_app/utils/ui/app_phone_field.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
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
                  if (!asset.isForSale && asset.rentType != null) ...[
                    SizedBox(height: 2.h),
                    _RentInfoCard(asset: asset),
                  ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.place_rounded,
                size: 16,
                color: Colors.black.withAlpha(130),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.location,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle(
                        context,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(160),
                      ),
                    ),
                    if (asset.locationAreaLine != null) ...[
                      SizedBox(height: 0.4.h),
                      Text(
                        asset.locationAreaLine!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: appTextStyle(
                          context,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.goldBrandColor.withAlpha(220),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
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

// ─── Rent Info Card ──────────────────────────────────────────────────────────

class _RentInfoCard extends StatelessWidget {
  final AssetItem asset;

  const _RentInfoCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    final rentType = asset.rentType ?? 'monthly';
    final count = rentType == 'yearly' ? asset.yearsCount : asset.monthsCount;
    final countLabel = rentType == 'yearly' ? 'Years' : 'Months';

    String rentTypeLabel;
    IconData rentTypeIcon;
    switch (rentType) {
      case 'daily':
        rentTypeLabel = 'Daily';
        rentTypeIcon = Icons.today_rounded;
      case 'yearly':
        rentTypeLabel = 'Yearly';
        rentTypeIcon = Icons.calendar_today_rounded;
      default:
        rentTypeLabel = 'Monthly';
        rentTypeIcon = Icons.calendar_month_rounded;
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: Colors.black.withAlpha(8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rent Details',
            style: appTextStyle(
              context,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(230),
            ),
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              // Rent type chip
              _RentDetailTile(
                icon: rentTypeIcon,
                label: 'Rent Type',
                value: rentTypeLabel,
              ),
              if (count != null && count > 0) ...[
                SizedBox(width: 3.w),
                _RentDetailTile(
                  icon: Icons.timelapse_rounded,
                  label: countLabel,
                  value: count.toString(),
                ),
              ],
              if (asset.rentPrice != null) ...[
                SizedBox(width: 3.w),
                _RentDetailTile(
                  icon: Icons.payments_outlined,
                  label: 'Rent Price',
                  value:
                      '${asset.rentPrice!.toStringAsFixed(2)} ${tr.currency_jod}',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RentDetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RentDetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.4.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: AppColors.goldBrandColor.withAlpha(15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.goldBrandColor.withAlpha(50)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.goldBrandColor),
            SizedBox(height: 0.6.h),
            Text(
              label,
              style: appTextStyle(
                context,
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(130),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.3.h),
            Text(
              value,
              style: appTextStyle(
                context,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(230),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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

class _BottomBar extends ConsumerWidget {
  final AssetItem asset;

  const _BottomBar({required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    () {
                      if (asset.isForSale) {
                        return '${asset.price} ${tr.currency_jod}';
                      }
                      final price =
                          asset.rentPrice ?? double.tryParse(asset.price) ?? 0;
                      final priceStr = price.toStringAsFixed(2);
                      final suffix = asset.rentType == 'daily'
                          ? tr.per_day
                          : asset.rentType == 'yearly'
                          ? tr.per_year
                          : tr.per_month;
                      return '$priceStr ${tr.currency_jod}$suffix';
                    }(),
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
            // Action button
            GestureDetector(
              onTap: () {
                if (asset.isForSale) {
                  _showAppointmentDialog(context, ref, asset);
                } else {
                  AppNavigator.of(
                    context,
                  ).push(BookingScreen(item: asset.toPropertyItem()));
                }
              },
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

  static void _showAppointmentDialog(
    BuildContext context,
    WidgetRef ref,
    AssetItem asset,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AppointmentSheet(asset: asset),
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

// ─── Appointment Sheet ────────────────────────────────────────────────────────

class _AppointmentSheet extends ConsumerStatefulWidget {
  final AssetItem asset;

  const _AppointmentSheet({required this.asset});

  @override
  ConsumerState<_AppointmentSheet> createState() => _AppointmentSheetState();
}

class _AppointmentSheetState extends ConsumerState<_AppointmentSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  String _completePhoneNumber = '';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  static String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  static String _displayDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.goldBrandColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.goldBrandColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: appTextStyle(
            context,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black.withAlpha(220),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final phone = _completePhoneNumber.isNotEmpty
        ? _completePhoneNumber
        : _phoneCtrl.text.trim();
    final email = _emailCtrl.text.trim();

    if (name.isEmpty || _phoneCtrl.text.trim().isEmpty || email.isEmpty) {
      _toast('Please fill in all required fields');
      return;
    }
    if (_date == null) {
      _toast('Please select a date');
      return;
    }
    if (_time == null) {
      _toast('Please select a time');
      return;
    }

    final assetId = widget.asset.id;

    await ref
        .read(appointmentControllerProvider.notifier)
        .submit(
          assetId: assetId,
          name: name,
          phone: phone,
          email: email,
          date: _fmtDate(_date!),
          time: _fmtTime(_time!),
          note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        );

    if (!mounted) return;
    final state = ref.read(appointmentControllerProvider);
    state.when(
      data: (data) {
        Navigator.pop(context);
        _showSuccessDialog(context, data);
      },
      error: (e, _) {
        final msg = e.toString().replaceFirst('Exception: ', '');
        _toast(msg);
      },
      loading: () {},
    );
  }

  static void _showSuccessDialog(BuildContext context, AppointmentData? data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/success.json',
                width: 140,
                height: 140,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 1.6.h),
              Text(
                'Appointment Requested!',
                style: appTextStyle(
                  context,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withAlpha(230),
                ),
              ),
              SizedBox(height: 0.8.h),
              Text(
                'We will contact you to confirm your visit.',
                textAlign: TextAlign.center,
                style: appTextStyle(
                  context,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withAlpha(140),
                  height: 1.4,
                ),
              ),
              if (data != null) ...[
                SizedBox(height: 1.5.h),
                _AppointmentSummaryCard(data: data),
              ],
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldBrandColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.6.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Done',
                    style: appTextStyle(
                      context,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(appointmentControllerProvider).isLoading;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 5.w,
        right: 5.w,
        top: 2.4.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 3.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 12.w,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(30),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            SizedBox(height: 2.4.h),
            // Title
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.4.w),
                  decoration: BoxDecoration(
                    color: AppColors.goldBrandColor.withAlpha(22),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.goldBrandColor,
                    size: 22,
                  ),
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Appointment',
                      style: appTextStyle(
                        context,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.black.withAlpha(235),
                      ),
                    ),
                    Text(
                      widget.asset.name,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle(
                        context,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(130),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.4.h),
            // Name
            _AppointmentField(
              controller: _nameCtrl,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline_rounded,
            ),
            SizedBox(height: 1.4.h),
            // Phone
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone Number',
                  style: appTextStyle(
                    context,
                    fontSize: 10.6.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withAlpha(160),
                  ),
                ),
                SizedBox(height: 0.6.h),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: AppPhoneField(
                    controller: _phoneCtrl,
                    hint: 'Phone number',
                    initialCountryCode: 'JO',
                    textInputAction: TextInputAction.next,
                    onChangedCompleteNumber: (v) {
                      _completePhoneNumber = v;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.4.h),
            // Email
            _AppointmentField(
              controller: _emailCtrl,
              label: 'Email Address',
              hint: 'Enter your email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 1.4.h),
            // Date & Time row
            Row(
              children: [
                Expanded(
                  child: _DateTimePickerTile(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: _date != null ? _displayDate(_date!) : null,
                    placeholder: 'Select date',
                    onTap: _pickDate,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _DateTimePickerTile(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: _time != null ? _fmtTime(_time!) : null,
                    placeholder: 'Select time',
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.4.h),
            // Note (optional)
            _AppointmentField(
              controller: _noteCtrl,
              label: 'Note (optional)',
              hint: 'Any special requests or notes...',
              icon: Icons.notes_rounded,
              maxLines: 3,
            ),
            SizedBox(height: 2.4.h),
            // Submit button
            AbsorbPointer(
              absorbing: isLoading,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoading
                        ? AppColors.goldBrandColor.withAlpha(160)
                        : AppColors.goldBrandColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Submit Appointment',
                          style: appTextStyle(
                            context,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
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

// ─── Appointment Form Widgets ─────────────────────────────────────────────────

class _AppointmentField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;

  const _AppointmentField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: appTextStyle(
            context,
            fontSize: 10.6.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black.withAlpha(160),
          ),
        ),
        SizedBox(height: 0.6.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: appTextStyle(
            context,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withAlpha(220),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: appTextStyle(
              context,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black.withAlpha(100),
            ),
            prefixIcon: Icon(icon, size: 20, color: AppColors.goldBrandColor),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.4.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.black.withAlpha(18)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.black.withAlpha(18)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.goldBrandColor.withAlpha(160),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DateTimePickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  const _DateTimePickerTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: appTextStyle(
            context,
            fontSize: 10.6.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black.withAlpha(160),
          ),
        ),
        SizedBox(height: 0.6.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.4.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasValue
                    ? AppColors.goldBrandColor.withAlpha(120)
                    : Colors.black.withAlpha(18),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.goldBrandColor),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    value ?? placeholder,
                    overflow: TextOverflow.ellipsis,
                    style: appTextStyle(
                      context,
                      fontSize: 10.8.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withAlpha(hasValue ? 220 : 110),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AppointmentSummaryCard extends StatelessWidget {
  final AppointmentData data;

  const _AppointmentSummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.goldBrandColor.withAlpha(12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(60)),
      ),
      child: Column(
        children: [
          _SummaryRow(icon: Icons.calendar_today_rounded, value: data.date),
          SizedBox(height: 0.8.h),
          _SummaryRow(icon: Icons.access_time_rounded, value: data.time),
          SizedBox(height: 0.8.h),
          _SummaryRow(icon: Icons.person_outline_rounded, value: data.name),
          SizedBox(height: 0.8.h),
          _SummaryRow(
            icon: Icons.tag_rounded,
            value: 'Appointment #${data.id}',
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const _SummaryRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.goldBrandColor),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            value,
            style: appTextStyle(
              context,
              fontSize: 10.8.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black.withAlpha(210),
            ),
          ),
        ),
      ],
    );
  }
}
