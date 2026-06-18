import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:dar_plus_app/screens/home/widgets/owner_avatar.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OwnerCard extends StatelessWidget {
  final AssetOwner owner;
  final VoidCallback? onTap;

  const OwnerCard({super.key, required this.owner, this.onTap});

  String get _statusLabel {
    if (owner.status.isEmpty) return owner.role;
    return owner.status[0].toUpperCase() + owner.status.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 18.h,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.4.h),
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
          children: [
            OwnerAvatar(owner: owner, size: 58),
            SizedBox(height: 1.h),
            SizedBox(
              height: 2.6.h,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  owner.name,
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
              ),
            ),
            SizedBox(height: 0.3.h),
            Text(
              _statusLabel,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: appTextStyle(
                context,
                fontSize: 8.8.sp,
                color: Colors.grey.shade500,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 2.h,
              child: owner.rating != null
                  ? Row(
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
                          owner.rating!.toStringAsFixed(1),
                          style: appTextStyle(
                            context,
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.goldBrandColor,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
