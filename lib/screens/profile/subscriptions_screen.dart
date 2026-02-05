import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  int _selectedPlanIndex = 1; // Premium selected by default

  final List<_SubscriptionPlan> _plans = [
    _SubscriptionPlan(
      name: "Basic",
      price: "Free",
      period: "",
      features: ["Browse properties", "Save favorites", "Basic search filters"],
      isPopular: false,
    ),
    _SubscriptionPlan(
      name: "Premium",
      price: "\$9.99",
      period: "/month",
      features: [
        "All Basic features",
        "Priority booking",
        "Exclusive deals",
        "24/7 support",
        "No ads",
      ],
      isPopular: true,
    ),
    _SubscriptionPlan(
      name: "Elite",
      price: "\$24.99",
      period: "/month",
      features: [
        "All Premium features",
        "Personal concierge",
        "VIP property access",
        "Cashback rewards",
        "Free cancellation",
        "Luxury perks",
      ],
      isPopular: false,
    ),
  ];

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
          "Subscriptions",
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

            // Current Plan Badge
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
                boxShadow: [
                  BoxShadow(
                    color: AppColors.goldBrandColor.withAlpha(50),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Plan: Premium",
                          style: appTextStyle(
                            context,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 0.3.h),
                        Text(
                          "Renews on March 15, 2026",
                          style: appTextStyle(
                            context,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            Text(
              "Choose Your Plan",
              style: appTextStyle(
                context,
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(220),
              ),
            ),

            SizedBox(height: 2.h),

            // Plans
            ...List.generate(_plans.length, (index) {
              return _buildPlanCard(_plans[index], index);
            }),

            SizedBox(height: 3.h),

            AppButton(
              backgroundColor: AppColors.goldBrandColor,
              onPressed: () {
                // TODO: Process subscription
              },
              child: Text(
                "Upgrade Plan",
                style: appTextStyle(
                  context,
                  fontSize: 12.2.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.whiteColor,
                ),
              ),
            ),

            SizedBox(height: 2.h),

            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Cancel subscription
                },
                child: Text(
                  "Cancel Subscription",
                  style: appTextStyle(
                    context,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.withAlpha(180),
                  ),
                ),
              ),
            ),

            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(_SubscriptionPlan plan, int index) {
    final isSelected = _selectedPlanIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.goldBrandColor
                : Colors.black.withAlpha(15),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.goldBrandColor.withAlpha(20)
                  : Colors.black.withAlpha(8),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            plan.name,
                            style: appTextStyle(
                              context,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.black.withAlpha(220),
                            ),
                          ),
                          if (plan.isPopular) ...[
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.3.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.goldBrandColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Popular",
                                style: appTextStyle(
                                  context,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: plan.price,
                              style: appTextStyle(
                                context,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColors.goldBrandColor,
                              ),
                            ),
                            TextSpan(
                              text: plan.period,
                              style: appTextStyle(
                                context,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withAlpha(120),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.goldBrandColor
                          : Colors.black.withAlpha(60),
                      width: 2,
                    ),
                    color: isSelected
                        ? AppColors.goldBrandColor
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ...plan.features.map(
              (feature) => Padding(
                padding: EdgeInsets.only(bottom: 0.8.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: AppColors.goldBrandColor,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      feature,
                      style: appTextStyle(
                        context,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(160),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionPlan {
  final String name;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;

  const _SubscriptionPlan({
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    required this.isPopular,
  });
}
