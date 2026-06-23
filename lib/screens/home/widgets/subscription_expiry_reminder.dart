import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// UI-only reminder banner. Replace [daysRemaining] with API data later.
class SubscriptionExpiryReminder extends StatelessWidget {
  final int daysRemaining;
  final VoidCallback onRenew;
  final VoidCallback? onDismiss;

  const SubscriptionExpiryReminder({
    super.key,
    required this.daysRemaining,
    required this.onRenew,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFF8E8),
              AppColors.goldBrandColor.withAlpha(35),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.goldBrandColor.withAlpha(90)),
          boxShadow: [
            BoxShadow(
              color: AppColors.goldBrandColor.withAlpha(35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 3.5.w, 4.w, 3.5.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(2.8.w),
                    decoration: BoxDecoration(
                      color: AppColors.goldBrandColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.event_busy_rounded,
                      color: AppColors.goldBrandColor,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: 3.5.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr.subscription_expiring_soon,
                          style: appTextStyle(
                            context,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.black.withAlpha(230),
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          tr.subscription_days_remaining(daysRemaining),
                          style: appTextStyle(
                            context,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.goldBrandColor,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          tr.subscription_renew_message,
                          style: appTextStyle(
                            context,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withAlpha(120),
                            height: 1.35,
                          ),
                        ),
                        SizedBox(height: 1.2.h),
                        TextButton(
                          onPressed: onRenew,
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.5.w,
                              vertical: 0.8.h,
                            ),
                            backgroundColor: AppColors.goldBrandColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            tr.renew_now,
                            style: appTextStyle(
                              context,
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (onDismiss != null)
              Positioned(
                top: 0.5.h,
                right: 1.w,
                child: IconButton(
                  onPressed: onDismiss,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Colors.black.withAlpha(100),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
