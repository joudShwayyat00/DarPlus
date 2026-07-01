import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/packages/data/models/payment_info_response.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_net_image.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class PaymentInfoCard extends StatelessWidget {
  final PaymentInfoResponse info;

  const PaymentInfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final fields = <_PaymentField>[
      _PaymentField(tr.bank_account_name, info.bankAccountName),
      _PaymentField(tr.bank_account_number, info.bankAccountNumber),
      _PaymentField(tr.bank_iban, info.bankIban),
      _PaymentField(tr.bank_swift, info.bankSwift),
      _PaymentField(tr.bank_cliq, info.bankCliq),
      _PaymentField(tr.bank_phone, info.bankPhone),
    ].where((field) => field.value.trim().isNotEmpty).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(4.5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.8.w),
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor.withAlpha(22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance_rounded,
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
                      tr.payment_info_title,
                      style: appTextStyle(
                        context,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.black.withAlpha(220),
                      ),
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      tr.payment_info_subtitle,
                      style: appTextStyle(
                        context,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withAlpha(110),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (info.bankImage != null && info.bankImage!.isNotEmpty) ...[
            SizedBox(height: 1.5.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AppNetImage(
                url: info.bankImage!,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ],
          SizedBox(height: 1.5.h),
          ...fields.map(
            (field) => PaymentInfoRow(label: field.label, value: field.value),
          ),
        ],
      ),
    );
  }
}

class PaymentInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const PaymentInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7F4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: appTextStyle(
                      context,
                      fontSize: 8.8.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withAlpha(100),
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    value,
                    style: appTextStyle(
                      context,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withAlpha(210),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(tr.copied_to_clipboard),
                    backgroundColor: Colors.black.withAlpha(220),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: Icon(
                Icons.copy_rounded,
                size: 18,
                color: AppColors.goldBrandColor.withAlpha(200),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              tooltip: tr.copied_to_clipboard,
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentInfoLoadingCard extends StatelessWidget {
  const PaymentInfoLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        color: AppColors.goldBrandColor,
        strokeWidth: 2.5,
      ),
    );
  }
}

class PaymentInfoErrorCard extends StatelessWidget {
  final VoidCallback onRetry;

  const PaymentInfoErrorCard({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              tr.something_went_wrong,
              style: appTextStyle(
                context,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(140),
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              tr.try_again,
              style: appTextStyle(
                context,
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.goldBrandColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentField {
  final String label;
  final String value;

  const _PaymentField(this.label, this.value);
}
