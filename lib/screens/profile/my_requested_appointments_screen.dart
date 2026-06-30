import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/controller/local_provider.dart';
import 'package:dar_plus_app/features/appointment/data/models/my_appointment_item.dart';
import 'package:dar_plus_app/features/appointment/domain/appointment_status_filter.dart';
import 'package:dar_plus_app/features/appointment/presentation/providers/appointment_providers.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/asset_details/asset_details_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_net_image.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/appointment_sheet.dart';
import 'package:dar_plus_app/utils/widgets/login_required_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class MyRequestedAppointmentsScreen extends ConsumerStatefulWidget {
  const MyRequestedAppointmentsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  ConsumerState<MyRequestedAppointmentsScreen> createState() =>
      _MyRequestedAppointmentsScreenState();
}

class _MyRequestedAppointmentsScreenState
    extends ConsumerState<MyRequestedAppointmentsScreen> {
  AppointmentStatusFilter _selectedStatus = AppointmentStatusFilter.pending;

  Future<void> _onRefresh() async {
    await ref.read(myRequestedAppointmentsControllerProvider.notifier).refresh();
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

  List<MyAppointmentItem> _filterByStatus(List<MyAppointmentItem> items) {
    return items
        .where((item) => item.status.toLowerCase() == _selectedStatus.apiValue)
        .toList();
  }

  Future<void> _confirmDelete(MyAppointmentItem appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          tr.delete_appointment,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: Colors.red,
          ),
        ),
        content: Text(
          tr.delete_appointment_confirm,
          style: appTextStyle(
            context,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withAlpha(160),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              tr.cancel,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black.withAlpha(150),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              tr.delete,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final message = await ref
          .read(myRequestedAppointmentsControllerProvider.notifier)
          .deleteAppointment(appointment.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.black.withAlpha(220),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _editAppointment(MyAppointmentItem appointment) async {
    final assetName = appointment.asset?.displayName(
          ref.read(apiLanguageCodeProvider),
        ) ??
        tr.view_property;
    await showEditAppointmentSheet(
      context,
      appointment: appointment,
      assetName: assetName,
    );
    if (mounted) {
      await _onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    if (!isLoggedIn) {
      return _buildShell(
        body: LoginRequiredView(
          icon: Icons.event_available_rounded,
          title: tr.sign_in_to_continue,
          message: tr.login_required_my_appointments,
        ),
      );
    }

    final appointmentsAsync = ref.watch(myRequestedAppointmentsControllerProvider);

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.embedded)
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 1.2.h),
            child: Text(
              tr.my_requested_appointments_subtitle,
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
            data: (appointments) =>
                _buildDataState(_filterByStatus(appointments)),
            loading: () => _buildLoadingState(),
            error: (_, __) => _buildErrorState(),
          ),
        ),
      ],
    );

    if (widget.embedded) return body;
    return _buildShell(body: body);
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
          tr.my_appointments,
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
                padding:
                    EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 1.1.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.goldBrandColor : Colors.white,
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
                      color:
                          isSelected ? Colors.white : AppColors.goldBrandColor,
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
          final appointment = appointments[index];
          final isPending =
              appointment.status.toLowerCase() == 'pending';
          return _RequestedAppointmentCard(
            appointment: appointment,
            formatDate: _formatDate,
            formatTime: _formatTime,
            onEdit: isPending ? () => _editAppointment(appointment) : null,
            onDelete: isPending ? () => _confirmDelete(appointment) : null,
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

class _RequestedAppointmentCard extends ConsumerWidget {
  final MyAppointmentItem appointment;
  final String Function(String) formatDate;
  final String Function(String) formatTime;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _RequestedAppointmentCard({
    required this.appointment,
    required this.formatDate,
    required this.formatTime,
    this.onEdit,
    this.onDelete,
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
          Padding(
            padding: EdgeInsets.fromLTRB(4.5.w, 2.h, 4.5.w, 0.4.h),
            child: Row(
              children: [
                Icon(
                  Icons.event_available_rounded,
                  size: 18,
                  color: AppColors.goldBrandColor,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    '${formatDate(appointment.date)} · ${formatTime(appointment.time)}',
                    style: appTextStyle(
                      context,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withAlpha(200),
                    ),
                  ),
                ),
                if (asset == null)
                  _StatusBadge(status: appointment.status, color: statusColor),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(4.5.w, 1.2.h, 4.5.w, 2.2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appointment.note != null &&
                    appointment.note!.trim().isNotEmpty) ...[
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
                  SizedBox(height: 1.4.h),
                ],
                if (onEdit != null || onDelete != null)
                  Row(
                    children: [
                      if (onEdit != null)
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.edit_rounded,
                            label: tr.edit,
                            color: AppColors.goldBrandColor,
                            onTap: onEdit!,
                          ),
                        ),
                      if (onEdit != null && onDelete != null)
                        SizedBox(width: 2.5.w),
                      if (onDelete != null)
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.delete_outline_rounded,
                            label: tr.delete,
                            color: Colors.red.shade600,
                            onTap: onDelete!,
                          ),
                        ),
                    ],
                  )
                else
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.3.h),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            SizedBox(width: 1.5.w),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: appTextStyle(
                  context,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
