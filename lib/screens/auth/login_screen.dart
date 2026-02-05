import 'package:dar_plus_app/screens/bottom_nav_bar_screen.dart';
import 'package:dar_plus_app/screens/auth/sign_up_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_auth_background.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_input_field.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/configuration/app_images.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final FocusNode emailFocusNode =FocusNode();

  final passwordController = TextEditingController();
  final FocusNode passwordFocusNode =FocusNode();

  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
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
                          Image.asset(appLogo, height: 15.h, fit: BoxFit.contain),
                          Text(
                            "Premium Real Estate",
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
                              "Welcome Back",
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
                                  "Sign in to continue",
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
                                    hint: "Email",
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context).requestFocus(passwordFocusNode);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Email is required";
                                      }
                                      if (!isValidEmail(value)){
                                        return "Enter a valid email";
                                      }
                                      return null;
                                    },
                                  ),
            
                                  SizedBox(height: 2.h),
            
                                  AppInputField(
                                    controller: passwordController,
                                    focusNode: passwordFocusNode,
                                    hint: "Password",
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
                                        return "Password must be at least 6 characters";
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
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(10),
                                  foregroundColor: AppColors.goldBrandColor,
                                ),
                                child: Text(
                                  "Forgot password?",
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
                                AppNavigator.of(context).push(BottomNavBarScreen());
                                // if (_formKey.currentState!.validate()) {}
                              },
                              child: Text(
                                "Login",
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
                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                  child: Text(
                                    "or",
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
                                "Create Account",
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
                        "By continuing, you agree to our Terms & Privacy.",
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
