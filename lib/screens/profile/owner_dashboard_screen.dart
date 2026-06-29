import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/appointment/domain/appointment_status_filter.dart';
import 'package:dar_plus_app/features/appointment/presentation/providers/appointment_providers.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/assets/add_asset_screen.dart';
import 'package:dar_plus_app/screens/assets/my_assets_screen.dart';
import 'package:dar_plus_app/screens/profile/my_appointments_screen.dart';
import 'package:dar_plus_app/screens/profile/owner_statistics_screen.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/login_required_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  Future<void> _onRefresh(WidgetRef ref) async {
    ref.invalidate(myAssetsControllerProvider);
    for (final status in AppointmentStatusFilter.values) {
      ref.invalidate(myAppointmentsControllerProvider(status));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final user = ref.watch(profileControllerProvider).value;
    final isOwner = user?.isOwner == true;

    if (!isLoggedIn) {
      return _shell(
        context,
        body: LoginRequiredView(
          icon: Icons.dashboard_rounded,
          title: tr.sign_in_to_continue,
          message: tr.owner_required_appointments,
        ),
      );
    }

    if (!isOwner) {
      return _shell(
        context,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.apartment_rounded,
                  size: 52,
                  color: AppColors.goldBrandColor.withAlpha(180),
                ),
                SizedBox(height: 2.h),
                Text(
                  tr.my_dashboard,
                  style: appTextStyle(
                    context,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withAlpha(200),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  tr.owner_required_appointments,
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
        ),
      );
    }

    final pendingAsync = ref.watch(
      myAppointmentsControllerProvider(AppointmentStatusFilter.pending),
    );

    final pendingCount = pendingAsync.maybeWhen(
      data: (items) => items.length,
      orElse: () => 0,
    );

    return _shell(
      context,
      body: RefreshIndicator(
        color: AppColors.goldBrandColor,
        onRefresh: () => _onRefresh(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WelcomeCard(name: user?.name ?? ''),
              SizedBox(height: 2.5.h),
              Text(
                tr.quick_actions,
                style: appTextStyle(
                  context,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withAlpha(230),
                ),
              ),
              SizedBox(height: 1.2.h),
              _DashboardTile(
                icon: Icons.apartment_rounded,
                title: tr.my_assets,
                subtitle: tr.manage_properties,
                gradient: const [Color(0xFF1B6B2F), Color(0xFF2E8B47)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyAssetsScreen()),
                ),
              ),
              SizedBox(height: 1.2.h),
              _DashboardTile(
                icon: Icons.add_home_work_rounded,
                title: tr.add_new_property,
                subtitle: tr.publish_asset,
                gradient: const [Color(0xFFB8860B), Color(0xFFD4A017)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddAssetScreen()),
                ),
              ),
              SizedBox(height: 1.2.h),
              _DashboardTile(
                icon: Icons.calendar_month_rounded,
                title: tr.owner_property_appointments,
                subtitle: tr.view_incoming_requests,
                gradient: const [Color(0xFF6A4C93), Color(0xFF8E6BB8)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyAppointmentsScreen(),
                  ),
                ),
                badge: pendingCount > 0 ? '$pendingCount' : null,
              ),
              SizedBox(height: 1.2.h),
              _DashboardTile(
                icon: Icons.bar_chart_rounded,
                title: tr.my_statistics,
                subtitle: tr.statistics_overview,
                gradient: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OwnerStatisticsScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shell(BuildContext context, {required Widget body}) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F4),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black.withAlpha(200),
            size: 20,
          ),
        ),
        title: Text(
          tr.my_dashboard,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
      ),
      body: body,
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final String name;

  const _WelcomeCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.goldBrandColor,
            AppColors.goldBrandColor.withAlpha(200),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldBrandColor.withAlpha(70),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.5.w),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.my_dashboard,
                  style: appTextStyle(
                    context,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  name.isNotEmpty ? name : tr.my_dashboard_subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: appTextStyle(
                    context,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withAlpha(220),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;
  final String? badge;

  const _DashboardTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: appTextStyle(
                          context,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black.withAlpha(230),
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        subtitle,
                        style: appTextStyle(
                          context,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withAlpha(110),
                        ),
                      ),
                    ],
                  ),
                ),
                if (badge != null)
                  Container(
                    margin: EdgeInsets.only(right: 2.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.5.w,
                      vertical: 0.4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.goldBrandColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge!,
                      style: appTextStyle(
                        context,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black.withAlpha(80),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
