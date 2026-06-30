import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/controller/local_provider.dart';
import 'package:dar_plus_app/features/appointment/data/models/my_appointment_item.dart';
import 'package:dar_plus_app/features/appointment/domain/appointment_status_filter.dart';
import 'package:dar_plus_app/features/appointment/presentation/providers/appointment_providers.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/asset_details/asset_details_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/helpers/external_link_launcher.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_net_image.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/login_required_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class MyAppointmentsScreen extends ConsumerStatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  ConsumerState<MyAppointmentsScreen> createState() =>
      _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends ConsumerState<MyAppointmentsScreen> {
  AppointmentStatusFilter _selectedStatus = AppointmentStatusFilter.pending;

  Future<void> _onRefresh() async {
    await ref
        .read(ownerAppointmentsControllerProvider(_selectedStatus).notifier)
        .refresh();
  }

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

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return isoDate;
    }
  }

  String _formatTime(String rawTime) {
    try {
      final parts = rawTime.split(':');
      if (parts.length < 2) return rawTime;
      var hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      return '$hour:$minute $period';
    } catch (_) {
      return rawTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final user = ref.watch(profileControllerProvider).value;
    final isOwner = user?.isOwner == true;

    if (!isLoggedIn) {
      return _buildShell(
        body: LoginRequiredView(
          icon: Icons.event_available_rounded,
          title: tr.sign_in_to_continue,
          message: tr.login_required_appointment,
        ),
      );
    }

    if (!isOwner) {
      return _buildShell(
        body: _buildOwnerRequiredState(),
      );
    }

    final appointmentsAsync =
        ref.watch(ownerAppointmentsControllerProvider(_selectedStatus));

    return _buildShell(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 1.2.h),
            child: Text(
              tr.owner_property_appointments_subtitle,
              style: appTextStyle(
                context,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(110),
              ),
            ),
          ),
          _buildStatusFilters(),
          Expanded(
            child: appointmentsAsync.when(
              data: (appointments) => _buildDataState(appointments),
              loading: () => _buildLoadingState(),
              error: (_, __) => _buildErrorState(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShell({required Widget body}) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F4),
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: kAppBarBackLeadingWidth,
        leading: const AppBarBackButton(),
        title: Text(
          tr.owner_property_appointments,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: false,
      ),
      body: body,
    );
  }

  Widget _buildOwnerRequiredState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                Icons.apartment_rounded,
                size: 52,
                color: AppColors.goldBrandColor.withAlpha(180),
              ),
            ),
            SizedBox(height: 2.5.h),
            Text(
              tr.owner_property_appointments,
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

  Widget _buildStatusFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 1.5.h),
      child: Row(
        children: AppointmentStatusFilter.values.map((status) {
          final isSelected = _selectedStatus == status;
          return Padding(
            padding: EdgeInsets.only(right: 2.5.w),
            child: GestureDetector(
              onTap: () => setState(() => _selectedStatus = status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 1.1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.goldBrandColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.goldBrandColor
                        : Colors.black.withAlpha(18),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.goldBrandColor.withAlpha(70),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withAlpha(6),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _statusIcon(status),
                      size: 15,
                      color: isSelected
                          ? Colors.white
                          : AppColors.goldBrandColor,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _statusLabel(status),
                      style: appTextStyle(
                        context,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : Colors.black.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
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

  Widget _buildDataState(List<MyAppointmentItem> appointments) {
    if (appointments.isEmpty) {
      return RefreshIndicator(
        color: AppColors.goldBrandColor,
        onRefresh: _onRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: _buildEmptyState(),
              ),
            );
          },
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.goldBrandColor,
      onRefresh: _onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(5.w, 0.5.h, 5.w, 2.h),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return _AppointmentCard(
            appointment: appointments[index],
            formatDate: _formatDate,
            formatTime: _formatTime,
          );
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                Icons.event_busy_rounded,
                size: 52,
                color: AppColors.goldBrandColor.withAlpha(180),
              ),
            ),
            SizedBox(height: 2.5.h),
            Text(
              tr.no_appointments_found,
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
              tr.no_appointments_for_status(_statusLabel(_selectedStatus)),
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

  Widget _buildErrorState() {
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
              onTap: _onRefresh,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.4.h),
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
}

class _AppointmentCard extends ConsumerWidget {
  final MyAppointmentItem appointment;
  final String Function(String) formatDate;
  final String Function(String) formatTime;

  const _AppointmentCard({
    required this.appointment,
    required this.formatDate,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(appointment.status);
    final asset = appointment.asset;
    final lang = ref.watch(apiLanguageCodeProvider);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withAlpha(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (asset != null)
            GestureDetector(
              onTap: () {
                AppNavigator.of(context).push(
                  AssetDetailsScreen(assetId: asset.id),
                );
              },
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(22)),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 15.h,
                      width: double.infinity,
                      child: asset.resolvedImageUrl.isNotEmpty
                          ? AppNetImage(url: asset.resolvedImageUrl)
                          : Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.home_work_outlined,
                                size: 42,
                                color: Colors.grey.shade400,
                              ),
                            ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(150),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1.2.h,
                      right: 3.w,
                      child: _StatusBadge(
                        status: appointment.status,
                        color: statusColor,
                      ),
                    ),
                    Positioned(
                      left: 4.w,
                      right: 4.w,
                      bottom: 1.4.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            asset.displayName(lang),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: appTextStyle(
                              context,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          if (asset.location.trim().isNotEmpty) ...[
                            SizedBox(height: 0.3.h),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                SizedBox(width: 1.w),
                                Expanded(
                                  child: Text(
                                    asset.location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: appTextStyle(
                                      context,
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withAlpha(220),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(4.5.w, 2.h, 4.5.w, 2.2.h),
            decoration: BoxDecoration(
              gradient: asset == null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.goldBrandColor.withAlpha(28),
                        AppColors.goldBrandColor.withAlpha(8),
                      ],
                    )
                  : null,
              borderRadius: asset == null
                  ? const BorderRadius.vertical(top: Radius.circular(22))
                  : null,
            ),
            child: Row(
              children: [
                if (asset == null)
                  Container(
                    padding: EdgeInsets.all(3.5.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldBrandColor.withAlpha(40),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.goldBrandColor,
                      size: 26,
                    ),
                  ),
                if (asset == null) SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr.scheduled_visit,
                        style: appTextStyle(
                          context,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withAlpha(120),
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        formatDate(appointment.date),
                        style: appTextStyle(
                          context,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black.withAlpha(230),
                        ),
                      ),
                      Text(
                        formatTime(appointment.time),
                        style: appTextStyle(
                          context,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.goldBrandColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (asset == null)
                  _StatusBadge(status: appointment.status, color: statusColor),
              ],
            ),
          ),
          if (asset != null)
            Padding(
              padding: EdgeInsets.fromLTRB(4.5.w, 0, 4.5.w, 0.4.h),
              child: Row(
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    size: 18,
                    color: AppColors.goldBrandColor,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '${formatDate(appointment.date)} · ${formatTime(appointment.time)}',
                    style: appTextStyle(
                      context,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withAlpha(200),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(4.5.w, 2.h, 4.5.w, 2.2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.requested_by,
                  style: appTextStyle(
                    context,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withAlpha(100),
                  ),
                ),
                SizedBox(height: 1.2.h),
                _VisitorRow(
                  icon: Icons.person_rounded,
                  label: appointment.name,
                ),
                SizedBox(height: 0.8.h),
                _VisitorRow(
                  icon: Icons.phone_rounded,
                  label: appointment.phone,
                  onTap: () => launchPhoneCall(appointment.phone),
                ),
                SizedBox(height: 0.8.h),
                _VisitorRow(
                  icon: Icons.email_rounded,
                  label: appointment.email,
                  onTap: () => launchEmail(appointment.email),
                ),
                if (appointment.note != null &&
                    appointment.note!.trim().isNotEmpty) ...[
                  SizedBox(height: 1.6.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.5.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F7F4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black.withAlpha(8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr.notes,
                          style: appTextStyle(
                            context,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withAlpha(100),
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          appointment.note!,
                          style: appTextStyle(
                            context,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withAlpha(180),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 1.8.h),
                GestureDetector(
                  onTap: () {
                    AppNavigator.of(context).push(
                      AssetDetailsScreen(assetId: appointment.assetId),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 1.4.h),
                    decoration: BoxDecoration(
                      color: AppColors.goldBrandColor.withAlpha(18),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.goldBrandColor.withAlpha(60),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_work_rounded,
                          size: 18,
                          color: AppColors.goldBrandColor,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          tr.view_property,
                          style: appTextStyle(
                            context,
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.goldBrandColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFF2E7D32);
      case 'rejected':
        return const Color(0xFFC62828);
      case 'cancelled':
        return Colors.black.withAlpha(120);
      default:
        return AppColors.goldBrandColor;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: appTextStyle(
          context,
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _VisitorRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _VisitorRow({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.goldBrandColor),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              label,
              style: appTextStyle(
                context,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: onTap != null
                    ? AppColors.goldBrandColor
                    : Colors.black.withAlpha(200),
              ),
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.open_in_new_rounded,
              size: 14,
              color: AppColors.goldBrandColor.withAlpha(160),
            ),
        ],
      ),
    );
  }
}
