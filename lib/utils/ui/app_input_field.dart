import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hint;
  final bool obscure;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const AppInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.hint,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      cursorColor: AppColors.blackColor,
      style: appTextStyle(
        context,
        fontSize: 11.sp,
        color: AppColors.blackColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: appTextStyle(
          context,
          fontSize: 10.8.sp,
          color: AppColors.grayBrandColor.withAlpha(102),
        ),
        alignLabelWithHint: true,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.grayBrandColor)
            : null,
        filled: true,
        fillColor: AppColors.whiteColor.withAlpha(13),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
        border: outlineInputBorder(),
        focusedBorder: outlineInputBorder(),
        enabledBorder: outlineInputBorder(),
        disabledBorder: outlineInputBorder(),
        errorBorder: outlineInputBorder(borderColor: Colors.red),
        errorStyle: appTextStyle(
          context,
          fontSize: 9.5.sp,
          color: Colors.red,
        ),
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({Color? borderColor}) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color:borderColor??AppColors.grayBrandColor));
  }
}
