import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/features/owners/data/models/owner_statistics_response.dart';
import 'package:dar_plus_app/features/owners/presentation/providers/owners_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/login_required_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class OwnerStatisticsScreen extends ConsumerWidget {
  const OwnerStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final isOwner = ref.watch(profileControllerProvider).value?.isOwner == true;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F4),
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: kAppBarBackLeadingWidth,
        leading: const AppBarBackButton(),
        title: Text(
          tr.my_statistics,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
      ),
      body: !isLoggedIn
          ? LoginRequiredView(
              icon: Icons.insights_rounded,
              title: tr.sign_in_to_continue,
              message: tr.owner_required_appointments,
            )
          : !isOwner
              ? _buildOwnerRequired(context)
              : ref.watch(ownerStatisticsControllerProvider).when(
                    data: (stats) => _StatisticsBody(stats: stats),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.goldBrandColor,
                      ),
                    ),
                    error: (_, __) => _StatisticsError(
                      onRetry: () => ref
                          .read(ownerStatisticsControllerProvider.notifier)
                          .refresh(),
                    ),
                  ),
    );
  }

  Widget _buildOwnerRequired(BuildContext context) {
    return Center(
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
              tr.my_statistics,
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
    );
  }
}

class _StatisticsBody extends ConsumerWidget {
  final OwnerStatisticsData stats;

  const _StatisticsBody({required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.goldBrandColor,
      onRefresh: () =>
          ref.read(ownerStatisticsControllerProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(5.w, 0.5.h, 5.w, 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.statistics_overview,
              style: appTextStyle(
                context,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(110),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _HighlightCard(
                    icon: Icons.payments_rounded,
                    label: tr.statistics_total_revenue,
                    value: formatPrice(stats.revenue.total),
                    gradient: const [Color(0xFFB8860B), Color(0xFFD4A017)],
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _HighlightCard(
                    icon: Icons.star_rounded,
                    label: tr.statistics_avg_rating,
                    value: stats.avgRating.toStringAsFixed(1),
                    gradient: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.2.h),
            _SectionCard(
              title: tr.statistics_properties_section,
              icon: Icons.apartment_rounded,
              iconColor: const Color(0xFF2E8B47),
              children: [
                _StatTile(
                  label: tr.total_properties,
                  value: '${stats.assets.total}',
                  icon: Icons.home_work_rounded,
                ),
                _StatTile(
                  label: tr.statistics_available_properties,
                  value: '${stats.assets.available}',
                  icon: Icons.check_circle_outline_rounded,
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            _SectionCard(
              title: tr.statistics_bookings_section,
              icon: Icons.bookmark_rounded,
              iconColor: AppColors.goldBrandColor,
              children: [
                _StatTile(
                  label: tr.statistics_total_bookings,
                  value: '${stats.bookings.total}',
                  icon: Icons.calendar_month_rounded,
                ),
                _StatTile(
                  label: tr.pending,
                  value: '${stats.bookings.pending}',
                  icon: Icons.hourglass_top_rounded,
                ),
                _StatTile(
                  label: tr.approved,
                  value: '${stats.bookings.approved}',
                  icon: Icons.verified_rounded,
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            _SectionCard(
              title: tr.statistics_appointments_section,
              icon: Icons.event_available_rounded,
              iconColor: const Color(0xFF6A4C93),
              children: [
                _StatTile(
                  label: tr.total_appointment_requests,
                  value: '${stats.appointments.total}',
                  icon: Icons.event_note_rounded,
                ),
                _StatTile(
                  label: tr.pending_requests,
                  value: '${stats.appointments.pending}',
                  icon: Icons.pending_actions_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<Color> gradient;

  const _HighlightCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withAlpha(70),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(35),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          SizedBox(height: 1.6.h),
          Text(
            label,
            style: appTextStyle(
              context,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withAlpha(220),
            ),
          ),
          SizedBox(height: 0.4.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: appTextStyle(
              context,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withAlpha(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.5.w),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              SizedBox(width: 3.w),
              Text(
                title,
                style: appTextStyle(
                  context,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withAlpha(220),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.6.h),
          ...children,
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.1.h),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.goldBrandColor),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              label,
              style: appTextStyle(
                context,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(150),
              ),
            ),
          ),
          Text(
            value,
            style: appTextStyle(
              context,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(220),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsError extends StatelessWidget {
  final VoidCallback onRetry;

  const _StatisticsError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: Colors.red.withAlpha(180),
            ),
            SizedBox(height: 2.h),
            Text(
              tr.error_occurred,
              style: appTextStyle(
                context,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black.withAlpha(200),
              ),
            ),
            SizedBox(height: 2.h),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.4.h),
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
        ),
      ),
    );
  }
}
