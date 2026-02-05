import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          "Privacy Policy",
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

            // Last Updated
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppColors.goldBrandColor.withAlpha(15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Last Updated: January 1, 2026",
                style: appTextStyle(
                  context,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.goldBrandColor,
                ),
              ),
            ),

            SizedBox(height: 2.h),

            Text(
              "Your privacy is important to us. This Privacy Policy explains how Dar Plus collects, uses, discloses, and safeguards your information.",
              style: appTextStyle(
                context,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(160),
                height: 1.6,
              ),
            ),

            SizedBox(height: 3.h),

            _buildSection(
              context,
              number: "1",
              title: "Information We Collect",
              content: """We collect information you provide directly to us, such as:

• Personal Information: Name, email address, phone number, and profile picture.
• Account Information: Username, password, and account preferences.
• Payment Information: Credit card details and billing address (processed securely through our payment providers).
• Property Preferences: Search history, saved properties, and booking preferences.
• Communications: Messages, feedback, and support requests.""",
            ),

            _buildSection(
              context,
              number: "2",
              title: "How We Use Your Information",
              content: """We use the information we collect to:

• Provide, maintain, and improve our services
• Process transactions and send related information
• Send promotional communications (with your consent)
• Respond to your comments, questions, and requests
• Monitor and analyze trends, usage, and activities
• Detect, investigate, and prevent fraudulent transactions
• Personalize and improve your experience""",
            ),

            _buildSection(
              context,
              number: "3",
              title: "Information Sharing",
              content: """We may share your information with:

• Property Owners: To facilitate bookings and communication
• Service Providers: Who assist in our operations
• Legal Authorities: When required by law or to protect rights
• Business Partners: With your consent for joint offerings

We do not sell your personal information to third parties.""",
            ),

            _buildSection(
              context,
              number: "4",
              title: "Data Security",
              content: """We implement appropriate security measures to protect your information:

• SSL encryption for data transmission
• Secure servers and databases
• Regular security audits
• Limited access to personal information
• Two-factor authentication options

However, no method of transmission over the Internet is 100% secure.""",
            ),

            _buildSection(
              context,
              number: "5",
              title: "Your Rights",
              content: """You have the right to:

• Access your personal information
• Correct inaccurate data
• Delete your account and data
• Opt-out of marketing communications
• Export your data
• Restrict processing of your data

To exercise these rights, contact us at privacy@darplus.com""",
            ),

            _buildSection(
              context,
              number: "6",
              title: "Cookies and Tracking",
              content: """We use cookies and similar technologies to:

• Remember your preferences
• Analyze site traffic
• Personalize content
• Improve our services

You can control cookies through your browser settings.""",
            ),

            _buildSection(
              context,
              number: "7",
              title: "Children's Privacy",
              content:
                  """Our services are not intended for children under 18. We do not knowingly collect personal information from children. If you believe we have collected information from a child, please contact us immediately.""",
            ),

            _buildSection(
              context,
              number: "8",
              title: "Changes to This Policy",
              content:
                  """We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last Updated" date. Your continued use of our services after changes indicates acceptance of the updated policy.""",
            ),

            _buildSection(
              context,
              number: "9",
              title: "Contact Us",
              content: """If you have questions about this Privacy Policy, please contact us:

Email: privacy@darplus.com
Phone: +962 7 9999 9999
Address: Amman, Jordan""",
            ),

            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String number,
    required String title,
    required String content,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
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
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: appTextStyle(
                      context,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: appTextStyle(
                    context,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withAlpha(220),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text(
            content,
            style: appTextStyle(
              context,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black.withAlpha(150),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
