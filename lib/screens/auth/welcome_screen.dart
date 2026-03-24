import 'dart:ui';

import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/configuration/app_images.dart';
import 'package:dar_plus_app/controller/shared_prefs.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/auth/login_screen.dart';
import 'package:dar_plus_app/screens/auth/sign_up_screen.dart';
import 'package:dar_plus_app/screens/bottom_nav_bar_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final topHeight = 53.h;
    final topHeight = (SharedPerfManager().languageCode == "en") ? 53.h : 58.h;


    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.blackColor,
          body: Stack(
            children: [
              SizedBox(height: 100.h, width: 100.w),
              SizedBox(
                height: topHeight,
                width: 100.w,
                child: ClipPath(
                  clipper: _ArchitectClipper(),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        welcomeBgImage,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: topHeight - 5.2.h,
                left: (SharedPerfManager().languageCode == "en") ? 7.w : null,
                right: (SharedPerfManager().languageCode == "ar") ? 7.w : null,
                child: Container(
                  height: 0.45.h,
                  width: 22.w,
                  decoration: BoxDecoration(
                    color: AppColors.goldBrandColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Positioned(
                left: 5.w,
                right: 5.w,
                bottom: 2.5.h,
                child: FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          width: 100.w,
                          padding: EdgeInsets.fromLTRB(3.w, 2.2.h, 3.w, 2.2.h),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor.withAlpha(15),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: AppColors.whiteColor.withAlpha(31),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(89),
                                blurRadius: 24,
                                offset: const Offset(0, 18),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr.where_real_estate_meets_elegance,
                                //"Where Real Estate Meets Elegance",
                                style: appTextStyle(
                                  context,
                                  color: AppColors.whiteColor,
                                  fontSize: 15.5.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 1.2.h),

                              Text(
                                "  ${tr.discover_manage_and_elevate_premium_properties} \n${tr.with_a_seamless_digital_experience}",

                                // "Discover, manage, and elevate premium properties "
                                // "with a seamless digital experience.",
                                style: appTextStyle(
                                  context,
                                  color: AppColors.grayBrandColor,
                                  fontSize: 10.8.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),

                              SizedBox(height: 2.h),

                              Row(
                                children: [
                                  Container(
                                    height: 0.15.h,
                                    width: 8.w,
                                    color: AppColors.goldBrandColor,
                                  ),
                                  SizedBox(width: 2.5.w),
                                  Text(
                                    "${tr.showcase} • ${tr.booking} • ${tr.growth}",
                                    style: appTextStyle(
                                      context,
                                      color: AppColors.whiteColor.withAlpha(
                                        179,
                                      ),
                                      fontSize: 9.8.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2.2.h),
                              AppButton(
                                backgroundColor: AppColors.goldBrandColor,
                                onPressed: () {
                                  AppNavigator.of(
                                    context,
                                  ).push(const LoginScreen());
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
                              SizedBox(height: 1.4.h),
                              AppButton(
                                backgroundColor: Colors.transparent,
                                borderColor: AppColors.goldBrandColor,
                                onPressed: () {
                                  AppNavigator.of(context).push(SignUpScreen());
                                },
                                child: Text(
                                  tr.signup,
                                  style: appTextStyle(
                                    context,
                                    fontSize: 12.2.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.goldBrandColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.5.h),
                              GestureDetector(
                                onTap: () {
                                  AppNavigator.of(
                                    context,
                                  ).push(const BottomNavBarScreen());
                                },
                                child: Center(
                                  child: Text(
                                    tr.continue_as_guest,
                                    style: appTextStyle(
                                      context,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.whiteColor.withAlpha(
                                        179,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Architectural diagonal clipper
class _ArchitectClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.78);
    path.quadraticBezierTo(
      size.width * 0.22,
      size.height * 0.93,
      size.width * 0.55,
      size.height * 0.86,
    );
    path.quadraticBezierTo(
      size.width * 0.82,
      size.height * 0.80,
      size.width,
      size.height * 0.88,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
