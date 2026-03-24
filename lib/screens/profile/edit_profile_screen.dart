import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/configuration/app_images.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_input_field.dart';
import 'package:dar_plus_app/utils/ui/app_phone_field.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: "John Doe");
  final FocusNode nameFocusNode = FocusNode();

  final phoneController = TextEditingController(text: "799999999");
  final FocusNode phoneFocusNode = FocusNode();

  final emailController = TextEditingController(text: "johndoe@email.com");
  final FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.dispose();
    phoneController.dispose();
    phoneFocusNode.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          tr.edit_profile,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            SizedBox(height: 1.3.h),

            Image.asset(appLogo, height: 20.h, fit: BoxFit.contain),

            SizedBox(height: 2.h),

            // Form
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
                    _buildLabel(context, tr.full_name),
                    SizedBox(height: 1.h),
                    AppInputField(
                      controller: nameController,
                      focusNode: nameFocusNode,
                      hint: tr.full_name,
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(phoneFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return tr.name_required;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 2.5.h),

                    _buildLabel(context, tr.phone_number),
                    SizedBox(height: 1.h),
                    AppPhoneField(
                      controller: phoneController,
                      focusNode: phoneFocusNode,
                      hint: tr.phone_number,
                      initialCountryCode: "JO",
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(emailFocusNode);
                      },
                    ),

                    SizedBox(height: 2.5.h),

                    _buildLabel(context, tr.email),
                    SizedBox(height: 1.h),
                    AppInputField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      hint: tr.email,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return tr.email_required;
                        }
                        final pattern =
                            r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
                        if (!RegExp(pattern).hasMatch(value.trim())) {
                          return tr.enter_valid_email;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 4.h),

            AppButton(
              backgroundColor: AppColors.goldBrandColor,
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState!.validate()) {
                  // TODO: Save profile changes
                  Navigator.pop(context);
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

            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
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
}
