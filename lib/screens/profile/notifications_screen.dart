import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/notifications/data/models/notification_item.dart';
import 'package:dar_plus_app/features/notifications/presentation/providers/notifications_providers.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/auth/login_screen.dart';
import 'package:dar_plus_app/screens/auth/sign_up_screen.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: kAppBarBackLeadingWidth,
        leading: const AppBarBackButton(),
        title: Text(
          tr.notifications,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: true,
      ),
      body: !isLoggedIn
          ? const _NotificationsGuestView()
          : ref.watch(notificationsControllerProvider).when(
              data: (notifications) =>
                  _buildDataState(context, ref, notifications),
              loading: () => _buildLoadingState(),
              error: (error, _) => _buildErrorState(context, ref),
            ),
    );
  }

  Future<void> _onRefresh(WidgetRef ref) async {
    await ref.read(notificationsControllerProvider.notifier).refresh();
  }

  Widget _buildDataState(
    BuildContext context,
    WidgetRef ref,
    List<NotificationItem> notifications,
  ) {
    if (notifications.isEmpty) {
      return RefreshIndicator(
        color: AppColors.goldBrandColor,
        onRefresh: () => _onRefresh(ref),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: _buildEmptyState(context),
              ),
            );
          },
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.goldBrandColor,
      onRefresh: () => _onRefresh(ref),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(context, notifications[index]);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(AppColors.goldBrandColor),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.goldBrandColor.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 52,
                color: AppColors.goldBrandColor.withAlpha(180),
              ),
            ),
            SizedBox(height: 2.5.h),
            Text(
              tr.no_notifications_yet,
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black.withAlpha(200),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              tr.will_notify_when_something_arrives,
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(100),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: Colors.red.withAlpha(180),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              tr.error_occurred,
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black.withAlpha(200),
              ),
            ),
            SizedBox(height: 2.h),
            GestureDetector(
              onTap: () => _onRefresh(ref),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.4.h),
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldBrandColor.withAlpha(60),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem item) {
    final iconData = _resolveIcon(item.icon);

    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              color: AppColors.goldBrandColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconData,
              size: 20,
              color: AppColors.goldBrandColor,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.body,
                  style: appTextStyle(
                    context,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withAlpha(220),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  item.createdAt,
                  style: appTextStyle(
                    context,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withAlpha(80),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _resolveIcon(String icon) {
    final normalized = icon.toLowerCase();

    if (normalized.contains('calendar')) {
      return Icons.calendar_today_rounded;
    }
    if (normalized.contains('payment') || normalized.contains('cash')) {
      return Icons.payment_rounded;
    }
    if (normalized.contains('star') || normalized.contains('review')) {
      return Icons.star_rounded;
    }
    if (normalized.contains('home') || normalized.contains('house')) {
      return Icons.home_rounded;
    }
    if (normalized.contains('offer') || normalized.contains('tag')) {
      return Icons.local_offer_rounded;
    }
    if (normalized.contains('airballoon') || normalized.contains('balloon')) {
      return Icons.celebration_rounded;
    }

    return Icons.notifications_outlined;
  }
}

class _NotificationsGuestView extends StatelessWidget {
  const _NotificationsGuestView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8F7F4),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.goldBrandColor.withAlpha(18),
                  ),
                ),
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.goldBrandColor.withAlpha(45),
                        AppColors.goldBrandColor.withAlpha(15),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.goldBrandColor.withAlpha(55),
                    ),
                  ),
                  child: Icon(
                    Icons.notifications_active_outlined,
                    size: 42,
                    color: AppColors.goldBrandColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.8.h),
            Text(
              tr.sign_in_to_continue,
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(230),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              tr.login_required_notifications,
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(120),
                height: 1.5,
              ),
            ),
            SizedBox(height: 3.h),
            _GuestFeatureTile(
              icon: Icons.mark_email_unread_outlined,
              text: tr.login_required_notifications,
            ),
            SizedBox(height: 3.5.h),
            AppButton(
              backgroundColor: AppColors.goldBrandColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: Text(
                tr.login,
                style: appTextStyle(
                  context,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 1.2.h),
            AppButton(
              backgroundColor: Colors.transparent,
              borderColor: AppColors.goldBrandColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                );
              },
              child: Text(
                tr.create_account,
                style: appTextStyle(
                  context,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.goldBrandColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestFeatureTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const _GuestFeatureTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              color: AppColors.goldBrandColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.goldBrandColor),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: appTextStyle(
                context,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(170),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
