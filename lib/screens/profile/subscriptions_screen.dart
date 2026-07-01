import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/controller/local_provider.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/features/packages/data/models/my_subscription_item.dart';
import 'package:dar_plus_app/features/packages/data/models/package_item.dart';
import 'package:dar_plus_app/features/packages/data/repositories/packages_repository_impl.dart';
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
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(packagesControllerProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final mySubsAsync =
        isLoggedIn ? ref.watch(mySubscriptionsControllerProvider) : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F4),
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: kAppBarBackLeadingWidth,
        leading: const AppBarBackButton(),
        title: Text(
          tr.browse_plans,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: true,
        actions: [
          if (isLoggedIn)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MySubscriptionsScreen(),
                  ),
                );
              },
              child: Text(
                tr.my_subscriptions,
                style: appTextStyle(
                  context,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.goldBrandColor,
                ),
              ),
            ),
        ],
      ),
      body: packagesAsync.when(
        data: (packages) => _buildContent(
          packages: packages,
          mySubscriptions: mySubsAsync?.value ?? [],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.goldBrandColor),
        ),
        error: (_, __) => Center(
          child: ContentErrorRetry(
            onRetry: () {
              ref.invalidate(packagesControllerProvider);
              if (isLoggedIn) {
                ref.invalidate(mySubscriptionsControllerProvider);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required List<PackageItem> packages,
    required List<MySubscriptionItem> mySubscriptions,
  }) {
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
    final selectedPlan = packages[_selectedPlanIndex];
    final incompleteSubscriptions =
        mySubscriptions.where((sub) => sub.isIncomplete).toList();
    final hasIncompleteSubscription = incompleteSubscriptions.isNotEmpty;
    final incompletePlanName = hasIncompleteSubscription
        ? incompleteSubscriptions.first.package.name.forLang(lang)
        : selectedPlan.name.forLang(lang);

    return RefreshIndicator(
      color: AppColors.goldBrandColor,
      onRefresh: _refreshAll,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.5.h),
            _buildStepsHeader(),
            if (hasIncompleteSubscription) ...[
              SizedBox(height: 2.h),
              _PendingSubscriptionNotice(
                planName: incompletePlanName,
              ),
            ],
            SizedBox(height: 2.h),
            Text(
              tr.choose_your_plan,
              style: appTextStyle(
                context,
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(220),
              ),
            ),
            SizedBox(height: 1.5.h),
            ...List.generate(packages.length, (index) {
              return _buildPlanCard(
                plan: packages[index],
                lang: lang,
                index: index,
              );
            }),
            SizedBox(height: 2.5.h),
            if (hasIncompleteSubscription)
              AppButton(
                backgroundColor: AppColors.goldBrandColor,
                onPressed: _goToMySubscriptions,
                child: Text(
                  tr.go_to_my_subscriptions,
                  style: appTextStyle(
                    context,
                    fontSize: 12.2.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                ),
              )
            else
              AppButton(
                backgroundColor: AppColors.goldBrandColor,
                onPressed: _isProcessing ? () {} : () => _subscribe(selectedPlan),
                child: _buttonChild(tr.subscribe_and_pay),
              ),
            SizedBox(height: 1.2.h),
            AppButton(
              backgroundColor: Colors.transparent,
              borderColor: AppColors.goldBrandColor.withAlpha(120),
              onPressed: _goToMySubscriptions,
              child: Text(
                tr.my_subscriptions,
                style: appTextStyle(
                  context,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.goldBrandColor,
                ),
              ),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buttonChild(String label) {
    if (_isProcessing) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation(AppColors.whiteColor),
        ),
      );
    }
    return Text(
      label,
      style: appTextStyle(
        context,
        fontSize: 12.2.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.whiteColor,
      ),
    );
  }

  Widget _buildStepsHeader() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              SizedBox(width: 3.5.w),
              Expanded(
                child: Text(
                  tr.subscribe_flow_title,
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
          SizedBox(height: 1.5.h),
          _StepChip(number: 1, label: tr.subscription_step_subscribe),
          SizedBox(height: 0.6.h),
          _StepChip(number: 2, label: tr.subscription_step_view),
          SizedBox(height: 0.6.h),
          _StepChip(number: 3, label: tr.subscription_step_upload),
          SizedBox(height: 0.6.h),
          _StepChip(number: 4, label: tr.subscription_step_see_status),
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
        margin: EdgeInsets.only(bottom: 1.5.h),
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
            SizedBox(height: 1.5.h),
            ...features.map(
              (feature) => Padding(
                padding: EdgeInsets.only(bottom: 0.6.h),
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

  Future<void> _refreshAll() async {
    ref.invalidate(packagesControllerProvider);
    if (ref.read(isLoggedInProvider)) {
      await ref.read(mySubscriptionsControllerProvider.notifier).refresh();
    }
  }

  Future<void> _subscribe(PackageItem plan) async {
    if (!await requireAuth(
      context,
      message: tr.login_required_subscriptions,
      icon: Icons.card_membership_rounded,
    )) {
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final response = await ref
          .read(subscribeControllerProvider.notifier)
          .subscribe(plan.id);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.black.withAlpha(220),
          behavior: SnackBarBehavior.floating,
        ),
      );

      _goToMySubscriptions();
    } catch (e) {
      if (!mounted) return;
      final isExistingSubscription = e is SubscribeException;
      final msg = isExistingSubscription
          ? e.message
          : e.toString().replaceFirst('Exception: ', '');

      await ref.read(mySubscriptionsControllerProvider.notifier).refresh();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: isExistingSubscription
              ? Colors.black.withAlpha(220)
              : Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (isExistingSubscription || _hasIncompleteSubscription()) {
        _goToMySubscriptions();
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _goToMySubscriptions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MySubscriptionsScreen(),
      ),
    );
  }

  bool _hasIncompleteSubscription() {
    final subscriptions =
        ref.read(mySubscriptionsControllerProvider).value ?? [];
    return subscriptions.any((item) => item.isIncomplete);
  }
}

class _PendingSubscriptionNotice extends StatelessWidget {
  final String planName;

  const _PendingSubscriptionNotice({required this.planName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE67E22).withAlpha(120)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFE67E22),
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planName,
                  style: appTextStyle(
                    context,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withAlpha(210),
                  ),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  tr.complete_in_my_subscriptions_hint,
                  style: appTextStyle(
                    context,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withAlpha(120),
                    height: 1.35,
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

class _StepChip extends StatelessWidget {
  final int number;
  final String label;

  const _StepChip({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: appTextStyle(
              context,
              fontSize: 10.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 2.5.w),
        Expanded(
          child: Text(
            label,
            style: appTextStyle(
              context,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withAlpha(230),
            ),
          ),
        ),
      ],
    );
  }
}
