import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/booking/data/models/asset_calendar.dart';
import 'package:dar_plus_app/features/booking/presentation/providers/booking_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OwnerAvailabilityCalendar extends StatefulWidget {
  final AssetCalendarData calendar;
  final OwnerCalendarAction action;
  final Set<DateTime> selectedDates;
  final ValueChanged<DateTime> onDayToggled;

  const OwnerAvailabilityCalendar({
    super.key,
    required this.calendar,
    required this.action,
    required this.selectedDates,
    required this.onDayToggled,
  });

  @override
  State<OwnerAvailabilityCalendar> createState() =>
      _OwnerAvailabilityCalendarState();
}

class _OwnerAvailabilityCalendarState extends State<OwnerAvailabilityCalendar> {
  late DateTime _displayMonth;
  late List<_OwnerDayCell?> _gridCells;
  late DateTime _today;

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const _monthNamesAr = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  static const _weekDayLabels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
  static const _weekDayLabelsAr = [
    'إث',
    'ثل',
    'أر',
    'خم',
    'جم',
    'سب',
    'أح',
  ];

  @override
  void initState() {
    super.initState();
    _today = _normalize(DateTime.now());
    _displayMonth = DateTime(_today.year, _today.month);
    _rebuildGrid();
  }

  @override
  void didUpdateWidget(covariant OwnerAvailabilityCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.calendar != widget.calendar ||
        oldWidget.action != widget.action ||
        oldWidget.selectedDates != widget.selectedDates) {
      _rebuildGrid();
    }
  }

  void _rebuildGrid() {
    _gridCells = _buildMonthGrid();
  }

  bool _isPast(DateTime day) => _normalize(day).isBefore(_today);

  bool _canToggle(DateTime day) {
    final normalized = _normalize(day);
    if (_isPast(normalized)) return false;
    if (widget.calendar.isBooked(normalized)) return false;

    if (widget.action == OwnerCalendarAction.block) {
      return !widget.calendar.isBlockedByOwner(normalized);
    }
    return widget.calendar.isBlockedByOwner(normalized);
  }

  bool _isSelected(DateTime day) {
    final normalized = _normalize(day);
    return widget.selectedDates.any((d) => _sameDay(_normalize(d), normalized));
  }

  List<_OwnerDayCell?> _buildMonthGrid() {
    final daysInMonth =
        DateTime(_displayMonth.year, _displayMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(_displayMonth.year, _displayMonth.month, 1).weekday - 1;
    final totalCells = ((firstWeekday + daysInMonth + 6) ~/ 7) * 7;

    final cells = List<_OwnerDayCell?>.filled(totalCells, null);
    for (var day = 1; day <= daysInMonth; day++) {
      final index = firstWeekday + day - 1;
      final date = DateTime(_displayMonth.year, _displayMonth.month, day);
      final normalized = _normalize(date);
      cells[index] = _OwnerDayCell(
        day: day,
        date: date,
        isBooked: widget.calendar.isBooked(normalized),
        isBlocked: widget.calendar.isBlockedByOwner(normalized),
        isPast: _isPast(normalized),
        isSelected: _isSelected(date),
        canToggle: _canToggle(date),
        isToday: _sameDay(normalized, _today),
      );
    }
    return cells;
  }

  void _shiftMonth(int delta) {
    setState(() {
      _displayMonth = DateTime(
        _displayMonth.year,
        _displayMonth.month + delta,
      );
      _rebuildGrid();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final monthLabel = isArabic
        ? '${_monthNamesAr[_displayMonth.month - 1]} ${_displayMonth.year}'
        : '${_monthNames[_displayMonth.month - 1]} ${_displayMonth.year}';
    final weekDayLabels = isArabic ? _weekDayLabelsAr : _weekDayLabels;
    final isCurrentMonth =
        _displayMonth.year == _today.year && _displayMonth.month == _today.month;

    final hint = widget.action == OwnerCalendarAction.block
        ? tr.calendar_block_hint
        : tr.calendar_unblock_hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 3.w,
          runSpacing: 0.6.h,
          children: [
            _LegendDot(color: Colors.white, border: Colors.black26, label: tr.calendar_available),
            const _LegendDot(color: Color(0xFFE57373), labelKey: _LegendLabel.booked),
            const _LegendDot(color: Colors.grey, labelKey: _LegendLabel.blocked),
            _LegendDot(
              color: AppColors.goldBrandColor.withAlpha(90),
              border: AppColors.goldBrandColor,
              label: tr.calendar_selected,
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          hint,
          style: appTextStyle(
            context,
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.goldBrandColor,
          ),
        ),
        SizedBox(height: 1.2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(
              icon: Icons.chevron_left_rounded,
              onTap: isCurrentMonth ? null : () => _shiftMonth(-1),
            ),
            Text(
              monthLabel,
              style: appTextStyle(
                context,
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.blackColor,
              ),
            ),
            _NavButton(
              icon: Icons.chevron_right_rounded,
              onTap: () => _shiftMonth(1),
            ),
          ],
        ),
        SizedBox(height: 1.2.h),
        Row(
          children: weekDayLabels
              .map(
                (weekday) => Expanded(
                  child: Center(
                    child: Text(
                      weekday,
                      style: appTextStyle(
                        context,
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grayBrandColor,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 0.6.h),
        RepaintBoundary(
          child: Column(
            children: List.generate(_gridCells.length ~/ 7, (row) {
              return Row(
                children: List.generate(7, (col) {
                  final cell = _gridCells[row * 7 + col];
                  if (cell == null) {
                    return const Expanded(child: SizedBox(height: 40));
                  }
                  return Expanded(
                    child: _DayCell(
                      data: cell,
                      onTap: cell.canToggle
                          ? () => widget.onDayToggled(cell.date)
                          : null,
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ],
    );
  }

  static DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _OwnerDayCell {
  final int day;
  final DateTime date;
  final bool isBooked;
  final bool isBlocked;
  final bool isPast;
  final bool isSelected;
  final bool canToggle;
  final bool isToday;

  const _OwnerDayCell({
    required this.day,
    required this.date,
    required this.isBooked,
    required this.isBlocked,
    required this.isPast,
    required this.isSelected,
    required this.canToggle,
    required this.isToday,
  });
}

enum _LegendLabel { booked, blocked }

class _LegendDot extends StatelessWidget {
  final Color color;
  final Color? border;
  final String? label;
  final _LegendLabel? labelKey;

  const _LegendDot({
    required this.color,
    this.border,
    this.label,
    this.labelKey,
  });

  @override
  Widget build(BuildContext context) {
    final text = label ??
        switch (labelKey) {
          _LegendLabel.booked => tr.calendar_booked,
          _LegendLabel.blocked => tr.calendar_blocked,
          null => '',
        };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: border != null ? Border.all(color: border!) : null,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          text,
          style: appTextStyle(
            context,
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withAlpha(140),
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _NavButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onTap == null
          ? Colors.black.withAlpha(8)
          : AppColors.goldBrandColor.withAlpha(25),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            size: 22,
            color: onTap == null
                ? Colors.black.withAlpha(60)
                : AppColors.goldBrandColor,
          ),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final _OwnerDayCell data;
  final VoidCallback? onTap;

  const _DayCell({required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.transparent;
    Color textColor = Colors.black.withAlpha(220);
    FontWeight weight = FontWeight.w600;
    var borderSide = BorderSide.none;

    if (data.isSelected) {
      bg = AppColors.goldBrandColor.withAlpha(95);
      textColor = Colors.white;
      weight = FontWeight.w900;
      borderSide = const BorderSide(color: AppColors.goldBrandColor, width: 2);
    } else if (data.isBooked) {
      bg = const Color(0xFFE57373).withAlpha(45);
      textColor = const Color(0xFFC62828);
    } else if (data.isBlocked) {
      bg = Colors.grey.withAlpha(50);
      textColor = Colors.grey.shade700;
    } else if (data.isPast) {
      textColor = Colors.black.withAlpha(80);
    }

    if (!data.isSelected && data.isToday) {
      borderSide = const BorderSide(color: AppColors.goldBrandColor, width: 1.5);
    }

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: bg,
        elevation: data.isSelected ? 2 : 0,
        shadowColor: AppColors.goldBrandColor.withAlpha(120),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: borderSide,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 36,
            child: Center(
              child: Text(
                '${data.day}',
                style: appTextStyle(
                  context,
                  fontSize: 10.sp,
                  fontWeight: weight,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
