import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/booking/data/models/asset_calendar.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum BookingDateStep { checkIn, checkOut }

class _DayCellData {
  final int day;
  final DateTime date;
  final bool isBooked;
  final bool isBlocked;
  final bool isDisabled;
  final bool isCheckIn;
  final bool isCheckOut;
  final bool isInRange;
  final bool isToday;
  final bool canSelect;

  const _DayCellData({
    required this.day,
    required this.date,
    required this.isBooked,
    required this.isBlocked,
    required this.isDisabled,
    required this.isCheckIn,
    required this.isCheckOut,
    required this.isInRange,
    required this.isToday,
    required this.canSelect,
  });
}

class BookingCalendar extends StatefulWidget {
  final AssetCalendarData calendar;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final BookingDateStep selectionStep;
  final ValueChanged<DateTime> onDaySelected;

  const BookingCalendar({
    super.key,
    required this.calendar,
    required this.checkIn,
    required this.checkOut,
    required this.selectionStep,
    required this.onDaySelected,
  });

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  late DateTime _displayMonth;
  late List<_DayCellData?> _gridCells;
  DateTime? _maxCheckOutDate;
  DateTime? _firstAvailableDayCache;
  DateTime? _todayCache;

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
    _todayCache = _normalize(DateTime.now());
    _displayMonth = _monthForAnchor(_displayAnchor());
    _rebuildDerivedState();
  }

  @override
  void didUpdateWidget(covariant BookingCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final inputsChanged = oldWidget.calendar != widget.calendar ||
        oldWidget.checkIn != widget.checkIn ||
        oldWidget.checkOut != widget.checkOut ||
        oldWidget.selectionStep != widget.selectionStep;

    if (inputsChanged) {
      if (oldWidget.calendar != widget.calendar) {
        _firstAvailableDayCache = null;
      }
      if (widget.checkIn != oldWidget.checkIn ||
          widget.selectionStep != oldWidget.selectionStep) {
        _displayMonth = _monthForAnchor(_displayAnchor());
      }
      _rebuildDerivedState();
    }
  }

  void _rebuildDerivedState() {
    _todayCache = _normalize(DateTime.now());
    _maxCheckOutDate = widget.checkIn == null
        ? null
        : widget.calendar.firstUnavailableNightOnOrAfter(widget.checkIn!);
    _gridCells = _buildMonthGrid();
  }

  DateTime _displayAnchor() {
    if (widget.selectionStep == BookingDateStep.checkOut &&
        widget.checkIn != null) {
      return widget.checkIn!;
    }
    return widget.checkIn ?? _firstAvailableDay();
  }

  DateTime _monthForAnchor(DateTime anchor) =>
      DateTime(anchor.year, anchor.month);

  DateTime _firstAvailableDay() {
    if (_firstAvailableDayCache != null) return _firstAvailableDayCache!;
    final today = _todayCache!;
    var cursor = today;
    final last = today.add(const Duration(days: 730));
    while (!cursor.isAfter(last)) {
      if (!_isPastOrUnavailable(cursor)) {
        _firstAvailableDayCache = cursor;
        return cursor;
      }
      cursor = cursor.add(const Duration(days: 1));
    }
    _firstAvailableDayCache = today;
    return today;
  }

  bool _isPastOrUnavailable(DateTime day) {
    final normalized = _normalize(day);
    final today = _todayCache!;
    if (normalized.isBefore(today)) return true;
    return widget.calendar.isUnavailable(normalized);
  }

  bool _canSelectDay(DateTime day) {
    final normalized = _normalize(day);
    if (_isPastOrUnavailable(normalized)) return false;

    if (widget.selectionStep == BookingDateStep.checkOut &&
        widget.checkIn != null) {
      final checkIn = _normalize(widget.checkIn!);
      if (!normalized.isAfter(checkIn)) return false;
      final maxOut = _maxCheckOutDate;
      if (maxOut != null && normalized.isAfter(maxOut)) return false;
    }
    return true;
  }

  List<_DayCellData?> _buildMonthGrid() {
    final today = _todayCache!;
    final daysInMonth =
        DateTime(_displayMonth.year, _displayMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(_displayMonth.year, _displayMonth.month, 1).weekday - 1;
    final totalCells = ((firstWeekday + daysInMonth + 6) ~/ 7) * 7;

    final cells = List<_DayCellData?>.filled(totalCells, null);
    for (var day = 1; day <= daysInMonth; day++) {
      final index = firstWeekday + day - 1;
      final date = DateTime(_displayMonth.year, _displayMonth.month, day);
      final normalized = _normalize(date);
      final isBooked = widget.calendar.isBooked(normalized);
      final isBlocked = widget.calendar.isBlockedByOwner(normalized);
      final canSelect = _canSelectDay(date);

      cells[index] = _DayCellData(
        day: day,
        date: date,
        isBooked: isBooked,
        isBlocked: isBlocked,
        isDisabled: !canSelect,
        isCheckIn: widget.checkIn != null &&
            _sameDay(normalized, widget.checkIn!),
        isCheckOut: widget.checkOut != null &&
            _sameDay(normalized, widget.checkOut!),
        isInRange: widget.checkIn != null &&
            widget.checkOut != null &&
            normalized.isAfter(_normalize(widget.checkIn!)) &&
            normalized.isBefore(_normalize(widget.checkOut!)),
        isToday: _sameDay(normalized, today),
        canSelect: canSelect,
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
      _gridCells = _buildMonthGrid();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final monthLabel = isArabic
        ? '${_monthNamesAr[_displayMonth.month - 1]} ${_displayMonth.year}'
        : '${_monthNames[_displayMonth.month - 1]} ${_displayMonth.year}';
    final weekDayLabels = isArabic ? _weekDayLabelsAr : _weekDayLabels;
    final today = _todayCache!;
    final isCurrentMonth = _displayMonth.year == today.year &&
        _displayMonth.month == today.month;

    final hint = widget.selectionStep == BookingDateStep.checkIn
        ? tr.calendar_select_checkin
        : tr.calendar_select_checkout;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              tr.calendar_availability,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(220),
              ),
            ),
            const Spacer(),
            const _LegendDot(
              color: Color(0xFFE57373),
              labelKey: _LegendLabel.booked,
            ),
            SizedBox(width: 2.5.w),
            const _LegendDot(
              color: Colors.grey,
              labelKey: _LegendLabel.blocked,
            ),
          ],
        ),
        SizedBox(height: 0.8.h),
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
                    return const Expanded(child: SizedBox(height: 36));
                  }
                  return Expanded(
                    child: _DayCell(
                      data: cell,
                      onTap: cell.canSelect
                          ? () => widget.onDaySelected(cell.date)
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

enum _LegendLabel { booked, blocked }

class _LegendDot extends StatelessWidget {
  final Color color;
  final _LegendLabel labelKey;

  const _LegendDot({required this.color, required this.labelKey});

  @override
  Widget build(BuildContext context) {
    final label = switch (labelKey) {
      _LegendLabel.booked => tr.calendar_booked,
      _LegendLabel.blocked => tr.calendar_blocked,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onTap == null ? 0.3 : 1,
        child: Container(
          padding: EdgeInsets.all(1.8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black.withAlpha(15)),
          ),
          child: Icon(icon, size: 18, color: AppColors.blackColor),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final _DayCellData data;
  final VoidCallback? onTap;

  const _DayCell({required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEndpoint = data.isCheckIn || data.isCheckOut;
    Color bg = Colors.transparent;
    Color textColor = Colors.black.withAlpha(220);
    FontWeight weight = FontWeight.w600;

    if (isEndpoint) {
      bg = AppColors.goldBrandColor;
      textColor = Colors.white;
      weight = FontWeight.w900;
    } else if (data.isInRange) {
      bg = AppColors.goldBrandColor.withAlpha(40);
      weight = FontWeight.w800;
    } else if (data.isBooked) {
      bg = const Color(0xFFFFEBEE);
      textColor = const Color(0xFFC62828).withAlpha(170);
    } else if (data.isBlocked) {
      bg = const Color(0xFFE0E0E0);
      textColor = const Color(0xFF757575);
    } else if (data.isDisabled) {
      textColor = Colors.black.withAlpha(60);
    } else if (data.isToday) {
      bg = AppColors.goldBrandColor.withAlpha(18);
      weight = FontWeight.w800;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 36,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: data.isToday && !isEndpoint
              ? Border.all(color: AppColors.goldBrandColor.withAlpha(120))
              : null,
        ),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${data.day}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: weight,
                color: textColor,
                decoration: data.isBooked && !isEndpoint
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            if (data.isBlocked && !isEndpoint)
              const Positioned(
                bottom: 4,
                child: Icon(Icons.block_rounded, size: 10, color: Color(0xFF9E9E9E)),
              ),
          ],
        ),
      ),
    );
  }
}
