import 'package:dar_plus_app/features/auth/data/models/register_response.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/bottom_nav_bar_screen.dart';
import 'package:dar_plus_app/screens/auth/sign_up_screen.dart';
import 'package:dar_plus_app/screens/auth/forgot_password_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_auth_background.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_input_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/configuration/app_images.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  final passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<RegisterResponse?>>(loginControllerProvider, (
      previous,
      next,
    ) {
      next.when(
        data: (data) {
          if (data != null) {
            EasyLoading.dismiss();
            EasyLoading.showSuccess(tr.done);
            AppNavigator.of(
              context,
            ).pushAndRemoveUntil(const BottomNavBarScreen());
          }
        },
        error: (error, stackTrace) {
          EasyLoading.dismiss();
          String message = tr.error_occurred;
          if (error is DioException) {
            final data = error.response?.data;
            if (data is Map && data['message'] != null) {
              message = data['message'].toString();
            }
          }
          EasyLoading.showError(message);
        },
        loading: () {
          EasyLoading.show(status: tr.loading);
        },
      );
    });

    return AppAuthBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                              tr.welcome_back,
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
                                Text(
                                  tr.sign_in_to_continue,
                                  style: appTextStyle(
                                    context,
                                    fontSize: 10.6.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 3.h),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  AppInputField(
                                    controller: emailController,
                                    focusNode: emailFocusNode,
                                    hint: tr.email,
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(passwordFocusNode);
                                    },
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

                                  SizedBox(height: 2.h),

                                  AppInputField(
                                    controller: passwordController,
                                    focusNode: passwordFocusNode,
                                    hint: tr.password,
                                    prefixIcon: Icons.lock_outline,
                                    obscure: _obscure,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    suffixIcon: IconButton(
                                      onPressed: () =>
                                          setState(() => _obscure = !_obscure),
                                      icon: Icon(
                                        _obscure
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.length < 6) {
                                        return tr.password_min_length;
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 1.2.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  AppNavigator.of(
                                    context,
                                  ).push(const ForgotPasswordScreen());
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(10),
                                  foregroundColor: AppColors.goldBrandColor,
                                ),
                                child: Text(
                                  tr.forgot_password,
                                  style: appTextStyle(
                                    context,
                                    fontSize: 10.2.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.goldBrandColor,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 2.h),
                            AppButton(
                              backgroundColor: AppColors.goldBrandColor,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ref
                                      .read(loginControllerProvider.notifier)
                                      .login(
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                      );
                                }
                              },
                              child: Text(
                                tr.login,
                                style: appTextStyle(
                                  context,
                                  fontSize: 12.2.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.black.withAlpha(20),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                  ),
                                  child: Text(
                                    tr.or,
                                    style: appTextStyle(
                                      context,
                                      fontSize: 11.sp,
                                      color: Colors.black.withAlpha(115),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.black.withAlpha(20),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 2.h),
                            AppButton(
                              backgroundColor: Colors.transparent,
                              borderColor: AppColors.goldBrandColor,
                              onPressed: () {
                                AppNavigator.of(context).push(SignUpScreen());
                              },
                              child: Text(
                                tr.create_account,
                                style: appTextStyle(
                                  context,
                                  fontSize: 12.2.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.goldBrandColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      Text(
                        tr.by_continuing_you_agree_to_our_terms_and_privacy,
                        textAlign: TextAlign.center,
                        style: appTextStyle(
                          context,
                          fontSize: 9.5.sp,
                          color: Colors.black.withAlpha(115),
                        ),
                      ),
                      SizedBox(height: 2.h),
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
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
}
