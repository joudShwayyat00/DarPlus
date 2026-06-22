import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/configuration/app_images.dart';
import 'package:dar_plus_app/models/property_item.dart';
import 'package:dar_plus_app/utils/helpers/property_navigation.dart';
import 'package:dar_plus_app/screens/property_details/widget/property_images_slider.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/helpers/external_link_launcher.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final PropertyItem item;

  const PropertyDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final overlayTop = Colors.black.withAlpha(15);
    final overlayBottom = Colors.black.withAlpha(90);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 33.h,
            pinned: false,
            floating: false,
            snap: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.only(left: 1.8.w),
              child: IconButton(
                onPressed: () {
                  AppNavigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
                iconSize: 18.sp,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withAlpha(235),
                  shape: const CircleBorder(),
                  elevation: 0,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PropertyImagesSlider(images: item.images),
                  IgnorePointer(
                    ignoring: true,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [overlayTop, overlayBottom],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.w, 2.2.h, 5.w, 2.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoCard(item: item),
                  SizedBox(height: 1.2.h),

                  _SectionTitle(title: tr.overview),
                  SizedBox(height: 1.2.h),
                  Text(
                    item.title == "Sea View Chalet"
                        ? tr.sample_sea_view_chalet_description
                        : item.title == "Cozy Nature Chalet"
                        ? tr.sample_cozy_nature_chalet_description
                        : item.title == "Family Chalet with Pool"
                        ? tr.sample_family_chalet_description
                        : item.description,
                    style: appTextStyle(
                      context,
                      fontSize: 11.5.sp,
                      height: 1.5,
                      color: Colors.black.withAlpha(180),
                    ),
                  ),

                  SizedBox(height: 2.4.h),

                  _SectionTitle(title: tr.highlights),
                  SizedBox(height: 1.2.h),
                  Wrap(
                    spacing: 2.5.w,
                    runSpacing: 1.2.h,
                    children: [
                      _ChipInfo(
                        icon: Icons.group,
                        text: "${item.guests} ${tr.guests}",
                      ),
                      _ChipInfo(
                        icon: Icons.bed,
                        text: "${item.bedrooms} ${tr.bedrooms}",
                      ),
                      _ChipInfo(
                        icon: Icons.bathtub,
                        text: "${item.bathrooms} ${tr.bathrooms}",
                      ),
                      _ChipInfo(
                        icon: Icons.square_foot,
                        text: "${item.size.toStringAsFixed(0)} m²",
                      ),
                    ],
                  ),

                  SizedBox(height: 2.6.h),

                  _SectionTitle(title: tr.amenities),
                  SizedBox(height: 1.2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _AmenityTile(
                          icon: Icons.pool,
                          title: tr.pool,
                          isAvailable: item.hasPool,
                        ),
                      ),
                      SizedBox(width: 2.6.w),
                      Expanded(
                        child: _AmenityTile(
                          icon: Icons.outdoor_grill,
                          title: tr.bbq,
                          isAvailable: item.hasBbq,
                        ),
                      ),
                      SizedBox(width: 2.6.w),
                      Expanded(
                        child: _AmenityTile(
                          icon: Icons.wifi,
                          title: tr.wifi,
                          isAvailable: item.hasWifi,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.8.h),
                  _SectionTitle(title: tr.contact_and_social),
                  _ContactLinksCard(item: item),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.6.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, -6),
                color: Colors.black.withAlpha(15),
              ),
            ],
          ),
          child: Row(
            children: [
              AppButton(
                width: 45.w,
                backgroundColor: AppColors.goldBrandColor,
                onPressed: () => openPropertyActionFlow(context, item),
                child: Text(
                  item.listingType == ListingType.sale
                      ? tr.request_appointment
                      : tr.book_now,
                  style: appTextStyle(
                    context,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.price_label,
                      style: appTextStyle(
                        context,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(140),
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      (() {
                        if (item.listingType == ListingType.sale) {
                          final digits = extractPriceDigits(item.price);
                          return digits != null
                              ? formatPrice(digits)
                              : item.price;
                        }
                        if (item.rentPrice != null) {
                          final suffix = item.rentType == 'daily'
                              ? tr.per_day
                              : item.rentType == 'yearly'
                              ? tr.per_year
                              : tr.per_month;
                          return formatPrice(
                            item.rentPrice!,
                            decimals: 2,
                            suffix: suffix,
                          );
                        }
                        final digits = extractPriceDigits(item.price);
                        return digits != null
                            ? formatPrice(digits, suffix: tr.per_night)
                            : item.price;
                      })(),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final PropertyItem item;

  const _InfoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.2.w),
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
            item.title == "Sea View Chalet"
                ? tr.sample_sea_view_chalet
                : item.title == "Cozy Nature Chalet"
                ? tr.sample_cozy_nature_chalet
                : item.title == "Family Chalet with Pool"
                ? tr.sample_family_chalet_with_pool
                : item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: appTextStyle(
              context,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(245),
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.place, size: 18, color: Colors.black.withAlpha(150)),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.location,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle(
                        context,
                        fontSize: 11.8.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(170),
                      ),
                    ),
                    if (item.locationAreaLine != null) ...[
                      SizedBox(height: 0.4.h),
                      Text(
                        item.locationAreaLine!,
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
              _RatingPill(rating: item.rating),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactLinksCard extends StatelessWidget {
  final PropertyItem item;

  const _ContactLinksCard({required this.item});

  bool _has(String? v) => v != null && v.trim().isNotEmpty;

  Future<void> _launch(
    BuildContext context,
    Future<bool> Function() action,
  ) async {
    final ok = await action();
    if (!context.mounted || ok) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(tr.something_went_wrong)));
  }

  @override
  Widget build(BuildContext context) {
    final socialItems = <_SocialItem>[
      _SocialItem(
        label: tr.youtube,
        assetPath: youtubeLogo,
        url: item.youtubeUrl,
      ),
      _SocialItem(
        label: tr.facebook,
        assetPath: facebookLogo,
        url: item.facebookUrl,
      ),
      _SocialItem(
        label: tr.snapchat,
        assetPath: snapLogo,
        url: item.snapchatUrl,
      ),
      _SocialItem(
        label: tr.instagram,
        assetPath: instagramLogo,
        url: item.instagramUrl,
      ),
      _SocialItem(label: tr.tiktok, assetPath: tikTokLogo, url: item.tiktokUrl),
    ].where((e) => _has(e.url)).toList();

    return Container(
      margin: EdgeInsets.only(top: 1.2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withAlpha(10),
          ),
        ],
      ),
      child: Column(
        children: [
          _ContactRow(
            icon: Icons.phone,
            title: tr.phone,
            value: _has(item.phone) ? item.phone! : tr.not_provided,
            enabled: _has(item.phone),
            onTap: () => _launch(context, () => launchPhoneCall(item.phone!)),
          ),
          _ContactRow(
            icon: Icons.email,
            title: tr.email,
            value: _has(item.email) ? item.email! : tr.not_provided,
            enabled: _has(item.email),
            onTap: () => _launch(context, () => launchEmail(item.email!)),
          ),
          if (socialItems.isNotEmpty) ...[
            SizedBox(height: 1.2.h),

            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - 2 * 2.5.w) / 3;

                return Wrap(
                  spacing: 2.5.w,
                  runSpacing: 1.6.h,
                  alignment: WrapAlignment.start,
                  children: socialItems.map((s) {
                    return SizedBox(
                      width: itemWidth,
                      child: _SocialTile(
                        label: s.label,
                        assetPath: s.assetPath,
                        url: s.url,
                        onTap: () {
                          // TODO: launchUrl(Uri.parse(s.url!));
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _SocialItem {
  final String label;
  final String assetPath;
  final String? url;

  const _SocialItem({
    required this.label,
    required this.assetPath,
    required this.url,
  });
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool enabled;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final alpha = enabled ? 255 : 120;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.6.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 20, color: Colors.black.withAlpha(alpha)),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: appTextStyle(
                      context,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withAlpha(140),
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  Text(
                    value,
                    style: appTextStyle(
                      context,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withAlpha(alpha),
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

class _SocialTile extends StatelessWidget {
  final String label;
  final String assetPath;
  final String? url;
  final VoidCallback? onTap;

  const _SocialTile({
    required this.label,
    required this.assetPath,
    required this.url,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = url != null && url!.trim().isNotEmpty;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.2.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black.withAlpha(18)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, width: 26, height: 26),
            SizedBox(height: 0.7.h),
            Text(
              label,
              style: appTextStyle(
                context,
                fontSize: 10.2.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black.withAlpha(200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  final double rating;

  const _RatingPill({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: AppColors.goldBrandColor.withAlpha(30),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(Icons.star, size: 16, color: AppColors.goldBrandColor),
          SizedBox(width: 1.w),
          Text(
            rating.toStringAsFixed(1),
            style: appTextStyle(
              context,
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black.withAlpha(230),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ChipInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black.withAlpha(170)),
          SizedBox(width: 1.8.w),
          Text(
            text,
            style: appTextStyle(
              context,
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black.withAlpha(220),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isAvailable;

  const _AmenityTile({
    required this.icon,
    required this.title,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isAvailable
        ? Colors.green.withAlpha(18)
        : Colors.red.withAlpha(18);
    final iconColor = isAvailable ? Colors.green : Colors.red;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor),
          SizedBox(height: 0.8.h),
          Text(
            title,
            style: appTextStyle(
              context,
              fontWeight: FontWeight.w900,
              fontSize: 11.sp,
              color: Colors.black.withAlpha(220),
            ),
          ),
          SizedBox(height: 0.4.h),
          Text(
            isAvailable ? tr.available : tr.not_available,
            style: appTextStyle(
              context,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black.withAlpha(140),
            ),
            textAlign: TextAlign.center,
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
