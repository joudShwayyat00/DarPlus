import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/booking/data/models/booking_response.dart';
import 'package:dar_plus_app/features/booking/presentation/providers/booking_providers.dart';
import 'package:dar_plus_app/models/property_item.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/app_net_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/widgets/auth_required_sheet.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final PropertyItem item;

  const BookingScreen({super.key, required this.item});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 2;

  bool _agree = true;

  final TextEditingController _notes = TextEditingController();

  /// Nights derived from check-in/out selection.
  int get _nights {
    if (_checkIn == null || _checkOut == null) return 1;
    return _checkOut!.difference(_checkIn!).inDays.clamp(1, 365);
  }

  static bool _isLeapYear(int year) =>
      (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

  /// Rental months use 28 days, or 29 for February in a leap year.
  static int _daysInRentalMonth(DateTime from) {
    if (from.month == 2 && _isLeapYear(from.year)) return 29;
    return 28;
  }

  static DateTime _addRentalMonths(DateTime from, int months) {
    var cursor = from;
    for (var i = 0; i < months; i++) {
      cursor = cursor.add(Duration(days: _daysInRentalMonth(cursor)));
    }
    return cursor;
  }

  int _countMonthlyPeriods(DateTime checkIn, DateTime checkOut) {
    final totalDays = checkOut.difference(checkIn).inDays;
    if (totalDays <= 0) return 1;

    var periods = 0;
    var remaining = totalDays;
    var cursor = checkIn;
    while (remaining > 0) {
      periods++;
      final monthDays = _daysInRentalMonth(cursor);
      remaining -= monthDays;
      cursor = cursor.add(Duration(days: monthDays));
    }
    return periods;
  }

  int? get _maxMonthlyPeriods {
    final count = widget.item.monthsCount;
    if (widget.item.rentType == 'monthly' && count != null && count > 0) {
      return count;
    }
    return null;
  }

  int? get _maxDailyPeriods {
    final count = widget.item.daysCount;
    if (widget.item.rentType == 'daily' && count != null && count > 0) {
      return count;
    }
    return null;
  }

  /// Period count based on rent type: days for daily, months for monthly, years for yearly.
  int _periodsCount(String? rentType) {
    if (_checkIn == null || _checkOut == null) return 1;
    switch (rentType) {
      case 'monthly':
        final periods = _countMonthlyPeriods(_checkIn!, _checkOut!);
        final maxMonths = _maxMonthlyPeriods;
        if (maxMonths != null) return periods.clamp(1, maxMonths);
        return periods.clamp(1, 120);
      case 'yearly':
        final years = _checkOut!.year - _checkIn!.year;
        final maxYears = widget.item.yearsCount;
        if (maxYears != null && maxYears > 0) {
          return years.clamp(1, maxYears);
        }
        return years.clamp(1, 10);
      default: // daily
        final days = _checkOut!.difference(_checkIn!).inDays;
        final maxDays = _maxDailyPeriods;
        if (maxDays != null) return days.clamp(1, maxDays);
        return days.clamp(1, 365);
    }
  }

  DateTime? _maxCheckOutDate() {
    if (_checkIn == null) return null;
    final maxMonths = _maxMonthlyPeriods;
    if (maxMonths == null) return null;
    return _addRentalMonths(_checkIn!, maxMonths);
  }

  bool _exceedsMonthlyLimit() {
    final maxMonths = _maxMonthlyPeriods;
    if (maxMonths == null || _checkIn == null || _checkOut == null) {
      return false;
    }
    return _countMonthlyPeriods(_checkIn!, _checkOut!) > maxMonths;
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  int _pricePerPeriodJod() {
    if (widget.item.rentPrice != null) {
      return widget.item.rentPrice!.round();
    }
    final raw = widget.item.price;
    final digits = RegExp(
      r'\d+',
    ).allMatches(raw).map((m) => m.group(0)!).toList();
    if (digits.isEmpty) return 0;
    return int.tryParse(digits.first) ?? 0;
  }

  /// API date format: yyyy-MM-dd
  static String _apiDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final bookingState = ref.watch(bookingControllerProvider);

    final maxGuests = item.guests <= 0 ? 20 : item.guests;
    if (_guests > maxGuests) _guests = maxGuests;

    final pricePerPeriod = _pricePerPeriodJod();
    final rentType = item.rentType;
    final isForSale = item.listingType == ListingType.sale;

    // Local price estimate (shown before API responds)
    int subtotal = 0;
    int total = 0;
    if (_checkIn != null && _checkOut != null) {
      subtotal = _periodsCount(rentType) * pricePerPeriod;
      total = subtotal;
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leadingWidth: 52,
        leading: Padding(
          padding: EdgeInsets.only(left: 3.w),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
            iconSize: 18.sp,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              shape: const CircleBorder(),
              elevation: 0,
            ),
          ),
        ),
        title: Text(
          tr.book_now,
          style: appTextStyle(
            context,
            fontSize: 13.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black.withAlpha(240),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(5.w, 1.4.h, 5.w, 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeroSummary(item: item),
            SizedBox(height: 1.5.h),
            _SectionTitle(text: tr.your_stay),
            SizedBox(height: 1.2.h),
            _StayCard(
              checkIn: _checkIn,
              checkOut: _checkOut,
              nights: _nights,
              rentType: isForSale ? null : rentType,
              periods: _periodsCount(rentType),
              maxMonths: _maxMonthlyPeriods,
              onPickCheckIn: () => _pickDate(context, isCheckIn: true),
              onPickCheckOut: () => _pickDate(context, isCheckIn: false),
              onClear: () => setState(() {
                _checkIn = null;
                _checkOut = null;
              }),
            ),

            SizedBox(height: 2.0.h),

            _SectionTitle(text: tr.guests),
            SizedBox(height: 1.2.h),
            _GuestsCard(
              value: _guests,
              max: maxGuests,
              onChanged: (v) => setState(() => _guests = v),
            ),

            SizedBox(height: 2.0.h),

            _SectionTitle(text: tr.payment),
            SizedBox(height: 1.2.h),
            _PaymentCard(),

            SizedBox(height: 2.0.h),

            _SectionTitle(text: tr.notes),
            SizedBox(height: 1.2.h),
            _NotesCard(controller: _notes),

            SizedBox(height: 2.0.h),

            _SectionTitle(text: tr.price_summary),
            SizedBox(height: 1.2.h),
            _PriceCard(
              enabled: _checkIn != null && _checkOut != null,
              pricePerPeriod: pricePerPeriod,
              rentType: isForSale ? null : rentType,
              periods: _periodsCount(rentType),
              subtotal: subtotal,
              total: total,
            ),

            SizedBox(height: 1.6.h),
            _PolicyRow(
              value: _agree,
              onChanged: (v) => setState(() => _agree = v),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.4.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, -6),
                color: Colors.black.withAlpha(15),
              ),
            ],
          ),
          child: Row(
            children: [
              AbsorbPointer(
                absorbing: bookingState.isLoading,
                child: AppButton(
                  height: 6.0.h,
                  width: 60.w,
                  backgroundColor: bookingState.isLoading
                      ? AppColors.goldBrandColor.withAlpha(160)
                      : AppColors.goldBrandColor,
                  onPressed: () async {
                    if (!await requireAuth(
                      context,
                      message: tr.login_required_booking,
                      icon: Icons.calendar_month_rounded,
                    )) {
                      return;
                    }
                    if (!context.mounted) return;
                    if (_checkIn == null || _checkOut == null) {
                      _toast(context, tr.please_select_checkin_date);
                      return;
                    }
                    if (_exceedsMonthlyLimit()) {
                      _toast(
                        context,
                        tr.max_rental_months_exceeded(_maxMonthlyPeriods!),
                      );
                      return;
                    }
                    if (!_agree) {
                      _toast(context, tr.please_accept_booking_policy);
                      return;
                    }
                    final assetId = widget.item.assetId;
                    if (assetId == null) {
                      // Offline/demo item — show success without API call
                      _showSuccessDialog(context, null);
                      return;
                    }
                    await ref
                        .read(bookingControllerProvider.notifier)
                        .submit(
                          assetId: assetId,
                          checkIn: _apiDate(_checkIn!),
                          checkOut: _apiDate(_checkOut!),
                          guests: _guests,
                          paymentMethod: 'cod',
                          rentType: rentType,
                          periodCount: _periodsCount(rentType),
                          notes: _notes.text.trim().isEmpty
                              ? null
                              : _notes.text.trim(),
                        );
                    if (!context.mounted) return;
                    final latest = ref.read(bookingControllerProvider);
                    latest.when(
                      data: (data) => _showSuccessDialog(context, data),
                      error: (e, _) {
                        final msg = e.toString().replaceFirst(
                          'Exception: ',
                          '',
                        );
                        _toast(context, msg);
                      },
                      loading: () {},
                    );
                  },
                  child: bookingState.isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          tr.confirm_booking,
                          style: appTextStyle(
                            context,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.total,
                      style: appTextStyle(
                        context,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withAlpha(140),
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      (_checkIn == null || _checkOut == null)
                          ? '--'
                          : bookingState.whenOrNull(
                                  data: (d) => d != null
                                      ? '${d.finalPrice} ${tr.currency_jod}'
                                      : null,
                                ) ??
                                '$total ${tr.currency_jod}',
                      style: appTextStyle(
                        context,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.black.withAlpha(240),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shared date picker helper
  Future<void> _pickDate(
    BuildContext context, {
    required bool isCheckIn,
  }) async {
    final now = DateTime.now();
    final rentType = widget.item.rentType;
    final initialDate = isCheckIn
        ? (_checkIn ?? now)
        : (_checkOut ??
              (_checkIn?.add(const Duration(days: 1))) ??
              now.add(const Duration(days: 1)));
    final firstDate = isCheckIn
        ? DateTime(now.year, now.month, now.day)
        : (_checkIn?.add(const Duration(days: 1)) ??
              DateTime(now.year, now.month, now.day + 1));

    var lastDate = DateTime(now.year + 2);
    if (!isCheckIn && rentType == 'monthly') {
      final maxOut = _maxCheckOutDate();
      if (maxOut != null && maxOut.isBefore(lastDate)) {
        lastDate = maxOut;
      }
    }

    if (!isCheckIn && firstDate.isAfter(lastDate)) {
      final maxMonths = _maxMonthlyPeriods;
      if (maxMonths != null) {
        _toast(context, tr.max_rental_months_exceeded(maxMonths));
      }
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(lastDate) ? lastDate : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        final base = Theme.of(context);
        return Theme(
          data: base.copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.goldBrandColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            datePickerTheme: DatePickerThemeData(
              headerHeadlineStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              weekdayStyle: const TextStyle(fontWeight: FontWeight.w700),
              dayStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (!mounted) return;
    if (picked == null) return;

    if (!isCheckIn && rentType == 'monthly' && _checkIn != null) {
      final maxOut = _maxCheckOutDate();
      if (maxOut != null && picked.isAfter(maxOut)) {
        if (!context.mounted) return;
        _toast(
          context,
          tr.max_rental_months_exceeded(_maxMonthlyPeriods!),
        );
        return;
      }
    }

    setState(() {
      if (isCheckIn) {
        _checkIn = picked;
        if (_checkOut != null) {
          final exceedsMonthly = rentType == 'monthly' &&
              _maxMonthlyPeriods != null &&
              _countMonthlyPeriods(picked, _checkOut!) > _maxMonthlyPeriods!;
          if (!_checkOut!.isAfter(picked) || exceedsMonthly) {
            _checkOut = null;
          }
        }
      } else {
        _checkOut = picked;
      }
    });
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: appTextStyle(
            context,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black.withAlpha(220),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, BookingData? data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(10),

                child: Lottie.asset(
                  'assets/lottie/success.json',
                  width: 150,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 1.8.h),
              Text(
                tr.booking_confirmed,
                style: appTextStyle(
                  context,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withAlpha(230),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                tr.reservation_submitted,
                textAlign: TextAlign.center,
                style: appTextStyle(
                  context,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withAlpha(140),
                  height: 1.4,
                ),
              ),
              if (data != null) ...[
                SizedBox(height: 1.5.h),
                _BookingSummaryCard(data: data),
              ],
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      height: 5.5.h,
                      backgroundColor: Colors.grey.shade100,
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to property details
                      },
                      child: Text(
                        tr.back,
                        style: appTextStyle(
                          context,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withAlpha(180),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: AppButton(
                      height: 5.5.h,
                      backgroundColor: AppColors.goldBrandColor,
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                      },
                      child: Text(
                        tr.done,
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
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- UI ----------------

class _HeroSummary extends StatelessWidget {
  final PropertyItem item;

  const _HeroSummary({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(70)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 10),
            color: Colors.black.withAlpha(10),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: 22.w,
              height: 22.w,
              child: AppNetImage(
                url: item.images.isNotEmpty ? item.images.first : "",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 3.4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title == "Sea View Chalet"
                      ? tr.sample_sea_view_chalet
                      : item.title == "Cozy Nature Chalet"
                      ? tr.sample_cozy_nature_chalet
                      : item.title == "Family Chalet with Pool"
                      ? tr.sample_family_chalet_with_pool
                      : item.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: appTextStyle(
                    context,
                    fontSize: 12.8.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withAlpha(245),
                  ),
                ),
                SizedBox(height: 0.8.h),
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      size: 16,
                      color: Colors.black.withAlpha(150),
                    ),
                    SizedBox(width: 1.6.w),
                    Expanded(
                      child: Text(
                        item.location,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: appTextStyle(
                          context,
                          fontSize: 10.8.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withAlpha(160),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.9.h),
                Row(
                  children: [
                    _Pill(
                      text: item.price,
                      bg: Colors.grey.shade100,
                      textColor: Colors.black.withAlpha(220),
                    ),
                    SizedBox(width: 2.w),
                    _RatingPill(rating: item.rating),
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

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: appTextStyle(
        context,
        fontSize: 12.8.sp,
        fontWeight: FontWeight.w800,
        color: Colors.black.withAlpha(240),
      ),
    );
  }
}

class _StayCard extends StatelessWidget {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int nights;
  final String? rentType;
  final int periods;
  final int? maxMonths;
  final VoidCallback onPickCheckIn;
  final VoidCallback onPickCheckOut;
  final VoidCallback onClear;

  const _StayCard({
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.rentType,
    required this.periods,
    required this.maxMonths,
    required this.onPickCheckIn,
    required this.onPickCheckOut,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasIn = checkIn != null;
    final hasOut = checkOut != null;

    return _CardShell(
      child: Column(
        children: [
          // Check-in row
          _DateRow(
            label: tr.check_in_date,
            date: checkIn,
            onTap: onPickCheckIn,
            onClear: hasIn ? onClear : null,
          ),
          SizedBox(height: 1.2.h),
          // Check-out row
          _DateRow(
            label: tr.check_out_date,
            date: checkOut,
            onTap: hasIn ? onPickCheckOut : null,
            onClear: null,
          ),
          if (rentType == 'monthly' && maxMonths != null) ...[
            SizedBox(height: 1.h),
            Text(
              tr.max_rental_months_hint(maxMonths!),
              style: appTextStyle(
                context,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(130),
              ),
            ),
          ],
          if (hasIn && hasOut) ...[
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.6.w, vertical: 0.8.h),
              decoration: BoxDecoration(
                color: AppColors.goldBrandColor.withAlpha(22),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    rentType == 'monthly'
                        ? Icons.calendar_month_outlined
                        : Icons.nights_stay_outlined,
                    size: 18,
                    color: AppColors.goldBrandColor,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    rentType == 'monthly'
                        ? '$periods ${tr.months}'
                        : '$nights ${tr.nights}',
                    style: appTextStyle(
                      context,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withAlpha(220),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback? onTap;
  final VoidCallback? onClear;

  const _DateRow({
    required this.label,
    required this.date,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;
    final isEnabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(3.6.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasDate
                ? AppColors.goldBrandColor.withAlpha(100)
                : Colors.black.withAlpha(18),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.6.w),
              decoration: BoxDecoration(
                color: AppColors.goldBrandColor.withAlpha(22),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.date_range,
                color: Colors.black.withAlpha(isEnabled ? 200 : 100),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: appTextStyle(
                      context,
                      fontSize: 10.6.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withAlpha(150),
                    ),
                  ),
                  SizedBox(height: 0.35.h),
                  Text(
                    hasDate ? _fmt(date!) : (isEnabled ? tr.select_date : '--'),
                    style: appTextStyle(
                      context,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withAlpha(hasDate ? 230 : 140),
                    ),
                  ),
                ],
              ),
            ),
            if (hasDate && onClear != null)
              IconButton(
                onPressed: onClear,
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.black.withAlpha(170),
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black.withAlpha(isEnabled ? 170 : 80),
              ),
          ],
        ),
      ),
    );
  }

  static String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _GuestsCard extends StatelessWidget {
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  const _GuestsCard({
    required this.value,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.6.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.group, color: Colors.black.withAlpha(200)),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.number_of_guests,
                  style: appTextStyle(
                    context,
                    fontSize: 10.8.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withAlpha(150),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  "$value / $max",
                  style: appTextStyle(
                    context,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withAlpha(230),
                  ),
                ),
              ],
            ),
          ),
          _Stepper(value: value, min: 1, max: max, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard();

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: _RadioRow(
        title: tr.cash_on_arrival,
        subtitle: tr.pay_when_checkin,
        icon: Icons.payments_outlined,
        selected: true,
        onTap: () {},
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  final TextEditingController controller;

  const _NotesCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr.any_special_requests,
            style: appTextStyle(
              context,
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(220),
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: controller,
            maxLines: 3,
            style: appTextStyle(
              context,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black.withAlpha(220),
              height: 1.4,
            ),
            decoration: InputDecoration(
              hintText: tr.example_hint,
              hintStyle: appTextStyle(
                context,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(120),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.black.withAlpha(18)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.black.withAlpha(18)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors.goldBrandColor.withAlpha(160),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  final bool enabled;
  final int pricePerPeriod;
  final String? rentType;
  final int periods;
  final int subtotal;
  final int total;

  const _PriceCard({
    required this.enabled,
    required this.pricePerPeriod,
    required this.rentType,
    required this.periods,
    required this.subtotal,
    required this.total,
  });

  String _periodCountLabel() {
    switch (rentType) {
      case 'monthly':
        return tr.months;
      case 'yearly':
        return tr.years;
      default:
        return tr.nights;
    }
  }

  String _periodLabel(BuildContext context) {
    switch (rentType) {
      case 'daily':
        return tr.per_night;
      case 'yearly':
        return tr.per_year;
      default:
        return tr.per_month;
    }
  }

  String _rentTypeLabel() {
    switch (rentType) {
      case 'daily':
        return tr.daily;
      case 'yearly':
        return tr.yearly;
      default:
        return tr.monthly;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: _CardShell(
        child: Column(
          children: [
            if (rentType != null) ...[
              // Rent type badge
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 0.6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.goldBrandColor.withAlpha(22),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.goldBrandColor.withAlpha(80),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 14,
                          color: AppColors.goldBrandColor,
                        ),
                        SizedBox(width: 1.5.w),
                        Text(
                          _rentTypeLabel(),
                          style: appTextStyle(
                            context,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.goldBrandColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
            ],
            _PriceRow(
              label: tr.price_per_period,
              value: pricePerPeriod == 0
                  ? '--'
                  : '$pricePerPeriod ${tr.currency_jod}${_periodLabel(context)}',
            ),
            SizedBox(height: 1.h),
            _PriceRow(
              label: _periodCountLabel(),
              value: enabled ? '$periods' : '--',
            ),
            Divider(color: Colors.black.withAlpha(18), height: 2.4.h),
            _PriceRow(
              label: tr.total_label,
              value: enabled ? '$total ${tr.currency_jod}' : '--',
              bold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PolicyRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withAlpha(18)),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: value ? AppColors.goldBrandColor : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black.withAlpha(30)),
              ),
              child: value
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : const SizedBox.shrink(),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                tr.booking_policy_consent,
                style: appTextStyle(
                  context,
                  fontSize: 10.6.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withAlpha(200),
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withAlpha(18)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 10),
            color: Colors.black.withAlpha(10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _RadioRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RadioRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = selected
        ? AppColors.goldBrandColor.withAlpha(140)
        : Colors.black.withAlpha(18);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.goldBrandColor.withAlpha(18)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black.withAlpha(200)),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: appTextStyle(
                      context,
                      fontSize: 11.2.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withAlpha(230),
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    subtitle,
                    style: appTextStyle(
                      context,
                      fontSize: 10.2.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withAlpha(70)),
                color: selected ? AppColors.goldBrandColor : Colors.white,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _Stepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final decEnabled = value > min;
    final incEnabled = value < max;

    Widget btn(IconData icon, bool enabled, VoidCallback onTap) {
      return InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withAlpha(18)),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Colors.black.withAlpha(enabled ? 200 : 90),
          ),
        ),
      );
    }

    return Row(
      children: [
        btn(Icons.remove_rounded, decEnabled, () => onChanged(value - 1)),
        SizedBox(width: 2.w),
        btn(Icons.add_rounded, incEnabled, () => onChanged(value + 1)),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: appTextStyle(
              context,
              fontSize: 10.8.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black.withAlpha(150),
            ),
          ),
        ),
        Text(
          value,
          style: appTextStyle(
            context,
            fontSize: 11.3.sp,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w800,
            color: Colors.black.withAlpha(230),
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color textColor;

  const _Pill({required this.text, required this.bg, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withAlpha(18)),
      ),
      child: Text(
        text,
        style: appTextStyle(
          context,
          fontSize: 9.8.sp,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  final double rating;

  const _RatingPill({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: AppColors.goldBrandColor.withAlpha(30),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(Icons.star, size: 16, color: AppColors.goldBrandColor),
          SizedBox(width: 1.w),
          Text(
            rating.toStringAsFixed(1),
            style: appTextStyle(
              context,
              fontSize: 10.8.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(230),
            ),
          ),
        ],
      ),
    );
  }
}

// Shows API-returned price breakdown in the success dialog
class _BookingSummaryCard extends StatelessWidget {
  final BookingData data;
  const _BookingSummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(18)),
      ),
      child: Column(
        children: [
          _PriceRow(
            label: tr.total_label,
            value: '${data.finalPrice} ${tr.currency_jod}',
            bold: true,
          ),
          SizedBox(height: 0.6.h),
          Text(
            '#${data.bookingId}',
            style: appTextStyle(
              context,
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black.withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }
}
