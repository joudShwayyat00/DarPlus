import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final bool seeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.seeAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: appTextStyle(
            context,
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
        ),

        if (seeAll)
          TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(10),
            foregroundColor: AppColors.goldBrandColor,
          ),
          child: Text(
            tr.see_all,
            // "See all",
            style: appTextStyle(
              context,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.goldBrandColor,
            ),
          ),
        ),
      ],
    );
  }
}
