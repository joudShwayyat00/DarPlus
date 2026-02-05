import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/configuration/app_images.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          "About",
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
            SizedBox(height: 3.h),

            // Logo and App Name
            Image.asset(
              appLogo,
              height: 15.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 2.h),
            Text(
              "Dar Plus",
              style: appTextStyle(
                context,
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(220),
              ),
            ),
            Text(
              "Premium Real Estate",
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.goldBrandColor,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              "Version 1.0.0",
              style: appTextStyle(
                context,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(100),
              ),
            ),

            SizedBox(height: 4.h),

            // About Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black.withAlpha(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Our Story",
                    style: appTextStyle(
                      context,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withAlpha(220),
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    "Dar Plus was founded with a vision to revolutionize the real estate experience. We believe that finding your perfect property should be an exciting journey, not a stressful task.\n\nOur platform connects you with premium properties across the region, offering a seamless booking experience with transparent pricing and exceptional service.",
                    style: appTextStyle(
                      context,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withAlpha(160),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Mission & Vision
            Row(
              children: [
                _buildInfoCard(
                  context,
                  icon: Icons.flag_rounded,
                  title: "Our Mission",
                  description:
                      "To provide exceptional real estate services with integrity and innovation.",
                ),
                SizedBox(width: 3.w),
                _buildInfoCard(
                  context,
                  icon: Icons.visibility_rounded,
                  title: "Our Vision",
                  description:
                      "To be the leading real estate platform in the region.",
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Stats
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.goldBrandColor.withAlpha(200),
                    AppColors.goldBrandColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(context, "500+", "Properties"),
                  _buildDivider(),
                  _buildStat(context, "10K+", "Users"),
                  _buildDivider(),
                  _buildStat(context, "50+", "Cities"),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Team/Values
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black.withAlpha(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Our Values",
                    style: appTextStyle(
                      context,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withAlpha(220),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildValueItem(
                    context,
                    Icons.verified_rounded,
                    "Trust & Transparency",
                    "We maintain honesty in all our dealings",
                  ),
                  _buildValueItem(
                    context,
                    Icons.star_rounded,
                    "Excellence",
                    "We strive to exceed expectations",
                  ),
                  _buildValueItem(
                    context,
                    Icons.people_rounded,
                    "Customer First",
                    "Your satisfaction is our priority",
                  ),
                  _buildValueItem(
                    context,
                    Icons.lightbulb_rounded,
                    "Innovation",
                    "We embrace technology for better service",
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Copyright
            Text(
              "© 2026 Dar Plus. All rights reserved.",
              style: appTextStyle(
                context,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(100),
              ),
            ),

            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withAlpha(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: AppColors.goldBrandColor.withAlpha(15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.goldBrandColor,
                size: 20,
              ),
            ),
            SizedBox(height: 1.5.h),
            Text(
              title,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black.withAlpha(200),
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              description,
              style: appTextStyle(
                context,
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(120),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: appTextStyle(
            context,
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 0.3.h),
        Text(
          label,
          style: appTextStyle(
            context,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white.withAlpha(200),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withAlpha(60),
    );
  }

  Widget _buildValueItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppColors.goldBrandColor.withAlpha(15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.goldBrandColor,
              size: 18,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTextStyle(
                    context,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withAlpha(200),
                  ),
                ),
                Text(
                  description,
                  style: appTextStyle(
                    context,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withAlpha(120),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
