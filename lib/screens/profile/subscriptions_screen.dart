import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/controller/local_provider.dart';
import 'package:dar_plus_app/features/packages/data/models/package_item.dart';
import 'package:dar_plus_app/features/packages/presentation/providers/packages_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/profile/my_subscriptions_screen.dart';
import 'package:dar_plus_app/screens/profile/widgets/content_widgets.dart';
import 'package:dar_plus_app/utils/widgets/auth_required_sheet.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class SubscriptionsScreen extends ConsumerStatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  ConsumerState<SubscriptionsScreen> createState() =>
      _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends ConsumerState<SubscriptionsScreen> {
  int _selectedPlanIndex = 0;

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(packagesControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: kAppBarBackLeadingWidth,
        leading: const AppBarBackButton(),
        title: Text(
          tr.subscriptions,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: true,
      ),
      body: packagesAsync.when(
        data: (packages) => _buildContent(packages),
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.goldBrandColor),
          ),
        ),
        error: (_, __) => Center(
          child: ContentErrorRetry(
            onRetry: () => ref.invalidate(packagesControllerProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<PackageItem> packages) {
    if (packages.isEmpty) {
      return Center(
        child: Text(
          tr.no_results_found,
          style: appTextStyle(
            context,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withAlpha(120),
          ),
        ),
      );
    }

    if (_selectedPlanIndex >= packages.length) {
      _selectedPlanIndex = 0;
    }

    final lang = ref.read(apiLanguageCodeProvider);
    final isSubscribing = ref.watch(subscribeControllerProvider).isLoading;
    final selectedPlan = packages[_selectedPlanIndex];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          _buildHeader(),
          SizedBox(height: 3.h),
          Text(
            tr.choose_your_plan,
            style: appTextStyle(
              context,
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(220),
            ),
          ),
          SizedBox(height: 2.h),
          ...List.generate(packages.length, (index) {
            final plan = packages[index];
            return _buildPlanCard(
              plan: plan,
              lang: lang,
              index: index,
            );
          }),
          SizedBox(height: 3.h),
          AppButton(
            backgroundColor: AppColors.goldBrandColor,
            onPressed: isSubscribing
                ? () {}
                : () => _subscribeToPlan(selectedPlan.id),
            child: isSubscribing
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.whiteColor,
                      ),
                    ),
                  )
                : Text(
                    tr.upgrade_plan,
                    style: appTextStyle(
                      context,
                      fontSize: 12.2.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.whiteColor,
                    ),
                  ),
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Future<void> _subscribeToPlan(int packageId) async {
    if (!await requireAuth(
      context,
      message: tr.login_required_subscriptions,
      icon: Icons.card_membership_rounded,
    )) {
      return;
    }

    try {
      final message = await ref
          .read(subscribeControllerProvider.notifier)
          .subscribe(packageId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.black.withAlpha(220),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MySubscriptionsScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildHeader() {
    return Container(
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
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              tr.choose_your_plan,
              style: appTextStyle(
                context,
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required PackageItem plan,
    required String lang,
    required int index,
  }) {
    final isSelected = _selectedPlanIndex == index;
    final name = plan.name.forLang(lang);
    final features = [
      '${tr.package_duration}: ${plan.durationDays} ${tr.package_days}',
      '${tr.package_sale_listings}: ${plan.saleAssetsLimit}',
      '${tr.package_rent_listings}: ${plan.rentAssetsLimit}',
    ];

    return GestureDetector(
      onTap: () => setState(() => _selectedPlanIndex = index),
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
                      Text(
                        name,
                        style: appTextStyle(
                          context,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black.withAlpha(220),
                        ),
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
                              text: ' $kAppCurrency',
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
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ...features.map(
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
                    Expanded(
                      child: Text(
                        feature,
                        style: appTextStyle(
                          context,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withAlpha(160),
                        ),
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
