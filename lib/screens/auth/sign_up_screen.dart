import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/bottom_nav_bar_screen.dart';
import 'package:dar_plus_app/screens/auth/login_screen.dart';
import 'package:dar_plus_app/screens/profile/privacy_policy_screen.dart';
import 'package:dar_plus_app/screens/profile/terms_conditions_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_auth_background.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_input_field.dart';
import 'package:dar_plus_app/utils/ui/app_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/configuration/app_images.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

enum UserType { owner, customer }

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();

  final phoneController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();

  final emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  final passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  final confirmPasswordController = TextEditingController();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;
  UserType _selectedUserType = UserType.customer;

  String _completePhoneNumber = '';
  String _nationalPhoneNumber = '';
  String _countryCode = '';

  @override
  Widget build(BuildContext context) {
    return AppAuthBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: 0.2.h),
                    Column(
                      children: [
                        Image.asset(appLogo, height: 15.h, fit: BoxFit.contain),
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
                            tr.create_account,
                            style: appTextStyle(
                              context,
                              fontSize: 15.sp,
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
                                tr.sign_up_to_get_started,
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
                                // User type selector (single row, responsive)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ChoiceChip(
                                          label: Text(
                                            tr.role_owner_or_agent,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.clip,
                                            softWrap: true,
                                            style: appTextStyle(
                                              context,
                                              fontSize: 10.sp,
                                              color:
                                                  _selectedUserType ==
                                                      UserType.owner
                                                  ? AppColors.whiteColor
                                                  : Colors.black87,
                                            ),
                                          ),
                                          selected:
                                              _selectedUserType ==
                                              UserType.owner,
                                          onSelected: (_) => setState(
                                            () => _selectedUserType =
                                                UserType.owner,
                                          ),
                                          selectedColor:
                                              AppColors.goldBrandColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: ChoiceChip(
                                          label: Text(
                                            tr.role_user,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.clip,
                                            softWrap: true,
                                            style: appTextStyle(
                                              context,
                                              fontSize: 10.sp,
                                              color:
                                                  _selectedUserType ==
                                                      UserType.customer
                                                  ? AppColors.whiteColor
                                                  : Colors.black87,
                                            ),
                                          ),
                                          selected:
                                              _selectedUserType ==
                                              UserType.customer,
                                          onSelected: (_) => setState(
                                            () => _selectedUserType =
                                                UserType.customer,
                                          ),
                                          selectedColor:
                                              AppColors.goldBrandColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppInputField(
                                  controller: nameController,
                                  focusNode: nameFocusNode,
                                  hint: tr.full_name,
                                  prefixIcon: Icons.person_outline,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(phoneFocusNode);
                                  },
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return tr.name_required;
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 2.h),

                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: AppPhoneField(
                                    controller: phoneController,
                                    focusNode: phoneFocusNode,
                                    hint: tr.phone_number,
                                    initialCountryCode: "JO",
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(emailFocusNode);
                                    },
                                    onChangedCompleteNumber: (completeNumber) {
                                      _completePhoneNumber = completeNumber;
                                    },
                                    onChangedNationalNumber: (national) {
                                      _nationalPhoneNumber = national;
                                    },
                                    onChangedCountryCode: (countryCode) {
                                      _countryCode = countryCode;
                                    },
                                  ),
                                ),
                                SizedBox(height: 2.h),

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
                                    if (value == null || value.trim().isEmpty) {
                                      return tr.email_required;
                                    }
                                    final email = value.trim();
                                    if (!isValidEmail(email)) {
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
                                  obscure: _obscurePassword,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(confirmPasswordFocusNode);
                                  },
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    }),
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.length < 8) {
                                      return tr.password_min_length;
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 2.h),

                                AppInputField(
                                  controller: confirmPasswordController,
                                  focusNode: confirmPasswordFocusNode,
                                  hint: tr.confirm_password,
                                  prefixIcon: Icons.lock_outline,
                                  obscure: _obscureConfirm,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      _obscureConfirm = !_obscureConfirm;
                                    }),
                                    icon: Icon(
                                      _obscureConfirm
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return tr.confirm_password_required;
                                    }
                                    if (value != passwordController.text) {
                                      return tr.passwords_do_not_match;
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _agreedToTerms,
                                  onChanged: (value) => setState(
                                    () => _agreedToTerms = value ?? false,
                                  ),
                                  activeColor: AppColors.goldBrandColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      tr.i_agree_to_the,
                                      style: appTextStyle(
                                        context,
                                        fontSize: 9.8.sp,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => AppNavigator.of(
                                        context,
                                      ).push(const TermsConditionsScreen()),
                                      child: Text(
                                        tr.terms_and_conditions,
                                        style: appTextStyle(
                                          context,
                                          fontSize: 9.8.sp,
                                          color: AppColors.goldBrandColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      tr.and_the,
                                      style: appTextStyle(
                                        context,
                                        fontSize: 9.8.sp,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => AppNavigator.of(
                                        context,
                                      ).push(const PrivacyPolicyScreen()),
                                      child: Text(
                                        tr.privacy_policy,
                                        style: appTextStyle(
                                          context,
                                          fontSize: 9.8.sp,
                                          color: AppColors.goldBrandColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.4.h),
                          const RegisterListener(),
                          AppButton(
                            backgroundColor: AppColors.goldBrandColor,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (!_agreedToTerms) {
                                EasyLoading.showError(tr.please_agree_to_terms);
                                return;
                              }
                              final phoneNumber =
                                  _nationalPhoneNumber.isNotEmpty
                                  ? _nationalPhoneNumber
                                  : phoneController.text.trim();

                              debugPrint('countryCode: $_countryCode');
                              debugPrint(
                                'nationalNumber: $_nationalPhoneNumber',
                              );
                              debugPrint(
                                'completeNumber: $_completePhoneNumber',
                              );
                              debugPrint('sendingPhoneNumber: $phoneNumber');

                              if (_formKey.currentState!.validate()) {
                                final role =
                                    _selectedUserType == UserType.owner
                                    ? 'owner'
                                    : 'customer';

                                ref
                                    .read(registerControllerProvider.notifier)
                                    .register(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                      passwordConfirmation:
                                          confirmPasswordController.text,
                                      phoneNumber: phoneNumber,
                                      role: role,
                                    );
                              }
                            },
                            child: ref
                                .watch(registerControllerProvider)
                                .maybeWhen(
                                  loading: () => const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  orElse: () => Text(
                                    tr.create_account,
                                    style: appTextStyle(
                                      context,
                                      fontSize: 12.2.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        AppNavigator.of(context).push(LoginScreen());
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        foregroundColor: AppColors.goldBrandColor,
                      ),
                      child: Text(
                        tr.already_have_account_login,
                        style: appTextStyle(
                          context,
                          fontSize: 10.2.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.goldBrandColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool isValidEmail(String value) {
    final pattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    return RegExp(pattern).hasMatch(value);
  }

  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.dispose();

    emailController.dispose();
    emailFocusNode.dispose();

    phoneController.dispose();
    phoneFocusNode.dispose();

    passwordController.dispose();
    passwordFocusNode.dispose();

    confirmPasswordController.dispose();
    confirmPasswordFocusNode.dispose();

    super.dispose();
  }
}

class RegisterListener extends ConsumerWidget {
  const RegisterListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String extractServerMessage(Object? error) {
      try {
        final resp = (error as dynamic).response;
        final data = resp?.data;
        if (data is Map) {
          if (data['errors'] is Map) {
            final Map errors = data['errors'] as Map;
            final messages = errors.entries
                .map((e) {
                  final key = e.key.toString();
                  final val = e.value;
                  final joined = val is List ? val.join(', ') : val.toString();
                  final fieldLabel = key == 'password'
                      ? tr.password
                      : key == 'role'
                      ? tr.role
                      : key;
                  return '$fieldLabel: $joined';
                })
                .join('\n');
            return messages;
          } else if (data['message'] is String) {
            return data['message'] as String;
          }
        }
        return error.toString();
      } catch (_) {
        return error.toString();
      }
    }

    ref.listen(registerControllerProvider, (previous, next) {
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
        loading: () {
          EasyLoading.show(status: tr.loading);
        },
        error: (error, stack) {
          EasyLoading.dismiss();
          final msg = extractServerMessage(error);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        },
      );
    });

    return const SizedBox.shrink();
  }
}
