import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_amenity.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_attribute.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/asset_details/widgets/asset_location_map_card.dart';
import 'package:dar_plus_app/screens/asset_details/widgets/asset_video_card.dart';
import 'package:dar_plus_app/screens/assets/owner_calendar_screen.dart';
import 'package:dar_plus_app/utils/helpers/asset_video_helper.dart';
import 'package:dar_plus_app/screens/owners/owner_profile_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/helpers/asset_ownership_helper.dart';
import 'package:dar_plus_app/utils/helpers/booking_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:dar_plus_app/utils/widgets/appointment_sheet.dart';
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
                  if (!asset.isForSale &&
                      isCurrentUserAssetOwner(context, asset.owner.id)) ...[
                    SizedBox(height: 2.h),
                    _ManageAvailabilityCard(asset: asset),
                  ],
                  SizedBox(height: 2.h),
                  _PricingCard(asset: asset),
                  if (asset.space != null || asset.rooms != null) ...[
                    SizedBox(height: 2.h),
                    _PropertySpecsCard(asset: asset),
                  ],
                  if (asset.latitude != null && asset.longitude != null) ...[
                    SizedBox(height: 2.h),
                    AssetLocationMapCard(asset: asset),
                  ],
                  if (!asset.isForSale && asset.rentType != null) ...[
                    SizedBox(height: 2.h),
                    _RentInfoCard(asset: asset),
                  ],
                  if (asset.isForSale &&
                      (asset.rentPrice != null || asset.monthsCount != null)) ...[
                    SizedBox(height: 2.h),
                    _AdditionalPricingCard(asset: asset),
                  ],
                  if (asset.hasCheckTimes) ...[
                    SizedBox(height: 2.h),
                    _CheckInOutCard(asset: asset),
                  ],
                  if (asset.hasVideo) ...[
                    SizedBox(height: 2.h),
                    _SectionTitle(title: tr.watch_video),
                    SizedBox(height: 1.h),
                    AssetVideoCard(videoUrl: asset.resolvedVideoUrl!),
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
        background: _AssetImageGallery(
          imageUrls: asset.galleryImageUrls,
          isForSale: asset.isForSale,
          categoryName: asset.category.name,
        ),
      ),
    );
  }
}

class _AssetImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  final bool isForSale;
  final String categoryName;

  const _AssetImageGallery({
    required this.imageUrls,
    required this.isForSale,
    required this.categoryName,
  });

  @override
  State<_AssetImageGallery> createState() => _AssetImageGalleryState();
}

class _AssetImageGalleryState extends State<_AssetImageGallery> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls.isEmpty ? [''] : widget.imageUrls;

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) {
            final url = images[index];
            if (url.isEmpty) {
              return Container(color: Colors.grey.shade200);
            }
            return CachedNetworkImage(
              imageUrl: url,
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
            );
          },
        ),
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
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 3.5.w,
              vertical: 0.7.h,
            ),
            decoration: BoxDecoration(
              color: widget.isForSale
                  ? const Color(0xFF1B6B2F)
                  : AppColors.goldBrandColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              widget.isForSale ? tr.for_sale : tr.for_rent,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
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
              widget.categoryName,
              style: TextStyle(
                color: Colors.black.withAlpha(220),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final active = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 18 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.white
                        : Colors.white.withAlpha(120),
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            ),
          ),
      ],
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

class _PricingCard extends StatelessWidget {
  final AssetItem asset;

  const _PricingCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldBrandColor.withAlpha(28),
            AppColors.goldBrandColor.withAlpha(8),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(70)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.goldBrandColor.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sell_outlined,
              color: AppColors.goldBrandColor,
              size: 22,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.isForSale ? tr.price_label : tr.rent_price,
                  style: appTextStyle(
                    context,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withAlpha(140),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  asset.isForSale
                      ? formatPrice(asset.displayPrice, decimals: 2)
                      : formatPrice(
                          asset.rentPrice ?? asset.displayPrice,
                          decimals: 2,
                        ),
                  style: appTextStyle(
                    context,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withAlpha(240),
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

class _PropertySpecsCard extends StatelessWidget {
  final AssetItem asset;

  const _PropertySpecsCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr.property_specs,
            style: appTextStyle(
              context,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(230),
            ),
          ),
          SizedBox(height: 1.2.h),
          Row(
            children: [
              if (asset.space != null)
                Expanded(
                  child: _RentDetailTile(
                    icon: Icons.square_foot_rounded,
                    label: tr.property_space,
                    value: asset.space.toString(),
                  ),
                ),
              if (asset.space != null && asset.rooms != null)
                SizedBox(width: 3.w),
              if (asset.rooms != null)
                Expanded(
                  child: _RentDetailTile(
                    icon: Icons.meeting_room_outlined,
                    label: tr.rooms,
                    value: asset.rooms.toString(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdditionalPricingCard extends StatelessWidget {
  final AssetItem asset;

  const _AdditionalPricingCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[];

    if (asset.rentPrice != null) {
      tiles.add(
        Expanded(
          child: _RentDetailTile(
            icon: Icons.price_change_outlined,
            label: tr.rent_price,
            value: formatPrice(asset.rentPrice!, decimals: 2),
          ),
        ),
      );
    }
    if (asset.monthsCount != null) {
      if (tiles.isNotEmpty) tiles.add(SizedBox(width: 3.w));
      tiles.add(
        Expanded(
          child: _RentDetailTile(
            icon: Icons.calendar_month_rounded,
            label: tr.months_count,
            value: asset.monthsCount.toString(),
          ),
        ),
      );
    }

    if (tiles.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr.price_summary,
            style: appTextStyle(
              context,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(230),
            ),
          ),
          SizedBox(height: 1.2.h),
          IntrinsicHeight(child: Row(children: tiles)),
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
    final count = switch (rentType) {
      'yearly' => asset.yearsCount,
      'daily' => asset.daysCount,
      _ => asset.monthsCount,
    };
    final countLabel = switch (rentType) {
      'yearly' => tr.max_years,
      'daily' => tr.max_days,
      _ => tr.max_months,
    };

    final rentTypeLabel = switch (rentType) {
      'daily' => tr.daily,
      'yearly' => tr.yearly,
      _ => tr.monthly,
    };
    final rentTypeIcon = switch (rentType) {
      'daily' => Icons.today_rounded,
      'yearly' => Icons.calendar_today_rounded,
      _ => Icons.calendar_month_rounded,
    };

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
            tr.rent_details,
            style: appTextStyle(
              context,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(230),
            ),
          ),
          SizedBox(height: 1.5.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _RentDetailTile(
                    icon: rentTypeIcon,
                    label: tr.rent_type,
                    value: rentTypeLabel,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _RentDetailTile(
                    icon: Icons.timelapse_rounded,
                    label: countLabel,
                    value: count != null && count > 0 ? count.toString() : '-',
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _RentDetailTile(
                    icon: Icons.payments_outlined,
                    label: tr.rent_price,
                    value: asset.rentPrice != null
                        ? formatPrice(asset.rentPrice!, decimals: 2)
                        : '-',
                  ),
                ),
              ],
            ),
          ),
          if (rentType == 'daily' && asset.dayPrice != null) ...[
            SizedBox(height: 1.2.h),
            _RentDetailTile(
              icon: Icons.payments_outlined,
              label: tr.day_price,
              value: formatPrice(asset.dayPrice!, decimals: 2),
            ),
          ],
        ],
      ),
    );
  }
}

class _CheckInOutCard extends StatelessWidget {
  final AssetItem asset;

  const _CheckInOutCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    final checkIn = asset.displayCheckInTime;
    final checkOut = asset.displayCheckOutTime;

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
            tr.check_in_out_times,
            style: appTextStyle(
              context,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(230),
            ),
          ),
          SizedBox(height: 1.2.h),
          Row(
            children: [
              if (checkIn != null)
                Expanded(
                  child: _RentDetailTile(
                    icon: Icons.login_rounded,
                    label: tr.check_in_time,
                    value: checkIn,
                  ),
                ),
              if (checkIn != null && checkOut != null) SizedBox(width: 3.w),
              if (checkOut != null)
                Expanded(
                  child: _RentDetailTile(
                    icon: Icons.logout_rounded,
                    label: tr.check_out_time,
                    value: checkOut,
                  ),
                ),
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.4.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppColors.goldBrandColor.withAlpha(15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(50)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
    );
  }
}

// ─── Owner Card ───────────────────────────────────────────────────────────────

class _OwnerCard extends StatelessWidget {
  final AssetOwner owner;

  const _OwnerCard({required this.owner});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          AppNavigator.of(context).push(
            OwnerProfileScreen(
              ownerId: owner.id,
              initialOwner: owner,
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
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
          SizedBox(width: 1.w),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.black.withAlpha(80),
          ),
        ],
      ),
        ),
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

// ─── Owner availability ───────────────────────────────────────────────────────

class _ManageAvailabilityCard extends StatelessWidget {
  final AssetItem asset;

  const _ManageAvailabilityCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.goldBrandColor.withAlpha(18),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OwnerCalendarScreen(asset: asset),
          ),
        ),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.goldBrandColor.withAlpha(70)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor.withAlpha(35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.goldBrandColor,
                ),
              ),
              SizedBox(width: 3.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.manage_availability,
                      style: appTextStyle(
                        context,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.black.withAlpha(230),
                      ),
                    ),
                    SizedBox(height: 0.3.h),
                    Text(
                      tr.calendar_block_hint,
                      style: appTextStyle(
                        context,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(130),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.goldBrandColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Bar ───────────────────────────────────────────────────────────────

class _BottomBar extends ConsumerWidget {
  final AssetItem asset;

  const _BottomBar({required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwnAsset = isCurrentUserAssetOwner(context, asset.owner.id);
    final isOwnRentAsset = isOwnAsset && !asset.isForSale;
    final actionLabel = isOwnRentAsset
        ? tr.manage_availability
        : isOwnAsset
        ? tr.your_own_property
        : asset.isForSale
        ? tr.request_appointment
        : tr.book_now;

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
                        return formatPrice(asset.price);
                      }
                      final price =
                          asset.rentPrice ?? double.tryParse(asset.price) ?? 0;
                      final suffix = asset.rentType == 'daily'
                          ? tr.per_day
                          : asset.rentType == 'yearly'
                          ? tr.per_year
                          : tr.per_month;
                      return formatPrice(price, decimals: 2, suffix: suffix);
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
              onTap: isOwnRentAsset
                  ? () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OwnerCalendarScreen(asset: asset),
                      ),
                    )
                  : isOwnAsset
                  ? () => showOwnAssetActionBlockedMessage(context)
                  : () async {
                      if (asset.isForSale) {
                        await showAppointmentSheet(
                          context,
                          assetId: asset.id,
                          assetName: asset.name,
                          assetOwnerId: asset.owner.id,
                        );
                      } else {
                        await openBookingFlow(
                          context,
                          asset.toPropertyItem(),
                          assetOwnerId: asset.owner.id,
                        );
                      }
                    },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.6.h),
                decoration: BoxDecoration(
                  color: isOwnAsset && !isOwnRentAsset
                      ? Colors.black.withAlpha(35)
                      : AppColors.goldBrandColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isOwnAsset && !isOwnRentAsset
                      ? null
                      : [
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
                      isOwnRentAsset
                          ? Icons.calendar_month_outlined
                          : isOwnAsset
                          ? Icons.home_work_outlined
                          : Icons.calendar_month_outlined,
                      size: 18,
                      color: Colors.white.withAlpha(
                        isOwnAsset && !isOwnRentAsset ? 220 : 255,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      actionLabel,
                      style: appTextStyle(
                        context,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white.withAlpha(
                          isOwnAsset && !isOwnRentAsset ? 220 : 255,
                        ),
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
