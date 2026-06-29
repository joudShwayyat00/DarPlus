import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OwnerStatisticsScreen extends StatelessWidget {
  const OwnerStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F4),
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: kAppBarBackLeadingWidth,
        leading: const AppBarBackButton(),
        title: Text(
          tr.my_statistics,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.goldBrandColor.withAlpha(30),
                      AppColors.goldBrandColor.withAlpha(10),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.insights_rounded,
                  size: 52,
                  color: AppColors.goldBrandColor.withAlpha(220),
                ),
              ),
              SizedBox(height: 2.5.h),
              Text(
                tr.statistics_coming_soon,
                textAlign: TextAlign.center,
                style: appTextStyle(
                  context,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withAlpha(220),
                ),
              ),
              SizedBox(height: 1.2.h),
              Text(
                tr.statistics_coming_soon_message,
                textAlign: TextAlign.center,
                style: appTextStyle(
                  context,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withAlpha(110),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
