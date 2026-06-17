import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/screens/home/widgets/property_tile.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/rate_asset_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class TappableAssetRating extends ConsumerWidget {
  final int assetId;
  final double rating;
  final String? assetName;
  final bool compact;
  final bool showStars;

  const TappableAssetRating({
    super.key,
    required this.assetId,
    required this.rating,
    this.assetName,
    this.compact = false,
    this.showStars = false,
  });

  void _openRateSheet(BuildContext context) {
    showRateAssetSheet(
      context,
      assetId: assetId,
      assetName: assetName,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (compact) {
      return GestureDetector(
        onTap: () => _openRateSheet(context),
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
                rating.toStringAsFixed(1),
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
      );
    }

    return GestureDetector(
      onTap: () => _openRateSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: showStars ? 0 : 2.8.w,
          vertical: showStars ? 0 : 0.5.h,
        ),
        decoration: showStars
            ? null
            : BoxDecoration(
                color: AppColors.goldBrandColor.withAlpha(28),
                borderRadius: BorderRadius.circular(999),
              ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showStars) ...[
              RatingStars(rating: rating, size: 12),
              SizedBox(width: 1.w),
            ] else
              Icon(
                Icons.star_rounded,
                size: 15,
                color: AppColors.goldBrandColor,
              ),
            if (!showStars) SizedBox(width: 1.w),
            Text(
              rating.toStringAsFixed(1),
              style: appTextStyle(
                context,
                fontSize: showStars ? 9.6.sp : 10.5.sp,
                fontWeight: FontWeight.w800,
                color: showStars
                    ? Colors.black.withAlpha(150)
                    : Colors.black.withAlpha(225),
              ),
            ),
            SizedBox(width: 1.w),
            Icon(
              Icons.edit_outlined,
              size: showStars ? 12 : 13,
              color: AppColors.goldBrandColor.withAlpha(180),
            ),
          ],
        ),
      ),
    );
  }
}
