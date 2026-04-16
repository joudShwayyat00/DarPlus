import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/configuration/app_images.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_input_field.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/data/models/update_password_response.dart';

class UpdatePasswordScreen extends ConsumerStatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  ConsumerState<UpdatePasswordScreen> createState() =>
      _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends ConsumerState<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<UpdatePasswordResponse?>>(
      updatePasswordControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (data != null) {
              EasyLoading.dismiss();
              EasyLoading.showSuccess(data.message);
              Navigator.pop(context);
            }
          },
          loading: () {
            EasyLoading.show(status: tr.loading);
          },
          error: (error, stack) {
            EasyLoading.dismiss();
            EasyLoading.showError(error.toString());
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text(
          tr.change_password,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black.withAlpha(200),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Column(
          children: [
            Image.asset(appLogo, height: 18.h, fit: BoxFit.contain),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black.withAlpha(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.new_password,
                      style: appTextStyle(
                        context,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withAlpha(180),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    AppInputField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      hint: tr.password,
                      prefixIcon: Icons.lock_outline,
                      obscure: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(
                          context,
                        ).requestFocus(confirmPasswordFocusNode);
                      },
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return tr.password_required;
                        }
                        if (value.length < 6) {
                          return tr.password_min_length;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.5.h),
                    Text(
                      tr.confirm_password,
                      style: appTextStyle(
                        context,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withAlpha(180),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    AppInputField(
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordFocusNode,
                      hint: tr.confirm_password,
                      prefixIcon: Icons.lock_outline,
                      obscure: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return tr.confirm_password_required;
                        if (value != passwordController.text)
                          return tr.passwords_do_not_match;
                        return null;
                      },
                    ),
                    SizedBox(height: 4.h),
                    AppButton(
                      backgroundColor: AppColors.goldBrandColor,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          ref
                              .read(updatePasswordControllerProvider.notifier)
                              .updatePassword(
                                password: passwordController.text.trim(),
                                passwordConfirmation: confirmPasswordController
                                    .text
                                    .trim(),
                              );
                        }
                      },
                      child: Text(
                        tr.save_changes,
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
            ),
          ],
        ),
      ),
    );
  }
}
