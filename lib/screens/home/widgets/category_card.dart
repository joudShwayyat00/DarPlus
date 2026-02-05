import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CategoryBox extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryBox({
    super.key,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashColor: AppColors.goldBrandColor.withAlpha(35),
        highlightColor: AppColors.goldBrandColor.withAlpha(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin:  EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: 1.15.h),
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: isSelected
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.goldBrandColor.withAlpha(40),
                AppColors.goldBrandColor.withAlpha(16),
              ],
            )
                : null,
            color: isSelected ? null : Colors.white,
            border: Border.all(
              color: isSelected
                  ? AppColors.goldBrandColor.withAlpha(140)
                  : Colors.black.withAlpha(18),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isSelected ? 18 : 10),
                blurRadius: isSelected ? 14 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: isSelected ? 6 : 0,
                height: isSelected ? 6 : 0,
                margin: EdgeInsets.only(right: isSelected ? 2.w : 0),
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor,
                  shape: BoxShape.circle,
                ),
              ),

              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 42.w),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: appTextStyle(
                    context,
                    fontSize: 10.8.sp,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.goldBrandColor
                        : AppColors.blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
