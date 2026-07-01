import 'dart:io';

import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
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

Future<String?> showPaymentSubmissionSheet({
  required BuildContext context,
  required MySubscriptionItem subscription,
}) {
  return showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => PaymentSubmissionSheet(subscription: subscription),
  );
}

Future<void> showPaymentProofSuccessDialog({
  required BuildContext context,
  required String message,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 2.5.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(3.5.w),
              decoration: BoxDecoration(
                color: AppColors.goldBrandColor.withAlpha(28),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: AppColors.goldBrandColor,
                size: 52,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              tr.payment_proof_submitted_title,
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(230),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(160),
                height: 1.45,
              ),
            ),
            SizedBox(height: 0.8.h),
            Text(
              tr.awaiting_admin_approval_message,
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(110),
                height: 1.4,
              ),
            ),
            SizedBox(height: 2.5.h),
            AppButton(
              height: 5.5.h,
              backgroundColor: AppColors.goldBrandColor,
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                tr.done,
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

class PaymentSubmissionSheet extends ConsumerStatefulWidget {
  final MySubscriptionItem subscription;

  const PaymentSubmissionSheet({super.key, required this.subscription});

  @override
  ConsumerState<PaymentSubmissionSheet> createState() =>
      _PaymentSubmissionSheetState();
}

class _PaymentSubmissionSheetState extends ConsumerState<PaymentSubmissionSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();
  final _amountFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _picker = ImagePicker();
  File? _receiptImage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.subscription.package.price;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ref.read(profileControllerProvider).value;
    if (user != null) {
      if (_nameController.text.isEmpty) _nameController.text = user.name;
      if (_phoneController.text.isEmpty) {
        _phoneController.text = user.phoneNumber;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _amountFocus.dispose();
    _phoneFocus.dispose();
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
    final name = _nameController.text.trim();
    final amount = _amountController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || amount.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr.please_fill_all_fields),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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
      final response =
          await ref.read(uploadProofControllerProvider.notifier).submit(
                transferName: name,
                transferAmount: amount,
                transferPhone: phone,
                receiptPath: _receiptImage!.path,
                pendingSubscriptionIds: [widget.subscription.id],
              );
      if (!mounted) return;
      Navigator.of(context).pop(response.message);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted && _isSubmitting) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

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
              _fieldLabel(tr.transfer_name),
              SizedBox(height: 0.6.h),
              AppInputField(
                controller: _nameController,
                focusNode: _nameFocus,
                hint: tr.full_name,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _amountFocus.requestFocus(),
              ),
              SizedBox(height: 1.5.h),
              _fieldLabel(tr.payment_amount),
              SizedBox(height: 0.6.h),
              AppInputField(
                controller: _amountController,
                focusNode: _amountFocus,
                hint: '10.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 3.w),
                  child: Text(
                    kAppCurrency,
                    style: appTextStyle(
                      context,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.goldBrandColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 1.5.h),
              _fieldLabel(tr.phone_number),
              SizedBox(height: 0.6.h),
              AppInputField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                hint: tr.phone_number,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 2.h),
              _fieldLabel(tr.payment_receipt_image),
              SizedBox(height: 0.8.h),
              GestureDetector(
                onTap: _showImageSourcePicker,
                child: Container(
                  height: 20.h,
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
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
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

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: appTextStyle(
        context,
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black.withAlpha(160),
      ),
    );
  }
}
