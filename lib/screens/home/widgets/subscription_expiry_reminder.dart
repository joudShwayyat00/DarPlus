import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/packages/data/models/subscription_status_response.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Home banner that reflects the current subscription status from the API.
class SubscriptionExpiryReminder extends StatelessWidget {
  final SubscriptionStatusResponse status;
  final VoidCallback onAction;
  final VoidCallback? onDismiss;

  const SubscriptionExpiryReminder({
    super.key,
    required this.status,
    required this.onAction,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final style = _ReminderStyle.fromStatus(status);

    return Padding(
      padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: style.gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: style.borderColor),
          boxShadow: [
            BoxShadow(
              color: style.borderColor.withAlpha(50),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                4.w,
                3.5.w,
                onDismiss != null ? 11.w : 4.w,
                3.5.w,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(2.8.w),
                    decoration: BoxDecoration(
                      color: style.iconBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      style.icon,
                      color: style.iconColor,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: 3.5.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                style.title,
                                style: appTextStyle(
                                  context,
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black.withAlpha(230),
                                ),
                              ),
                            ),
                            _StatusChip(
                              label: style.statusLabel,
                              color: style.iconColor,
                            ),
                          ],
                        ),
                        if (style.subtitle != null) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            style.subtitle!,
                            style: appTextStyle(
                              context,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: style.iconColor,
                            ),
                          ),
                        ],
                        if (status.message.isNotEmpty) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            status.message,
                            style: appTextStyle(
                              context,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withAlpha(120),
                              height: 1.35,
                            ),
                          ),
                        ],
                        SizedBox(height: 1.2.h),
                        TextButton(
                          onPressed: onAction,
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.5.w,
                              vertical: 0.8.h,
                            ),
                            backgroundColor: style.iconColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            style.actionLabel,
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
                top: 2.w,
                right: 2.w,
                child: Material(
                  color: Colors.white,
                  elevation: 2,
                  shadowColor: Colors.black26,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onDismiss,
                    customBorder: const CircleBorder(),
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Colors.black.withAlpha(180),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.2.w, vertical: 0.35.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        label,
        style: appTextStyle(
          context,
          fontSize: 8.sp,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _ReminderStyle {
  final String title;
  final String statusLabel;
  final String? subtitle;
  final String actionLabel;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Color borderColor;
  final List<Color> gradientColors;

  const _ReminderStyle({
    required this.title,
    required this.statusLabel,
    this.subtitle,
    required this.actionLabel,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.borderColor,
    required this.gradientColors,
  });

  factory _ReminderStyle.fromStatus(SubscriptionStatusResponse status) {
    if (status.isPending) {
      return _ReminderStyle(
        title: tr.subscription_status_banner_title,
        statusLabel: tr.subscription_status_pending,
        actionLabel: tr.my_subscriptions,
        icon: Icons.hourglass_top_rounded,
        iconColor: const Color(0xFF1565C0),
        iconBackground: const Color(0xFF1565C0).withAlpha(30),
        borderColor: const Color(0xFF1565C0).withAlpha(90),
        gradientColors: [
          const Color(0xFFE8F4FD),
          const Color(0xFF1565C0).withAlpha(20),
        ],
      );
    }

    if (status.isExpired) {
      return _ReminderStyle(
        title: tr.subscription_status_banner_title,
        statusLabel: tr.subscription_status_expired,
        actionLabel: tr.renew_now,
        icon: Icons.event_busy_rounded,
        iconColor: const Color(0xFFC0392B),
        iconBackground: const Color(0xFFC0392B).withAlpha(25),
        borderColor: const Color(0xFFC0392B).withAlpha(90),
        gradientColors: [
          const Color(0xFFFFF0EE),
          const Color(0xFFC0392B).withAlpha(18),
        ],
      );
    }

    if (status.isActive && status.isExpiringSoon) {
      return _ReminderStyle(
        title: tr.subscription_expiring_soon,
        statusLabel: tr.subscription_status_active,
        subtitle: status.daysRemaining == null
            ? null
            : tr.subscription_days_remaining(status.daysRemaining!),
        actionLabel: tr.renew_now,
        icon: Icons.timer_outlined,
        iconColor: AppColors.goldBrandColor,
        iconBackground: AppColors.goldBrandColor.withAlpha(30),
        borderColor: AppColors.goldBrandColor.withAlpha(90),
        gradientColors: [
          const Color(0xFFFFF8E8),
          AppColors.goldBrandColor.withAlpha(35),
        ],
      );
    }

    if (status.isHealthyActive) {
      return _ReminderStyle(
        title: tr.subscription_status_banner_title,
        statusLabel: tr.subscription_status_active,
        subtitle: status.daysRemaining == null
            ? null
            : tr.subscription_days_remaining(status.daysRemaining!),
        actionLabel: tr.my_subscriptions,
        icon: Icons.verified_rounded,
        iconColor: const Color(0xFF2E8B47),
        iconBackground: const Color(0xFF2E8B47).withAlpha(25),
        borderColor: const Color(0xFF2E8B47).withAlpha(80),
        gradientColors: [
          const Color(0xFFEEF9F1),
          const Color(0xFF2E8B47).withAlpha(18),
        ],
      );
    }

    return _ReminderStyle(
      title: tr.subscription_status_banner_title,
      statusLabel: tr.subscription_status_expired,
      actionLabel: tr.browse_plans,
      icon: Icons.workspace_premium_outlined,
      iconColor: AppColors.goldBrandColor,
      iconBackground: AppColors.goldBrandColor.withAlpha(25),
      borderColor: AppColors.goldBrandColor.withAlpha(90),
      gradientColors: [
        const Color(0xFFFFF8E8),
        AppColors.goldBrandColor.withAlpha(30),
      ],
    );
  }
}
