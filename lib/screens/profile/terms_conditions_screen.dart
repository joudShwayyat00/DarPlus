import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';

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
          tr.terms_and_conditions,
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
                tr.terms_effective_date,
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
              tr.terms_intro,
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
              title: tr.terms_section_1_title,
              content: tr.terms_section_1_content,
            ),

            _buildSection(
              context,
              number: "2",
              title: tr.terms_section_2_title,
              content: tr.terms_section_2_content,
            ),

            _buildSection(
              context,
              number: "3",
              title: tr.terms_section_3_title,
              content: tr.terms_section_3_content,
            ),

            _buildSection(
              context,
              number: "4",
              title: tr.terms_section_4_title,
              content: tr.terms_section_4_content,
            ),

            _buildSection(
              context,
              number: "5",
              title: tr.terms_section_5_title,
              content: tr.terms_section_5_content,
            ),

            _buildSection(
              context,
              number: "6",
              title: tr.terms_section_6_title,
              content: tr.terms_section_6_content,
            ),

            _buildSection(
              context,
              number: "7",
              title: tr.terms_section_7_title,
              content: tr.terms_section_7_content,
            ),

            _buildSection(
              context,
              number: "8",
              title: tr.terms_section_8_title,
              content: tr.terms_section_8_content,
            ),

            _buildSection(
              context,
              number: "9",
              title: tr.terms_section_9_title,
              content: tr.terms_section_9_content,
            ),

            _buildSection(
              context,
              number: "10",
              title: tr.terms_section_10_title,
              content: tr.terms_section_10_content,
            ),

            _buildSection(
              context,
              number: "11",
              title: tr.terms_section_11_title,
              content: tr.terms_section_11_content,
            ),

            _buildSection(
              context,
              number: "12",
              title: tr.terms_section_12_title,
              content: tr.terms_section_12_content,
            ),

            SizedBox(height: 2.h),

            // Agreement Statement
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppColors.goldBrandColor.withAlpha(10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.goldBrandColor.withAlpha(40),
                ),
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
                      tr.terms_agreement_statement,
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
