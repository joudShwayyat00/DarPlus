import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/booking/data/models/asset_calendar.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum BookingDateStep { checkIn, checkOut }

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
    _displayMonth = _monthForAnchor(_displayAnchor());
  }

  @override
  void didUpdateWidget(covariant BookingCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectionStep != oldWidget.selectionStep ||
        widget.checkIn != oldWidget.checkIn) {
      _displayMonth = _monthForAnchor(_displayAnchor());
    }
  }

  DateTime _displayAnchor() {
    if (widget.selectionStep == BookingDateStep.checkOut &&
        widget.checkIn != null) {
      return widget.checkIn!;
    }
    return widget.checkIn ?? _firstAvailableDay() ?? DateTime.now();
  }

  DateTime _monthForAnchor(DateTime anchor) =>
      DateTime(anchor.year, anchor.month);

  DateTime? _firstAvailableDay() {
    final today = _normalize(DateTime.now());
    var cursor = today;
    final last = today.add(const Duration(days: 730));
    while (!cursor.isAfter(last)) {
      if (!_isDayUnavailable(cursor)) return cursor;
      cursor = cursor.add(const Duration(days: 1));
    }
    return null;
  }

  bool _isDayUnavailable(DateTime day) {
    final normalized = _normalize(day);
    final today = _normalize(DateTime.now());
    if (normalized.isBefore(today)) return true;
    return widget.calendar.isUnavailable(normalized);
  }

  bool _canSelectDay(DateTime day) {
    final normalized = _normalize(day);
    if (_isDayUnavailable(normalized)) return false;

    if (widget.selectionStep == BookingDateStep.checkOut &&
        widget.checkIn != null) {
      if (!normalized.isAfter(_normalize(widget.checkIn!))) return false;
      if (widget.calendar.rangeHasUnavailable(widget.checkIn!, normalized)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final monthLabel = isArabic
        ? '${_monthNamesAr[_displayMonth.month - 1]} ${_displayMonth.year}'
        : '${_monthNames[_displayMonth.month - 1]} ${_displayMonth.year}';
    final weekDayLabels = isArabic ? _weekDayLabelsAr : _weekDayLabels;
    final today = _normalize(DateTime.now());
    final currentMonthNorm = DateTime(today.year, today.month);
    final isCurrentMonth = _displayMonth.isAtSameMomentAs(currentMonthNorm);

    final daysInMonth =
        DateTime(_displayMonth.year, _displayMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(_displayMonth.year, _displayMonth.month, 1).weekday - 1;

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
              _LegendDot(
                color: const Color(0xFFE57373),
                label: tr.calendar_booked,
              ),
              SizedBox(width: 2.5.w),
              _LegendDot(
                color: Colors.grey.shade500,
                label: tr.calendar_blocked,
              ),
            ],
          ),
          if (hint.isNotEmpty) ...[
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
          ],
          SizedBox(height: 1.2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavButton(
                icon: Icons.chevron_left_rounded,
                onTap: isCurrentMonth
                    ? null
                    : () => setState(() {
                          _displayMonth = DateTime(
                            _displayMonth.year,
                            _displayMonth.month - 1,
                          );
                        }),
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
                onTap: () => setState(() {
                  _displayMonth = DateTime(
                    _displayMonth.year,
                    _displayMonth.month + 1,
                  );
                }),
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.05,
            ),
            itemCount: firstWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstWeekday) return const SizedBox.shrink();

              final day = index - firstWeekday + 1;
              final date = DateTime(_displayMonth.year, _displayMonth.month, day);
              final normalized = _normalize(date);
              final isBooked = widget.calendar.isBooked(normalized);
              final isBlocked = widget.calendar.isBlockedByOwner(normalized);
              final isUnavailable = _isDayUnavailable(normalized);
              final canSelect = _canSelectDay(date);
              final isDisabled = isUnavailable || !canSelect;
              final isCheckIn = widget.checkIn != null &&
                  _sameDay(normalized, widget.checkIn!);
              final isCheckOut = widget.checkOut != null &&
                  _sameDay(normalized, widget.checkOut!);
              final isInRange = widget.checkIn != null &&
                  widget.checkOut != null &&
                  normalized.isAfter(_normalize(widget.checkIn!)) &&
                  normalized.isBefore(_normalize(widget.checkOut!));
              final isToday = _sameDay(normalized, today);

              return _DayCell(
                day: day,
                isUnavailable: isDisabled,
                isBooked: isBooked,
                isBlocked: isBlocked,
                isCheckIn: isCheckIn,
                isCheckOut: isCheckOut,
                isInRange: isInRange,
                isToday: isToday,
                onTap: canSelect ? () => widget.onDaySelected(date) : null,
              );
            },
          ),
        ],
    );
  }

  static DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
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
  final int day;
  final bool isUnavailable;
  final bool isBooked;
  final bool isBlocked;
  final bool isCheckIn;
  final bool isCheckOut;
  final bool isInRange;
  final bool isToday;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    required this.isUnavailable,
    required this.isBooked,
    required this.isBlocked,
    required this.isCheckIn,
    required this.isCheckOut,
    required this.isInRange,
    required this.isToday,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEndpoint = isCheckIn || isCheckOut;
    Color bg = Colors.transparent;
    Color textColor = Colors.black.withAlpha(220);
    FontWeight weight = FontWeight.w600;

    if (isEndpoint) {
      bg = AppColors.goldBrandColor;
      textColor = Colors.white;
      weight = FontWeight.w900;
    } else if (isInRange) {
      bg = AppColors.goldBrandColor.withAlpha(40);
      weight = FontWeight.w800;
    } else if (isBooked) {
      bg = const Color(0xFFFFEBEE);
      textColor = const Color(0xFFC62828).withAlpha(170);
    } else if (isBlocked) {
      bg = Colors.grey.shade200;
      textColor = Colors.grey.shade600;
    } else if (isUnavailable) {
      textColor = Colors.black.withAlpha(60);
    } else if (isToday) {
      bg = AppColors.goldBrandColor.withAlpha(18);
      weight = FontWeight.w800;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: isToday && !isEndpoint
              ? Border.all(color: AppColors.goldBrandColor.withAlpha(120))
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '$day',
              style: appTextStyle(
                context,
                fontSize: 10.sp,
                fontWeight: weight,
                color: textColor,
              ).copyWith(
                decoration: isBooked && !isEndpoint
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            if (isBlocked && !isEndpoint)
              Positioned(
                bottom: 4,
                child: Icon(
                  Icons.block_rounded,
                  size: 10,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
