import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/auth/login_screen.dart';
import 'package:dar_plus_app/screens/auth/sign_up_screen.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Full-screen prompt shown when a feature requires authentication.
class LoginRequiredView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const LoginRequiredView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.goldBrandColor.withAlpha(35),
                    AppColors.goldBrandColor.withAlpha(15),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.goldBrandColor.withAlpha(50),
                ),
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.goldBrandColor,
              ),
            ),
            SizedBox(height: 2.8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(230),
              ),
            ),
            SizedBox(height: 1.2.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(120),
                height: 1.5,
              ),
            ),
            SizedBox(height: 3.5.h),
            AppButton(
              backgroundColor: AppColors.goldBrandColor,
              onPressed: () {
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
            SizedBox(height: 1.5.h),
            AppButton(
              backgroundColor: Colors.transparent,
              borderColor: AppColors.goldBrandColor,
              onPressed: () {
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
          ],
        ),
      ),
    );
  }
}
