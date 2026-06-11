import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/content/data/models/contact_us_submit_response.dart';
import 'package:dar_plus_app/features/content/presentation/providers/content_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_input_field.dart';
import 'package:dar_plus_app/utils/ui/app_phone_field.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class GetHelpScreen extends ConsumerStatefulWidget {
  const GetHelpScreen({super.key});

  @override
  ConsumerState<GetHelpScreen> createState() => _GetHelpScreenState();
}

class _GetHelpScreenState extends ConsumerState<GetHelpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _messageFocusNode = FocusNode();
  String? _completePhoneNumber;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<ContactUsSubmitResponse?>>(
      contactUsSubmitControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (data == null) return;
            EasyLoading.dismiss();
            if (data.isSuccess) {
              EasyLoading.showSuccess(
                data.displayMessage.isNotEmpty
                    ? data.displayMessage
                    : tr.message_sent_successfully,
              );
              Navigator.of(context).pop();
            } else {
              EasyLoading.showError(
                data.displayMessage.isNotEmpty
                    ? data.displayMessage
                    : tr.error_occurred,
              );
            }
          },
          error: (error, _) {
            EasyLoading.dismiss();
            EasyLoading.showError(error.toString());
          },
          loading: () => EasyLoading.show(status: tr.loading),
        );
      },
    );

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black.withAlpha(200),
            size: 20,
          ),
        ),
        title: Text(
          tr.get_help,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              _buildHeader(context),
              SizedBox(height: 3.h),
              _buildForm(context),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.goldBrandColor.withAlpha(20),
            AppColors.goldBrandColor.withAlpha(10),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(30)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.goldBrandColor.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.support_agent_rounded,
              color: AppColors.goldBrandColor,
              size: 40,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            tr.how_can_we_help_you,
            style: appTextStyle(
              context,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black.withAlpha(220),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            tr.send_us_a_message,
            textAlign: TextAlign.center,
            style: appTextStyle(
              context,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black.withAlpha(120),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withAlpha(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fieldLabel(context, tr.full_name),
            SizedBox(height: 1.h),
            AppInputField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              hint: tr.enter_your_name,
              prefixIcon: Icons.person_outline,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_phoneFocusNode),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return tr.name_required;
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),
            _fieldLabel(context, tr.phone_number),
            SizedBox(height: 1.h),
            Directionality(
              textDirection: TextDirection.ltr,
              child: AppPhoneField(
                controller: _phoneController,
                focusNode: _phoneFocusNode,
                hint: tr.phone_number,
                initialCountryCode: 'JO',
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_emailFocusNode),
                onChangedCompleteNumber: (completeNumber) {
                  _completePhoneNumber = completeNumber;
                },
              ),
            ),
            SizedBox(height: 2.h),
            _fieldLabel(context, tr.email),
            SizedBox(height: 1.h),
            AppInputField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              hint: tr.email,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_messageFocusNode),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return tr.email_required;
                }
                if (!_isValidEmail(value.trim())) {
                  return tr.enter_valid_email;
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),
            _fieldLabel(context, tr.message),
            SizedBox(height: 1.h),
            TextFormField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                color: AppColors.blackColor,
              ),
              decoration: _messageDecoration(context, tr.describe_issue),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return tr.message_is_required;
                }
                return null;
              },
            ),
            SizedBox(height: 2.5.h),
            AppButton(
              backgroundColor: AppColors.goldBrandColor,
              onPressed: _submit,
              child: Text(
                tr.send_message,
                style: appTextStyle(
                  context,
                  fontSize: 12.2.sp,
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final phone = _completePhoneNumber?.trim().isNotEmpty == true
        ? _completePhoneNumber!.trim()
        : _phoneController.text.trim();

    ref.read(contactUsSubmitControllerProvider.notifier).submit(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: phone,
          message: _messageController.text.trim(),
        );
  }

  Widget _fieldLabel(BuildContext context, String label) {
    return Text(
      label,
      style: appTextStyle(
        context,
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black.withAlpha(180),
      ),
    );
  }

  InputDecoration _messageDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: appTextStyle(
        context,
        fontSize: 10.8.sp,
        color: AppColors.grayBrandColor.withAlpha(102),
      ),
      filled: true,
      fillColor: AppColors.whiteColor.withAlpha(13),
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.grayBrandColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.grayBrandColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.grayBrandColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      errorStyle: appTextStyle(context, fontSize: 9.5.sp, color: Colors.red),
    );
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }
}
