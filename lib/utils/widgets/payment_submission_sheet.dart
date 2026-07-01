import 'dart:io';

import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/features/packages/data/models/my_subscription_item.dart';
import 'package:dar_plus_app/features/packages/presentation/providers/packages_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_input_field.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

Future<bool?> showPaymentSubmissionSheet({
  required BuildContext context,
  required MySubscriptionItem subscription,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => PaymentSubmissionSheet(subscription: subscription),
  );
}

class PaymentSubmissionSheet extends ConsumerStatefulWidget {
  final MySubscriptionItem subscription;

  const PaymentSubmissionSheet({super.key, required this.subscription});

  @override
  ConsumerState<PaymentSubmissionSheet> createState() =>
      _PaymentSubmissionSheetState();
}

class _PaymentSubmissionSheetState extends ConsumerState<PaymentSubmissionSheet> {
  final _transactionController = TextEditingController();
  final _transactionFocus = FocusNode();
  final _picker = ImagePicker();
  File? _receiptImage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _transactionController.dispose();
    _transactionFocus.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (picked != null && mounted) {
      setState(() => _receiptImage = File(picked.path));
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(tr.gallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_rounded),
                title: Text(tr.camera),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_receiptImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr.payment_image_required),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final message = await ref
          .read(paymentCallbackControllerProvider.notifier)
          .submit(
            subscriptionId: widget.subscription.id,
            amount: widget.subscription.package.price,
            transactionId: _transactionController.text.trim().isEmpty
                ? null
                : _transactionController.text.trim(),
            imagePath: _receiptImage!.path,
          );
      if (!mounted) return;
      Navigator.pop(context, true);
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
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final amount = widget.subscription.package.price;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(30),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                tr.submit_payment_proof,
                style: appTextStyle(
                  context,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withAlpha(220),
                ),
              ),
              SizedBox(height: 0.8.h),
              Text(
                tr.upload_receipt_hint,
                style: appTextStyle(
                  context,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withAlpha(110),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(
                      tr.payment_amount,
                      style: appTextStyle(
                        context,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(130),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$amount $kAppCurrency',
                      style: appTextStyle(
                        context,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.goldBrandColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                tr.transaction_id,
                style: appTextStyle(
                  context,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withAlpha(160),
                ),
              ),
              SizedBox(height: 0.8.h),
              AppInputField(
                controller: _transactionController,
                focusNode: _transactionFocus,
                hint: tr.transaction_id_hint,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 2.h),
              Text(
                tr.payment_receipt_image,
                style: appTextStyle(
                  context,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withAlpha(160),
                ),
              ),
              SizedBox(height: 0.8.h),
              GestureDetector(
                onTap: _showImageSourcePicker,
                child: Container(
                  height: 22.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F7F4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _receiptImage != null
                          ? AppColors.goldBrandColor
                          : Colors.black.withAlpha(20),
                      width: _receiptImage != null ? 2 : 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _receiptImage != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(_receiptImage!, fit: BoxFit.cover),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Material(
                                color: Colors.black.withAlpha(160),
                                borderRadius: BorderRadius.circular(20),
                                child: InkWell(
                                  onTap: _showImageSourcePicker,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.edit_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_rounded,
                              size: 36,
                              color: AppColors.goldBrandColor.withAlpha(180),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              tr.tap_to_upload_receipt,
                              style: appTextStyle(
                                context,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withAlpha(120),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 2.5.h),
              AppButton(
                backgroundColor: AppColors.goldBrandColor,
                onPressed: _isSubmitting ? () {} : _submit,
                child: _isSubmitting
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.whiteColor,
                          ),
                        ),
                      )
                    : Text(
                        tr.submit_payment_proof,
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
      ),
    );
  }
}
