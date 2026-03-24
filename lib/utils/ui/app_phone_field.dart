import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sizer/sizer.dart';

class AppPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hint;
  final String initialCountryCode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  final ValueChanged<String>? onChangedCompleteNumber;

  final FormFieldValidator<String>? validator;

  const AppPhoneField({
    super.key,
    required this.controller,
    this.focusNode,
    this.hint,
    this.initialCountryCode = "JO",
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChangedCompleteNumber,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder({Color? borderColor}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor ?? AppColors.grayBrandColor),
      );
    }

    return FormField<String>(
      initialValue: controller.text,
      validator: (_) {
        final value = controller.text.trim();

        if (value.isEmpty) return tr.phone_is_required;

        if (!RegExp(r'^\d+$').hasMatch(value)) return tr.digits_only;
        if (value.length < 10) return tr.enter_valid_phone_number;

        if (validator != null) return validator!(value);

        return null;
      },
      builder: (state) {
        return IntlPhoneField(
          controller: controller,
          focusNode: focusNode,
          initialCountryCode: initialCountryCode,
          disableLengthCheck: true,
          dropdownIconPosition: IconPosition.trailing,
          cursorColor: AppColors.blackColor,
          textInputAction: textInputAction,
          onSubmitted: (value) => onFieldSubmitted?.call(value),
          flagsButtonPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          dropdownTextStyle: appTextStyle(
            context,
            fontSize: 11.sp,
            color: AppColors.blackColor,
          ),
          style: appTextStyle(
            context,
            fontSize: 11.sp,
            color: AppColors.blackColor,
          ),
          textAlign: TextAlign.left,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            hintText: hint ?? tr.phone_number,
            hintStyle: appTextStyle(
              context,
              fontSize: 10.8.sp,
              color: AppColors.grayBrandColor.withAlpha(102),
            ),

            errorText: state.errorText,

            errorStyle: appTextStyle(
              context,
              fontSize: 9.5.sp,
              color: Colors.red,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 1.55.h,
              horizontal: 3.w,
            ),
            enabledBorder: outlineInputBorder(),
            focusedBorder: outlineInputBorder(),
            errorBorder: outlineInputBorder(borderColor: Colors.red),
            focusedErrorBorder: outlineInputBorder(),
          ),
          onChanged: (phone) {
            state.didChange(controller.text);

            onChangedCompleteNumber?.call(phone.completeNumber);
          },
        );
      },
    );
  }
}
