import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
          "Terms and Conditions",
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
                "Effective Date: January 1, 2026",
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
              "Welcome to Dar Plus. By accessing or using our application, you agree to be bound by these Terms and Conditions. Please read them carefully before using our services.",
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
              title: "Acceptance of Terms",
              content:
                  """By creating an account or using Dar Plus, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions and our Privacy Policy. If you do not agree to these terms, please do not use our services.

These terms apply to all users, including guests, registered users, and property owners.""",
            ),

            _buildSection(
              context,
              number: "2",
              title: "Eligibility",
              content: """To use Dar Plus, you must:

• Be at least 18 years of age
• Have the legal capacity to enter into contracts
• Provide accurate and complete registration information
• Maintain the security of your account credentials

We reserve the right to refuse service to anyone for any reason at any time.""",
            ),

            _buildSection(
              context,
              number: "3",
              title: "User Accounts",
              content: """When you create an account:

• You are responsible for maintaining account confidentiality
• You must notify us of any unauthorized access
• You are responsible for all activities under your account
• You may not share your account with others
• We may suspend or terminate accounts that violate our terms

One person may only maintain one account.""",
            ),

            _buildSection(
              context,
              number: "4",
              title: "Booking and Reservations",
              content: """When making a booking:

• All bookings are subject to availability and confirmation
• Prices are displayed in the local currency and may change
• You agree to pay all charges at the prices in effect
• Booking confirmations will be sent via email
• You must review all booking details before confirming

Bookings are binding contracts between you and the property owner.""",
            ),

            _buildSection(
              context,
              number: "5",
              title: "Cancellation Policy",
              content: """Cancellation terms vary by property:

• Free cancellation may be available up to a specified time
• Late cancellations may incur fees
• No-shows may be charged the full booking amount
• Refunds are processed within 5-10 business days
• Force majeure events are handled case by case

Always review the specific cancellation policy before booking.""",
            ),

            _buildSection(
              context,
              number: "6",
              title: "Payments",
              content: """Payment terms:

• We accept major credit cards and digital payment methods
• Payment is required to confirm your booking
• All transactions are processed securely
• Prices include applicable taxes unless stated otherwise
• Currency conversion fees may apply for international payments

We do not store complete credit card information on our servers.""",
            ),

            _buildSection(
              context,
              number: "7",
              title: "User Conduct",
              content: """You agree not to:

• Use the service for any illegal purpose
• Violate any applicable laws or regulations
• Infringe on intellectual property rights
• Post false, misleading, or defamatory content
• Harass, abuse, or harm other users
• Attempt to gain unauthorized access
• Use automated systems to access the service
• Interfere with the proper functioning of the service""",
            ),

            _buildSection(
              context,
              number: "8",
              title: "Intellectual Property",
              content:
                  """All content on Dar Plus, including but not limited to text, graphics, logos, images, and software, is the property of Dar Plus or its content suppliers and is protected by intellectual property laws.

You may not reproduce, distribute, modify, or create derivative works without our express written permission.""",
            ),

            _buildSection(
              context,
              number: "9",
              title: "Limitation of Liability",
              content:
                  """Dar Plus provides the platform "as is" without warranties of any kind. We are not liable for:

• Actions or conduct of property owners or guests
• Property conditions or amenities
• Service interruptions or errors
• Loss of data or unauthorized access
• Any indirect, incidental, or consequential damages

Our maximum liability shall not exceed the amount paid for the booking.""",
            ),

            _buildSection(
              context,
              number: "10",
              title: "Dispute Resolution",
              content: """In case of disputes:

• First attempt to resolve through our customer service
• Mediation may be offered for unresolved issues
• Arbitration may be required for certain disputes
• Legal proceedings shall be in courts of Jordan
• These terms are governed by Jordanian law

We encourage open communication to resolve issues amicably.""",
            ),

            _buildSection(
              context,
              number: "11",
              title: "Modifications",
              content:
                  """We reserve the right to modify these Terms and Conditions at any time. Changes will be effective upon posting to the application. Your continued use of the service after changes constitutes acceptance of the modified terms.

We will notify users of significant changes via email or in-app notification.""",
            ),

            _buildSection(
              context,
              number: "12",
              title: "Contact Information",
              content: """For questions about these Terms and Conditions:

Email: legal@darplus.com
Phone: +962 7 9999 9999
Address: Amman, Jordan

Our customer service team is available 24/7 to assist you.""",
            ),

            SizedBox(height: 2.h),

            // Agreement Statement
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppColors.goldBrandColor.withAlpha(10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.goldBrandColor.withAlpha(40)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.goldBrandColor,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      "By using Dar Plus, you acknowledge that you have read and agree to these Terms and Conditions.",
                      style: appTextStyle(
                        context,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(160),
                        height: 1.5,
                      ),
                    ),
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
