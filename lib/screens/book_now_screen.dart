import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/models/property_item.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/app_net_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';

class BookingScreen extends StatefulWidget {
  final PropertyItem item;

  const BookingScreen({super.key, required this.item});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _checkIn;
  int _nights = 1;
  int _guests = 2;

  PaymentMethod _payment = PaymentMethod.cash;
  bool _agree = true;

  final TextEditingController _notes = TextEditingController();

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  int _pricePerNightJod() {
    final raw = widget.item.price;
    final digits = RegExp(
      r'\d+',
    ).allMatches(raw).map((m) => m.group(0)!).toList();
    if (digits.isEmpty) return 0;
    return int.tryParse(digits.first) ?? 0;
  }

  DateTime? get _checkOut {
    if (_checkIn == null) return null;
    return DateTime(
      _checkIn!.year,
      _checkIn!.month,
      _checkIn!.day,
    ).add(Duration(days: _nights));
  }

  int _serviceFee(int subtotal) {
    final fee = (subtotal * 0.06).round();
    return fee < 3 ? 3 : fee;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final maxGuests = item.guests <= 0 ? 20 : item.guests;
    if (_guests > maxGuests) _guests = maxGuests;

    final pricePerNight = _pricePerNightJod();
    final subtotal = (_checkIn == null) ? 0 : _nights * pricePerNight;
    final fee = (_checkIn == null) ? 0 : _serviceFee(subtotal);
    final total = subtotal + fee;

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
              onPickCheckIn: () async {
                final now = DateTime.now();

                final picked = await showDatePicker(
                  context: context,
                  initialDate: _checkIn ?? now,
                  firstDate: DateTime(now.year, now.month, now.day),
                  lastDate: DateTime(now.year + 1),
                  builder: (context, child) {
                    final baseTheme = Theme.of(context);

                    return Theme(
                      data: baseTheme.copyWith(
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
                          headerHelpStyle: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withAlpha(180),
                          ),
                          weekdayStyle: TextStyle(fontWeight: FontWeight.w700),
                          dayStyle: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        textTheme: baseTheme.textTheme.copyWith(
                          bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5.sp,
                          ),
                          bodySmall: baseTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 9.5.sp,
                          ),
                          titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14.sp,
                          ),
                          labelLarge: baseTheme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
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

                if (picked != null) {
                  setState(() => _checkIn = picked);
                }
              },
              onClear: () => setState(() => _checkIn = null),
              onNightsChanged: (v) => setState(() => _nights = v),
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
            _PaymentCard(
              value: _payment,
              onChanged: (m) => setState(() => _payment = m),
            ),

            SizedBox(height: 2.0.h),

            _SectionTitle(text: tr.notes),
            SizedBox(height: 1.2.h),
            _NotesCard(controller: _notes),

            SizedBox(height: 2.0.h),

            _SectionTitle(text: tr.price_summary),
            SizedBox(height: 1.2.h),
            _PriceCard(
              enabled: _checkIn != null,
              pricePerNight: pricePerNight,
              nights: _nights,
              subtotal: subtotal,
              fee: fee,
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
              AppButton(
                height: 6.0.h,
                width: 60.w,
                backgroundColor: AppColors.goldBrandColor,
                onPressed: () {
                  if (_checkIn == null) {
                    _toast(context, tr.please_select_checkin_date);
                    return;
                  }
                  if (!_agree) {
                    _toast(context, tr.please_accept_booking_policy);
                    return;
                  }
                  _showSuccessDialog(context);
                },
                child: Text(
                  tr.confirm_booking,
                  style: appTextStyle(
                    context,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
                      _checkIn == null ? "--" : "$total ${tr.currency_jod}",
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

  void _showSuccessDialog(BuildContext context) {
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

enum PaymentMethod { cash, card }

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
  final VoidCallback onPickCheckIn;
  final VoidCallback onClear;
  final ValueChanged<int> onNightsChanged;

  const _StayCard({
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.onPickCheckIn,
    required this.onClear,
    required this.onNightsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final has = checkIn != null;

    return _CardShell(
      child: Column(
        children: [
          InkWell(
            onTap: onPickCheckIn,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(3.6.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withAlpha(18)),
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
                      color: Colors.black.withAlpha(200),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr.check_in_date,
                          style: appTextStyle(
                            context,
                            fontSize: 10.6.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withAlpha(150),
                          ),
                        ),
                        SizedBox(height: 0.35.h),
                        Text(
                          has ? _fmt(checkIn!) : tr.select_date,
                          style: appTextStyle(
                            context,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.black.withAlpha(230),
                          ),
                        ),
                        if (has && checkOut != null) ...[
                          SizedBox(height: 0.25.h),
                          Text(
                            "${tr.check_out}: ${_fmt(checkOut!)}",
                            style: appTextStyle(
                              context,
                              fontSize: 10.2.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withAlpha(140),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (has)
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
                      color: Colors.black.withAlpha(170),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 1.2.h),

          Row(
            children: [
              Expanded(
                child: Text(
                  tr.nights,
                  style: appTextStyle(
                    context,
                    fontSize: 11.2.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withAlpha(220),
                  ),
                ),
              ),
              _Stepper(
                value: nights,
                min: 1,
                max: 30,
                onChanged: onNightsChanged,
              ),
            ],
          ),
          SizedBox(height: 0.4.h),
          Text(
            tr.one_night_tip,
            style: appTextStyle(
              context,
              fontSize: 10.2.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black.withAlpha(140),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmt(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
  }
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
  final PaymentMethod value;
  final ValueChanged<PaymentMethod> onChanged;

  const _PaymentCard({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        children: [
          _RadioRow(
            title: tr.cash_on_arrival,
            subtitle: tr.pay_when_checkin,
            icon: Icons.payments_outlined,
            selected: value == PaymentMethod.cash,
            onTap: () => onChanged(PaymentMethod.cash),
          ),
          Divider(color: Colors.black.withAlpha(18), height: 2.2.h),
          _RadioRow(
            title: tr.credit_debit_card,
            subtitle: tr.pay_securely_online,
            icon: Icons.credit_card,
            selected: value == PaymentMethod.card,
            onTap: () => onChanged(PaymentMethod.card),
          ),
        ],
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
  final int pricePerNight;
  final int nights;
  final int subtotal;
  final int fee;
  final int total;

  const _PriceCard({
    required this.enabled,
    required this.pricePerNight,
    required this.nights,
    required this.subtotal,
    required this.fee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: _CardShell(
        child: Column(
          children: [
            _PriceRow(
              label: tr.nightly_price,
              value: pricePerNight == 0
                  ? "--"
                  : "$pricePerNight ${tr.currency_jod}${tr.per_night}",
            ),
            SizedBox(height: 1.h),
            _PriceRow(label: tr.nights, value: enabled ? "$nights" : "--"),
            Divider(color: Colors.black.withAlpha(18), height: 2.4.h),
            _PriceRow(
              label: tr.subtotal,
              value: enabled ? "$subtotal ${tr.currency_jod}" : "--",
            ),
            SizedBox(height: 0.8.h),
            _PriceRow(
              label: tr.service_fee,
              value: enabled ? "$fee ${tr.currency_jod}" : "--",
            ),
            Divider(color: Colors.black.withAlpha(18), height: 2.4.h),
            _PriceRow(
              label: tr.total_label,
              value: enabled ? "$total ${tr.currency_jod}" : "--",
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
