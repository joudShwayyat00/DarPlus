import 'dart:ui';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/models/property_item.dart';
import 'package:dar_plus_app/utils/helpers/booking_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_net_image.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PropertyTile extends StatelessWidget {
  final PropertyItem item;
  final VoidCallback? onBookNow;

  const PropertyTile({super.key, required this.item, this.onBookNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withAlpha(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 22,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 18.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppNetImage(url: item.images.first),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withAlpha(120),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Listing type badge (For Sale / For Rent)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 0.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: item.listingType == ListingType.sale
                            ? const Color(0xFF1B6B2F)
                            : AppColors.goldBrandColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.listingType == ListingType.sale
                            ? tr.for_sale
                            : tr.for_rent,
                        style: appTextStyle(
                          context,
                          fontSize: 9.sp,
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
              padding: EdgeInsets.all(3.3.w),
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
                      fontSize: 12.2.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: 0.7.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.black.withAlpha(120),
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          item.location == "Dead Sea"
                              ? tr.sample_dead_sea
                              : item.location == "Jerash"
                              ? tr.sample_jerash
                              : item.location == "Aqaba"
                              ? tr.sample_aqaba
                              : item.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: appTextStyle(
                            context,
                            fontSize: 9.8.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withAlpha(140),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.1.h),
                  _PriceChip(price: item.price),
                  SizedBox(height: 0.7.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RatingStars(rating: item.rating, size: 12),
                      SizedBox(width: 1.w),
                      Text(
                        item.rating.toStringAsFixed(1),
                        style: appTextStyle(
                          context,
                          fontSize: 9.6.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.6.h),

                  _LuxuryPrimaryButton(
                    title: item.listingType == ListingType.sale
                        ? tr.request_appointment
                        : tr.book_now,
                    onPressed:
                        onBookNow ??
                        () => openBookingFlow(context, item),
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

/// Price chip
class _PriceChip extends StatelessWidget {
  final String price;

  const _PriceChip({required this.price});

  @override
  Widget build(BuildContext context) {
    final match = RegExp(r'\d+').firstMatch(price);
    final displayPrice = match != null
        ? '${match.group(0)} ${tr.currency_jod}${tr.per_night}'
        : price;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.75.h),
      decoration: BoxDecoration(
        color: AppColors.goldBrandColor.withAlpha(16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(70)),
      ),
      child: Text(
        displayPrice,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: appTextStyle(
          context,
          fontSize: 10.2.sp,
          fontWeight: FontWeight.w900,
          color: AppColors.goldBrandColor,
        ),
      ),
    );
  }
}

class GlassBadge extends StatelessWidget {
  final Widget child;

  const GlassBadge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(40),
            border: Border.all(color: Colors.white.withAlpha(70)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _LuxuryPrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _LuxuryPrimaryButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5.4.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldBrandColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: Colors.white.withAlpha(245),
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({super.key, required this.rating, this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          size: size.sp,
          color: AppColors.goldBrandColor,
        );
      }),
    );
  }
}
