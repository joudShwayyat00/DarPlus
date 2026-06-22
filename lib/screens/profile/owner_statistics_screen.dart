import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/appointment/domain/appointment_status_filter.dart';
import 'package:dar_plus_app/features/appointment/presentation/providers/appointment_providers.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class OwnerStatisticsScreen extends ConsumerWidget {
  const OwnerStatisticsScreen({super.key});

  String _statusLabel(AppointmentStatusFilter status) {
    switch (status) {
      case AppointmentStatusFilter.pending:
        return tr.pending;
      case AppointmentStatusFilter.approved:
        return tr.approved;
      case AppointmentStatusFilter.rejected:
        return tr.rejected;
      case AppointmentStatusFilter.cancelled:
        return tr.cancelled;
    }
  }

  IconData _statusIcon(AppointmentStatusFilter status) {
    switch (status) {
      case AppointmentStatusFilter.pending:
        return Icons.hourglass_top_rounded;
      case AppointmentStatusFilter.approved:
        return Icons.verified_rounded;
      case AppointmentStatusFilter.rejected:
        return Icons.block_rounded;
      case AppointmentStatusFilter.cancelled:
        return Icons.cancel_outlined;
    }
  }

  Color _statusColor(AppointmentStatusFilter status) {
    switch (status) {
      case AppointmentStatusFilter.pending:
        return AppColors.goldBrandColor;
      case AppointmentStatusFilter.approved:
        return const Color(0xFF2E7D32);
      case AppointmentStatusFilter.rejected:
        return const Color(0xFFC62828);
      case AppointmentStatusFilter.cancelled:
        return Colors.black.withAlpha(140);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(myAssetsControllerProvider);
    final appointmentsAsync = ref.watch(ownerAllAppointmentsProvider);

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
          tr.my_statistics,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.goldBrandColor,
        onRefresh: () async {
          ref.invalidate(myAssetsControllerProvider);
          ref.invalidate(ownerAllAppointmentsProvider);
        },
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
              SizedBox(height: 1.5.h),
              assetsAsync.when(
                data: (assets) {
                  final saleCount =
                      assets.where((a) => a.isForSale).length;
                  final rentCount = assets.length - saleCount;

                  return appointmentsAsync.when(
                    data: (appointments) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _OverviewCard(
                                  icon: Icons.home_work_rounded,
                                  label: tr.total_properties,
                                  value: '${assets.length}',
                                  color: const Color(0xFF1B6B2F),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: _OverviewCard(
                                  icon: Icons.event_available_rounded,
                                  label: tr.total_appointment_requests,
                                  value: '${appointments.length}',
                                  color: const Color(0xFF1565C0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.5.h),
                          Row(
                            children: [
                              Expanded(
                                child: _OverviewCard(
                                  icon: Icons.sell_rounded,
                                  label: tr.for_sale_properties,
                                  value: '$saleCount',
                                  color: const Color(0xFF6A4C93),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: _OverviewCard(
                                  icon: Icons.key_rounded,
                                  label: tr.for_rent_properties,
                                  value: '$rentCount',
                                  color: AppColors.goldBrandColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.5.h),
                          Text(
                            tr.owner_property_appointments,
                            style: appTextStyle(
                              context,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.black.withAlpha(230),
                            ),
                          ),
                          SizedBox(height: 1.2.h),
                          ...AppointmentStatusFilter.values.map((status) {
                            final count = appointments
                                .where(
                                  (a) =>
                                      a.status.toLowerCase() ==
                                      status.apiValue,
                                )
                                .length;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 1.h),
                              child: _StatusRow(
                                icon: _statusIcon(status),
                                label: _statusLabel(status),
                                value: '$count',
                                color: _statusColor(status),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(
                          color: AppColors.goldBrandColor,
                        ),
                      ),
                    ),
                    error: (_, __) => _errorState(context, ref),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(
                      color: AppColors.goldBrandColor,
                    ),
                  ),
                ),
                error: (_, __) => _errorState(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          Text(tr.error_occurred),
          SizedBox(height: 1.5.h),
          TextButton(
            onPressed: () {
              ref.invalidate(myAssetsControllerProvider);
              ref.invalidate(ownerAllAppointmentsProvider);
            },
            child: Text(tr.try_again),
          ),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _OverviewCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          SizedBox(height: 1.2.h),
          Text(
            value,
            style: appTextStyle(
              context,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(230),
            ),
          ),
          SizedBox(height: 0.3.h),
          Text(
            label,
            style: appTextStyle(
              context,
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black.withAlpha(120),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatusRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(8)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withAlpha(22),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              label,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black.withAlpha(200),
              ),
            ),
          ),
          Text(
            value,
            style: appTextStyle(
              context,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
