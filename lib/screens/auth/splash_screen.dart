import 'dart:async';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/configuration/app_images.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/controller/shared_prefs.dart';
import 'package:dar_plus_app/screens/auth/welcome_screen.dart';
import 'package:dar_plus_app/screens/bottom_nav_bar_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  Future<void> _startSplashTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    if (SharedPerfManager().isLoggedIn) {
      AppNavigator.of(context).pushAndRemoveUntil(const BottomNavBarScreen());
    } else {
      AppNavigator.of(context).pushAndRemoveUntil(const WelcomeScreen());
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
    _startSplashTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blackColor,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              splashImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              filterQuality: FilterQuality.high,
            ),
            SafeArea(
              child: FadeTransition(
                opacity: _fade,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    children: [
                      const Spacer(flex: 7),
                      Column(
                        children: [
                          SizedBox(
                            width: 6.w,
                            height: 6.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.goldBrandColor,
                              ),
                              backgroundColor: AppColors.grayBrandColor
                                  .withAlpha(89),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            tr.loading,
                            style: appTextStyle(
                              context,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grayBrandColor.withAlpha(242),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
