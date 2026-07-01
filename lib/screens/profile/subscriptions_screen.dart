import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/controller/local_provider.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/features/packages/data/models/my_subscription_item.dart';
import 'package:dar_plus_app/features/packages/data/models/package_item.dart';
import 'package:dar_plus_app/features/packages/data/models/payment_info_response.dart';
import 'package:dar_plus_app/features/packages/presentation/providers/packages_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/profile/my_subscriptions_screen.dart';
import 'package:dar_plus_app/screens/profile/widgets/content_widgets.dart';
import 'package:dar_plus_app/screens/profile/widgets/payment_info_card.dart';
import 'package:dar_plus_app/utils/widgets/auth_required_sheet.dart';
import 'package:dar_plus_app/utils/widgets/payment_submission_sheet.dart';
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
    final paymentInfoAsync =
        isLoggedIn ? ref.watch(paymentInfoControllerProvider) : null;
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
          paymentInfoAsync: paymentInfoAsync,
          pendingSubscriptions: mySubsAsync?.value
                  ?.where((sub) => sub.needsPayment)
                  .toList() ??
              [],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.goldBrandColor),
        ),
        error: (_, __) => Center(
          child: ContentErrorRetry(
            onRetry: () {
              ref.invalidate(packagesControllerProvider);
              if (isLoggedIn) {
                ref.invalidate(paymentInfoControllerProvider);
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
    required AsyncValue<PaymentInfoResponse?>? paymentInfoAsync,
    required List<MySubscriptionItem> pendingSubscriptions,
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
    final awaitingIds = ref.watch(awaitingReviewSubscriptionsProvider);
    final pendingForSelected = pendingSubscriptions
        .where((sub) => sub.package.id == selectedPlan.id)
        .toList();
    final selectedPending = pendingForSelected.isNotEmpty
        ? pendingForSelected.first
        : null;
    final selectedAwaitingReview = selectedPending != null &&
        awaitingIds.contains(selectedPending.id);

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
            if (pendingSubscriptions.isNotEmpty) ...[
              SizedBox(height: 2.h),
              ...pendingSubscriptions.map(
                (sub) => Padding(
                  padding: EdgeInsets.only(bottom: 1.2.h),
                  child: awaitingIds.contains(sub.id)
                      ? _AwaitingReviewBanner(
                          subscription: sub,
                          lang: lang,
                        )
                      : _PendingPaymentBanner(
                          subscription: sub,
                          lang: lang,
                          onUpload: () => _openPaymentSheet(sub),
                        ),
                ),
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
            if (paymentInfoAsync != null) ...[
              Text(
                tr.payment_step_transfer,
                style: appTextStyle(
                  context,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withAlpha(220),
                ),
              ),
              SizedBox(height: 1.2.h),
              paymentInfoAsync.when(
                data: (info) => info == null
                    ? const SizedBox.shrink()
                    : PaymentInfoCard(info: info),
                loading: () => const PaymentInfoLoadingCard(),
                error: (_, __) => PaymentInfoErrorCard(onRetry: _refreshAll),
              ),
              SizedBox(height: 2.5.h),
            ],
            if (selectedPending != null && selectedAwaitingReview)
              _AwaitingReviewCard(lang: lang, subscription: selectedPending)
            else if (selectedPending != null)
              AppButton(
                backgroundColor: AppColors.goldBrandColor,
                onPressed: _isProcessing
                    ? () {}
                    : () => _openPaymentSheet(selectedPending),
                child: _buttonChild(tr.submit_payment_proof),
              )
            else
              AppButton(
                backgroundColor: AppColors.goldBrandColor,
                onPressed: _isProcessing
                    ? () {}
                    : () => _subscribeAndPay(selectedPlan),
                child: _buttonChild(tr.subscribe_and_pay),
              ),
            SizedBox(height: 1.2.h),
            AppButton(
              backgroundColor: Colors.transparent,
              borderColor: AppColors.goldBrandColor.withAlpha(120),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MySubscriptionsScreen(),
                  ),
                );
              },
              child: Text(
                tr.view_active_subscriptions,
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
          _StepChip(number: 1, label: tr.payment_step_choose_plan),
          SizedBox(height: 0.6.h),
          _StepChip(number: 2, label: tr.payment_step_transfer),
          SizedBox(height: 0.6.h),
          _StepChip(number: 3, label: tr.payment_step_upload),
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
      await Future.wait([
        ref.read(paymentInfoControllerProvider.notifier).refresh(),
        ref.read(mySubscriptionsControllerProvider.notifier).refresh(),
      ]);
    }
  }

  Future<void> _subscribeAndPay(PackageItem plan) async {
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

      final pending = _findSubscriptionById(response.subscriptionId) ??
          _findPendingSubscription(plan.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.black.withAlpha(220),
          behavior: SnackBarBehavior.floating,
        ),
      );

      _goToMySubscriptions(openPaymentForSubscriptionId: pending?.id);
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');

      await ref.read(mySubscriptionsControllerProvider.notifier).refresh();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );

      final pending = _findPendingSubscription(plan.id) ??
          _findAnyPendingSubscription();
      if (pending != null) {
        _goToMySubscriptions(openPaymentForSubscriptionId: pending.id);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _goToMySubscriptions({int? openPaymentForSubscriptionId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MySubscriptionsScreen(
          openPaymentForSubscriptionId: openPaymentForSubscriptionId,
        ),
      ),
    );
  }

  MySubscriptionItem? _findSubscriptionById(int? subscriptionId) {
    if (subscriptionId == null) return null;
    final subscriptions =
        ref.read(mySubscriptionsControllerProvider).value ?? [];
    for (final item in subscriptions) {
      if (item.id == subscriptionId) return item;
    }
    return null;
  }

  MySubscriptionItem? _findPendingSubscription(int packageId) {
    final subscriptions =
        ref.read(mySubscriptionsControllerProvider).value ?? [];
    for (final item in subscriptions) {
      if (item.needsPayment && item.package.id == packageId) {
        return item;
      }
    }
    return null;
  }

  MySubscriptionItem? _findAnyPendingSubscription() {
    final subscriptions =
        ref.read(mySubscriptionsControllerProvider).value ?? [];
    for (final item in subscriptions) {
      if (item.needsPayment) return item;
    }
    return null;
  }

  Future<void> _openPaymentSheet(MySubscriptionItem subscription) async {
    final success = await showPaymentSubmissionSheet(
      context: context,
      subscription: subscription,
    );
    if (mounted && success == true) {
      await ref.read(mySubscriptionsControllerProvider.notifier).refresh();
    }
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

class _AwaitingReviewBanner extends StatelessWidget {
  final MySubscriptionItem subscription;
  final String lang;

  const _AwaitingReviewBanner({
    required this.subscription,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1565C0).withAlpha(80)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.hourglass_top_rounded,
            color: Color(0xFF1565C0),
            size: 28,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.awaiting_admin_approval,
                  style: appTextStyle(
                    context,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withAlpha(210),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  subscription.package.name.forLang(lang),
                  style: appTextStyle(
                    context,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withAlpha(120),
                  ),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  tr.awaiting_admin_approval_message,
                  style: appTextStyle(
                    context,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withAlpha(100),
                    height: 1.3,
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

class _AwaitingReviewCard extends StatelessWidget {
  final MySubscriptionItem subscription;
  final String lang;

  const _AwaitingReviewCard({
    required this.subscription,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1565C0).withAlpha(80)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined, color: Color(0xFF1565C0)),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              tr.awaiting_admin_approval_message,
              style: appTextStyle(
                context,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(150),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingPaymentBanner extends StatelessWidget {
  final MySubscriptionItem subscription;
  final String lang;
  final VoidCallback onUpload;

  const _PendingPaymentBanner({
    required this.subscription,
    required this.lang,
    required this.onUpload,
  });

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
        children: [
          Icon(
            Icons.pending_actions_rounded,
            color: const Color(0xFFE67E22),
            size: 28,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.pending_payment_banner,
                  style: appTextStyle(
                    context,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withAlpha(210),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  subscription.package.name.forLang(lang),
                  style: appTextStyle(
                    context,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withAlpha(120),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onUpload,
            child: Text(
              tr.submit_payment_proof,
              style: appTextStyle(
                context,
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.goldBrandColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
