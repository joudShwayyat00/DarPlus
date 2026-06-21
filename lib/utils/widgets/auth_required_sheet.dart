import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/controller/shared_prefs.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/auth/login_screen.dart';
import 'package:dar_plus_app/screens/auth/sign_up_screen.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Returns `true` when the user is logged in.
/// Otherwise shows a sign-in bottom sheet and returns `false`.
Future<bool> requireAuth(
  BuildContext context, {
  required String message,
  IconData icon = Icons.lock_outline_rounded,
}) async {
  if (SharedPerfManager().isLoggedIn) return true;
  await showAuthRequiredSheet(context, message: message, icon: icon);
  return false;
}

Future<void> showAuthRequiredSheet(
  BuildContext context, {
  required String message,
  IconData icon = Icons.lock_outline_rounded,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => _AuthRequiredSheet(icon: icon, message: message),
  );
}

class _AuthRequiredSheet extends StatelessWidget {
  final IconData icon;
  final String message;

  const _AuthRequiredSheet({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(6.w, 1.2.h, 6.w, bottomInset + 2.5.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(30),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          SizedBox(height: 2.4.h),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.goldBrandColor.withAlpha(40),
                  AppColors.goldBrandColor.withAlpha(15),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 34, color: AppColors.goldBrandColor),
          ),
          SizedBox(height: 2.h),
          Text(
            tr.sign_in_to_continue,
            textAlign: TextAlign.center,
            style: appTextStyle(
              context,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(235),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: appTextStyle(
              context,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black.withAlpha(120),
              height: 1.45,
            ),
          ),
          SizedBox(height: 2.8.h),
          AppButton(
            backgroundColor: AppColors.goldBrandColor,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: Text(
              tr.login,
              style: appTextStyle(
                context,
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 1.2.h),
          AppButton(
            backgroundColor: Colors.transparent,
            borderColor: AppColors.goldBrandColor,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignUpScreen()),
              );
            },
            child: Text(
              tr.create_account,
              style: appTextStyle(
                context,
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.goldBrandColor,
              ),
            ),
          ),
          SizedBox(height: 0.8.h),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              tr.cancel,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(110),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
