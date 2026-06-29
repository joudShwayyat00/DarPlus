import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/features/booking/data/models/asset_calendar.dart';
import 'package:dar_plus_app/features/booking/presentation/providers/booking_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/assets/widgets/owner_availability_calendar.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_net_image.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class OwnerCalendarScreen extends ConsumerStatefulWidget {
  final AssetItem asset;

  const OwnerCalendarScreen({super.key, required this.asset});

  @override
  ConsumerState<OwnerCalendarScreen> createState() =>
      _OwnerCalendarScreenState();
}

class _OwnerCalendarScreenState extends ConsumerState<OwnerCalendarScreen> {
  OwnerCalendarAction _action = OwnerCalendarAction.block;
  Set<DateTime> _selectedDates = {};

  void _toggleDate(DateTime date) {
    final normalized = AssetCalendarData.normalize(date);
    setState(() {
      final updated = Set<DateTime>.from(_selectedDates);
      if (updated.any((d) => AssetCalendarData.normalize(d) == normalized)) {
        updated.removeWhere(
          (d) => AssetCalendarData.normalize(d) == normalized,
        );
      } else {
        updated.add(normalized);
      }
      _selectedDates = updated;
    });
  }

  void _removeDate(DateTime date) {
    final normalized = AssetCalendarData.normalize(date);
    setState(() {
      _selectedDates = Set<DateTime>.from(_selectedDates)
        ..removeWhere((d) => AssetCalendarData.normalize(d) == normalized);
    });
  }

  void _switchAction(OwnerCalendarAction action) {
    if (_action == action) return;
    setState(() {
      _action = action;
      _selectedDates = {};
    });
  }

  Future<void> _applyChanges() async {
    if (_selectedDates.isEmpty) return;

    EasyLoading.show();
    final error = await ref.read(ownerCalendarControllerProvider.notifier).submit(
      assetId: widget.asset.id,
      dates: _selectedDates.toList(),
      action: _action,
    );
    EasyLoading.dismiss();

    if (!mounted) return;

    if (error != null) {
      EasyLoading.showError(error);
      return;
    }

    EasyLoading.showSuccess(tr.calendar_updated_success);
    setState(() => _selectedDates = {});
  }

  List<DateTime> get _sortedSelectedDates {
    final dates = _selectedDates.toList()
      ..sort((a, b) => a.compareTo(b));
    return dates;
  }

  String _formatSelectedDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(ownerCalendarControllerProvider);
    final calendarAsync = ref.watch(assetCalendarProvider(widget.asset.id));
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Container(
            color: AppColors.whiteColor,
            padding: EdgeInsets.fromLTRB(2.w, topPadding + 0.8.h, 5.w, 1.2.h),
            child: Row(
              children: [
                const AppBackButton(),
                Expanded(
                  child: Text(
                    tr.manage_availability,
                    textAlign: TextAlign.center,
                    style: appTextStyle(
                      context,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withAlpha(230),
                    ),
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.goldBrandColor,
              onRefresh: () async {
                ref.invalidate(assetCalendarProvider(widget.asset.id));
                await ref.read(assetCalendarProvider(widget.asset.id).future);
              },
              child: ListView(
                padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.h),
                children: [
                  _AssetHeader(asset: widget.asset),
                  SizedBox(height: 2.h),
                  _ActionToggle(
                    action: _action,
                    onChanged: _switchAction,
                  ),
                  SizedBox(height: 2.h),
                  calendarAsync.when(
                    data: (calendar) => OwnerAvailabilityCalendar(
                      calendar: calendar,
                      action: _action,
                      selectedDates: _selectedDates,
                      onDayToggled: _toggleDate,
                    ),
                    loading: () => ShimmerPlaceholder(
                      width: double.infinity,
                      height: 36.h,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    error: (error, _) => _ErrorState(
                      message: error.toString(),
                      onRetry: () =>
                          ref.invalidate(assetCalendarProvider(widget.asset.id)),
                    ),
                  ),
                  if (_selectedDates.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    _SelectedDatesCard(
                      dates: _sortedSelectedDates,
                      action: _action,
                      formatDate: _formatSelectedDate,
                      onRemove: _removeDate,
                      onClear: () => setState(() => _selectedDates = {}),
                    ),
                  ],
                ],
              ),
            ),
          ),
          _BottomBar(
            selectedCount: _selectedDates.length,
            action: _action,
            onClear: _selectedDates.isEmpty
                ? null
                : () => setState(() => _selectedDates = {}),
            onApply: _selectedDates.isEmpty ? null : _applyChanges,
          ),
        ],
      ),
    );
  }
}

class _AssetHeader extends StatelessWidget {
  final AssetItem asset;

  const _AssetHeader({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withAlpha(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 18.w,
              height: 18.w,
              child: AppNetImage(url: asset.image),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: appTextStyle(
                    context,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withAlpha(230),
                  ),
                ),
                SizedBox(height: 0.4.h),
                Row(
                  children: [
                    Icon(
                      Icons.place_rounded,
                      size: 14,
                      color: Colors.black.withAlpha(120),
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        asset.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: appTextStyle(
                          context,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withAlpha(140),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedDatesCard extends StatelessWidget {
  final List<DateTime> dates;
  final OwnerCalendarAction action;
  final String Function(DateTime date) formatDate;
  final ValueChanged<DateTime> onRemove;
  final VoidCallback onClear;

  const _SelectedDatesCard({
    required this.dates,
    required this.action,
    required this.formatDate,
    required this.onRemove,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final actionLabel = action == OwnerCalendarAction.block
        ? tr.calendar_apply_block
        : tr.calendar_apply_unblock;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.goldBrandColor.withAlpha(14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tr.calendar_selected_dates,
                  style: appTextStyle(
                    context,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withAlpha(220),
                  ),
                ),
              ),
              TextButton(
                onPressed: onClear,
                child: Text(
                  tr.clear_dates,
                  style: appTextStyle(
                    context,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.goldBrandColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.6.h),
          Text(
            tr.calendar_dates_selected(dates.length),
            style: appTextStyle(
              context,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black.withAlpha(130),
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: dates.map((date) {
              return InputChip(
                label: Text(
                  formatDate(date),
                  style: appTextStyle(
                    context,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.goldBrandColor,
                  ),
                ),
                deleteIcon: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppColors.goldBrandColor,
                ),
                onDeleted: () => onRemove(date),
                backgroundColor: Colors.white,
                side: BorderSide(color: AppColors.goldBrandColor.withAlpha(90)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 0.8.h),
          Text(
            actionLabel,
            style: appTextStyle(
              context,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black.withAlpha(120),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionToggle extends StatelessWidget {
  final OwnerCalendarAction action;
  final ValueChanged<OwnerCalendarAction> onChanged;

  const _ActionToggle({
    required this.action,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          Expanded(
            child: _ToggleChip(
              label: tr.calendar_block_mode,
              icon: Icons.block_rounded,
              selected: action == OwnerCalendarAction.block,
              onTap: () => onChanged(OwnerCalendarAction.block),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: _ToggleChip(
              label: tr.calendar_unblock_mode,
              icon: Icons.event_available_rounded,
              selected: action == OwnerCalendarAction.unblock,
              onTap: () => onChanged(OwnerCalendarAction.unblock),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.goldBrandColor.withAlpha(30)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? AppColors.goldBrandColor
                    : Colors.black.withAlpha(120),
              ),
              SizedBox(width: 1.5.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: appTextStyle(
                    context,
                    fontSize: 9.sp,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected
                        ? AppColors.goldBrandColor
                        : Colors.black.withAlpha(160),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int selectedCount;
  final OwnerCalendarAction action;
  final VoidCallback? onClear;
  final VoidCallback? onApply;

  const _BottomBar({
    required this.selectedCount,
    required this.action,
    this.onClear,
    this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final applyLabel = action == OwnerCalendarAction.block
        ? tr.calendar_apply_block
        : tr.calendar_apply_unblock;

    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 2.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    tr.calendar_dates_selected(selectedCount),
                    style: appTextStyle(
                      context,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withAlpha(180),
                    ),
                  ),
                ),
                if (onClear != null)
                  TextButton(
                    onPressed: onClear,
                    child: Text(
                      tr.clear_dates,
                      style: appTextStyle(
                        context,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.goldBrandColor,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 0.8.h),
            AppButton(
              onPressed: onApply ?? () {},
              backgroundColor: onApply != null
                  ? AppColors.goldBrandColor
                  : Colors.black.withAlpha(40),
              child: Text(
                applyLabel,
                style: appTextStyle(
                  context,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          Icon(Icons.wifi_off_rounded, size: 40, color: Colors.black.withAlpha(100)),
          SizedBox(height: 1.5.h),
          Text(
            message.replaceFirst('Exception: ', ''),
            textAlign: TextAlign.center,
            style: appTextStyle(
              context,
              fontSize: 10.sp,
              color: Colors.black.withAlpha(140),
            ),
          ),
          SizedBox(height: 2.h),
          TextButton(onPressed: onRetry, child: Text(tr.try_again)),
        ],
      ),
    );
  }
}
