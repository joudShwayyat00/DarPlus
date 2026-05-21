import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OwnerCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String specialty;

  const OwnerCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withAlpha(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar with gold ring
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      AppColors.goldBrandColor,
                      AppColors.goldBrandColor.withAlpha(80),
                      AppColors.goldBrandColor,
                    ],
                  ),
                ),
              ),
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: Colors.grey.shade200),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.person,
                        color: Colors.grey.shade400,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),
          // Name
          Text(
            name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: appTextStyle(
              context,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(height: 0.4.h),
          // Specialty
          Text(
            specialty,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: appTextStyle(
              context,
              fontSize: 8.8.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 0.8.h),
          // Rating row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded,
                color: AppColors.goldBrandColor,
                size: 14,
              ),
              const SizedBox(width: 3),
              Text(
                rating.toStringAsFixed(1),
                style: appTextStyle(
                  context,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.goldBrandColor,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                '($reviewCount)',
                style: appTextStyle(
                  context,
                  fontSize: 8.5.sp,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
