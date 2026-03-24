import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_auth_background.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/configuration/app_images.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';

import '../../../features/auth/data/models/forgot_password_response.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<ForgotPasswordResponse?>>(
      forgotPasswordControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (data != null) {
              EasyLoading.dismiss();
              if (data.status) {
                EasyLoading.showSuccess(data.message);
                Navigator.of(context).pop();
              } else {
                EasyLoading.showError(data.message);
              }
            }
          },
          error: (error, stackTrace) {
            EasyLoading.dismiss();
            EasyLoading.showError(error.toString());
          },
          loading: () {
            EasyLoading.show(status: tr.loading);
          },
        );
      },
    );

    return AppAuthBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: 1.h),
                      Column(
                        children: [
                          Image.asset(
                            appLogo,
                            height: 15.h,
                            fit: BoxFit.contain,
                          ),
                          Text(
                            tr.premium_real_estate,
                            style: appTextStyle(
                              context,
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withAlpha(140),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.black.withAlpha(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(15),
                              blurRadius: 26,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr.forgot_password,
                              style: appTextStyle(
                                context,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.blackColor,
                              ),
                            ),
                            SizedBox(height: 0.8.h),
                            Row(
                              children: [
                                Container(
                                  height: 0.4.h,
                                  width: 12.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.goldBrandColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                SizedBox(width: 2.2.w),
                                Expanded(
                                  child: Text(
                                    tr.enter_valid_email,
                                    style: appTextStyle(
                                      context,
                                      fontSize: 10.6.sp,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            Form(
                              key: _formKey,
                              child: AppInputField(
                                controller: emailController,
                                focusNode: emailFocusNode,
                                hint: tr.email,
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return tr.email_required;
                                  }
                                  if (!isValidEmail(value)) {
                                    return tr.enter_valid_email;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 4.h),
                            AppButton(
                              backgroundColor: AppColors.goldBrandColor,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ref.read(forgotPasswordControllerProvider.notifier).forgotPassword(
                                        emailController.text.trim(),
                                      );
                                }
                              },
                              child: Text(
                                tr.submit,
                                style: appTextStyle(
                                  context,
                                  fontSize: 12.2.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  tr.back,
                                  style: appTextStyle(
                                    context,
                                    color: AppColors.goldBrandColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool isValidEmail(String value) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }
}
