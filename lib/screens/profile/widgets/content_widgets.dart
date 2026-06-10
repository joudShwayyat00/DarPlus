import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sizer/sizer.dart';

/// A card used consistently across About, Terms & Privacy screens.
class ContentCard extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final Widget child;

  const ContentCard({super.key, this.icon, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(7),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor.withAlpha(15),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.goldBrandColor.withAlpha(40),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: AppColors.goldBrandColor, size: 18),
                      SizedBox(width: 2.w),
                    ],
                    Expanded(
                      child: Text(
                        title!,
                        style: appTextStyle(
                          context,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black.withAlpha(220),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class ContentErrorRetry extends StatelessWidget {
  final VoidCallback onRetry;

  const ContentErrorRetry({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.wifi_off_rounded,
          size: 48,
          color: Colors.black.withAlpha(60),
        ),
        SizedBox(height: 1.5.h),
        Text(
          tr.error_occurred,
          style: appTextStyle(
            context,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withAlpha(120),
          ),
        ),
        SizedBox(height: 1.5.h),
        GestureDetector(
          onTap: onRetry,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.2.h),
            decoration: BoxDecoration(
              color: AppColors.goldBrandColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              tr.try_again,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Renders HTML content with consistent typography.
class HtmlBody extends StatelessWidget {
  final String html;

  const HtmlBody({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      style: {
        'body': Style(
          fontSize: FontSize(10.5.sp),
          color: Colors.black.withAlpha(150),
          lineHeight: const LineHeight(1.7),
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        'p': Style(margin: Margins.only(top: 4, bottom: 4)),
      },
    );
  }
}
