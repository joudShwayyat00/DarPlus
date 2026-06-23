import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/appointment/data/models/appointment_response.dart';
import 'package:dar_plus_app/features/appointment/presentation/providers/appointment_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/helpers/asset_ownership_helper.dart';
import 'package:dar_plus_app/utils/ui/app_phone_field.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/auth_required_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

Future<void> showAppointmentSheet(
  BuildContext context, {
  required int assetId,
  required String assetName,
  int? assetOwnerId,
}) async {
  if (isCurrentUserAssetOwner(context, assetOwnerId)) {
    showOwnAssetActionBlockedMessage(context);
    return;
  }

  if (!await requireAuth(
    context,
    message: tr.login_required_appointment,
    icon: Icons.event_available_rounded,
  )) {
    return;
  }
  if (!context.mounted) return;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AppointmentSheet(
      assetId: assetId,
      assetName: assetName,
    ),
  );
}

class AppointmentSheet extends ConsumerStatefulWidget {
  final int assetId;
  final String assetName;

  const AppointmentSheet({
    super.key,
    required this.assetId,
    required this.assetName,
  });

  @override
  ConsumerState<AppointmentSheet> createState() => _AppointmentSheetState();
}

class _AppointmentSheetState extends ConsumerState<AppointmentSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  String _completePhoneNumber = '';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  static String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  static String _displayDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.goldBrandColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.goldBrandColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _toast(String msg) {
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final phone = _completePhoneNumber.isNotEmpty
        ? _completePhoneNumber
        : _phoneCtrl.text.trim();
    final email = _emailCtrl.text.trim();

    if (name.isEmpty || _phoneCtrl.text.trim().isEmpty || email.isEmpty) {
      _toast('Please fill in all required fields');
      return;
    }
    if (_date == null) {
      _toast('Please select a date');
      return;
    }
    if (_time == null) {
      _toast('Please select a time');
      return;
    }

    await ref.read(appointmentControllerProvider.notifier).submit(
          assetId: widget.assetId,
          name: name,
          phone: phone,
          email: email,
          date: _fmtDate(_date!),
          time: _fmtTime(_time!),
          note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        );

    if (!mounted) return;
    final state = ref.read(appointmentControllerProvider);
    state.when(
      data: (data) {
        Navigator.pop(context);
        _showSuccessDialog(context, data);
      },
      error: (e, _) {
        final msg = e.toString().replaceFirst('Exception: ', '');
        _toast(msg);
      },
      loading: () {},
    );
  }

  static void _showSuccessDialog(BuildContext context, AppointmentData? data) {
    showDialog<void>(
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
              Lottie.asset(
                'assets/lottie/success.json',
                width: 140,
                height: 140,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 1.6.h),
              Text(
                'Appointment Requested!',
                style: appTextStyle(
                  context,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withAlpha(230),
                ),
              ),
              SizedBox(height: 0.8.h),
              Text(
                'We will contact you to confirm your visit.',
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
                _AppointmentSummaryCard(data: data),
              ],
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldBrandColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.6.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Done',
                    style: appTextStyle(
                      context,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(appointmentControllerProvider).isLoading;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 5.w,
        right: 5.w,
        top: 2.4.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 3.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(30),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            SizedBox(height: 2.4.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.4.w),
                  decoration: BoxDecoration(
                    color: AppColors.goldBrandColor.withAlpha(22),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.goldBrandColor,
                    size: 22,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr.request_appointment,
                        style: appTextStyle(
                          context,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black.withAlpha(235),
                        ),
                      ),
                      Text(
                        widget.assetName,
                        overflow: TextOverflow.ellipsis,
                        style: appTextStyle(
                          context,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withAlpha(130),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.4.h),
            _AppointmentField(
              controller: _nameCtrl,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline_rounded,
            ),
            SizedBox(height: 1.4.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone Number',
                  style: appTextStyle(
                    context,
                    fontSize: 10.6.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withAlpha(160),
                  ),
                ),
                SizedBox(height: 0.6.h),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: AppPhoneField(
                    controller: _phoneCtrl,
                    hint: 'Phone number',
                    initialCountryCode: 'JO',
                    textInputAction: TextInputAction.next,
                    onChangedCompleteNumber: (v) {
                      _completePhoneNumber = v;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.4.h),
            _AppointmentField(
              controller: _emailCtrl,
              label: 'Email Address',
              hint: 'Enter your email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 1.4.h),
            Row(
              children: [
                Expanded(
                  child: _DateTimePickerTile(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: _date != null ? _displayDate(_date!) : null,
                    placeholder: 'Select date',
                    onTap: _pickDate,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _DateTimePickerTile(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: _time != null ? _fmtTime(_time!) : null,
                    placeholder: 'Select time',
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.4.h),
            _AppointmentField(
              controller: _noteCtrl,
              label: 'Note (optional)',
              hint: 'Any special requests or notes...',
              icon: Icons.notes_rounded,
              maxLines: 3,
            ),
            SizedBox(height: 2.4.h),
            AbsorbPointer(
              absorbing: isLoading,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoading
                        ? AppColors.goldBrandColor.withAlpha(160)
                        : AppColors.goldBrandColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Submit Appointment',
                          style: appTextStyle(
                            context,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
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

class _AppointmentField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;

  const _AppointmentField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: appTextStyle(
            context,
            fontSize: 10.6.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black.withAlpha(160),
          ),
        ),
        SizedBox(height: 0.6.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: appTextStyle(
            context,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withAlpha(220),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: appTextStyle(
              context,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black.withAlpha(100),
            ),
            prefixIcon: Icon(icon, size: 20, color: AppColors.goldBrandColor),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.4.h,
            ),
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
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DateTimePickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  const _DateTimePickerTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: appTextStyle(
            context,
            fontSize: 10.6.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black.withAlpha(160),
          ),
        ),
        SizedBox(height: 0.6.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.4.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasValue
                    ? AppColors.goldBrandColor.withAlpha(120)
                    : Colors.black.withAlpha(18),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.goldBrandColor),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    value ?? placeholder,
                    overflow: TextOverflow.ellipsis,
                    style: appTextStyle(
                      context,
                      fontSize: 10.8.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withAlpha(hasValue ? 220 : 110),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AppointmentSummaryCard extends StatelessWidget {
  final AppointmentData data;

  const _AppointmentSummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.goldBrandColor.withAlpha(12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(60)),
      ),
      child: Column(
        children: [
          _SummaryRow(icon: Icons.calendar_today_rounded, value: data.date),
          SizedBox(height: 0.8.h),
          _SummaryRow(icon: Icons.access_time_rounded, value: data.time),
          SizedBox(height: 0.8.h),
          _SummaryRow(icon: Icons.person_outline_rounded, value: data.name),
          SizedBox(height: 0.8.h),
          _SummaryRow(
            icon: Icons.tag_rounded,
            value: 'Appointment #${data.id}',
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const _SummaryRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.goldBrandColor),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            value,
            style: appTextStyle(
              context,
              fontSize: 10.8.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black.withAlpha(210),
            ),
          ),
        ),
      ],
    );
  }
}
