import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
          "Contact Us",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),

            // Contact Methods
            Row(
              children: [
                _buildContactMethod(
                  context,
                  icon: Icons.phone_rounded,
                  title: "Phone",
                  subtitle: "+962 7 9999 9999",
                  onTap: () {
                    // TODO: Open phone
                  },
                ),
                SizedBox(width: 3.w),
                _buildContactMethod(
                  context,
                  icon: Icons.email_rounded,
                  title: "Email",
                  subtitle: "support@darplus.com",
                  onTap: () {
                    // TODO: Open email
                  },
                ),
              ],
            ),

            SizedBox(height: 2.h),

            Row(
              children: [
                _buildContactMethod(
                  context,
                  icon: Icons.location_on_rounded,
                  title: "Address",
                  subtitle: "Amman, Jordan",
                  onTap: () {
                    // TODO: Open map
                  },
                ),
                SizedBox(width: 3.w),
                _buildContactMethod(
                  context,
                  icon: Icons.access_time_rounded,
                  title: "Hours",
                  subtitle: "24/7 Support",
                  onTap: () {},
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // Social Media
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 3.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    "Connect With Us",
                    style: appTextStyle(
                      context,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withAlpha(180),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    "Follow us on social media",
                    style: appTextStyle(
                      context,
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withAlpha(100),
                    ),
                  ),
                  SizedBox(height: 2.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        FontAwesomeIcons.instagram,
                        const Color(0xFFE4405F),
                      ),
                      SizedBox(width: 3.w),
                      _buildSocialButton(
                        FontAwesomeIcons.xTwitter,
                        Colors.black87,
                      ),
                      SizedBox(width: 3.w),
                      _buildSocialButton(
                        FontAwesomeIcons.youtube,
                        const Color(0xFFFF0000),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        FontAwesomeIcons.linkedinIn,
                        const Color(0xFF0A66C2),
                      ),
                      SizedBox(width: 3.w),
                      _buildSocialButton(
                        FontAwesomeIcons.snapchat,
                        const Color(0xFFFFFC00),
                        bgColor: const Color(0xFF333333),
                      ),
                      SizedBox(width: 3.w),
                      _buildSocialButton(
                        FontAwesomeIcons.tiktok,
                        Colors.black87,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContactMethod(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
                child: Icon(icon, color: AppColors.goldBrandColor, size: 20),
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
              SizedBox(height: 0.3.h),
              Text(
                subtitle,
                style: appTextStyle(
                  context,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withAlpha(120),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color iconColor, {Color? bgColor}) {
    return GestureDetector(
      onTap: () {
        // TODO: Open social media
      },
      child: Container(
        padding: EdgeInsets.all(3.8.w),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: FaIcon(icon, color: iconColor, size: 22),
      ),
    );
  }
}
