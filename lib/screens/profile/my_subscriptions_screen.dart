import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/controller/local_provider.dart';
import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/features/packages/data/models/my_subscription_item.dart';
import 'package:dar_plus_app/features/packages/data/models/subscription_asset_usage.dart';
import 'package:dar_plus_app/features/packages/presentation/providers/packages_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/profile/subscriptions_screen.dart';
import 'package:dar_plus_app/screens/profile/widgets/content_widgets.dart';
import 'package:dar_plus_app/screens/profile/widgets/payment_info_card.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/login_required_view.dart';
import 'package:dar_plus_app/utils/widgets/payment_submission_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class MySubscriptionsScreen extends ConsumerStatefulWidget {
  const MySubscriptionsScreen({super.key});

  @override
  ConsumerState<MySubscriptionsScreen> createState() =>
      _MySubscriptionsScreenState();
}

class _MySubscriptionsScreenState extends ConsumerState<MySubscriptionsScreen> {
  Future<void> _handlePaymentProof(MySubscriptionItem subscription) async {
    await openPaymentProofSubmissionFlow(
      context: context,
      ref: ref,
      subscription: subscription,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F4),
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: kAppBarBackLeadingWidth,
        leading: const AppBarBackButton(),
        title: Text(
          tr.my_subscriptions,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: true,
      ),
      body: !isLoggedIn
          ? LoginRequiredView(
              icon: Icons.card_membership_rounded,
              title: tr.sign_in_to_continue,
              message: tr.login_required_my_subscriptions,
            )
          : ref.watch(mySubscriptionsControllerProvider).when(
                data: (subscriptions) => _SubscriptionsBody(
                  subscriptions: subscriptions,
                  onUploadProof: _handlePaymentProof,
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.goldBrandColor,
                  ),
                ),
                error: (_, __) => Center(
                  child: ContentErrorRetry(
                    onRetry: () => ref
                        .read(mySubscriptionsControllerProvider.notifier)
                        .refresh(),
                  ),
                ),
              ),
    );
  }
}

class _SubscriptionsBody extends ConsumerWidget {
  final List<MySubscriptionItem> subscriptions;
  final Future<void> Function(MySubscriptionItem subscription) onUploadProof;

  const _SubscriptionsBody({
    required this.subscriptions,
    required this.onUploadProof,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final awaitingIds = ref.watch(awaitingReviewSubscriptionsProvider);
    final needsPaymentUpload = subscriptions.any(
      (sub) => sub.needsPayment && !awaitingIds.contains(sub.id),
    );
    final paymentInfoAsync = needsPaymentUpload
        ? ref.watch(paymentInfoControllerProvider)
        : null;

    return RefreshIndicator(
      color: AppColors.goldBrandColor,
      onRefresh: () async {
        await ref.read(mySubscriptionsControllerProvider.notifier).refresh();
        if (needsPaymentUpload) {
          await ref.read(paymentInfoControllerProvider.notifier).refresh();
        }
      },
      child: subscriptions.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 4.h),
              children: [
                _EmptySubscriptions(
                  onBrowse: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SubscriptionsScreen(),
                    ),
                  ),
                ),
              ],
            )
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
              children: [
                if (paymentInfoAsync != null) ...[
                  Text(
                    tr.bank_transfer_details,
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
                    error: (_, __) => PaymentInfoErrorCard(
                      onRetry: () => ref
                          .read(paymentInfoControllerProvider.notifier)
                          .refresh(),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
                ...List.generate(subscriptions.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < subscriptions.length - 1 ? 2.h : 0,
                    ),
                    child: _SubscriptionCard(
                      subscription: subscriptions[index],
                      onUploadProof: () => onUploadProof(subscriptions[index]),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}

class _EmptySubscriptions extends StatelessWidget {
  final VoidCallback onBrowse;

  const _EmptySubscriptions({required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (Icons.workspace_premium_rounded, tr.subscription_step_subscribe),
      (Icons.receipt_long_rounded, tr.subscription_step_view),
      (Icons.upload_file_rounded, tr.subscription_step_upload),
      (Icons.verified_rounded, tr.subscription_step_see_status),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 4.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.goldBrandColor.withAlpha(210),
                AppColors.goldBrandColor,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.goldBrandColor.withAlpha(45),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(4.5.w),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.card_membership_rounded,
                  size: 52,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                tr.my_subscription_empty_title,
                textAlign: TextAlign.center,
                style: appTextStyle(
                  context,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                tr.my_subscription_empty_message,
                textAlign: TextAlign.center,
                style: appTextStyle(
                  context,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withAlpha(220),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.5.h),
        Container(
          padding: EdgeInsets.all(4.5.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr.my_subscription_how_it_works,
                style: appTextStyle(
                  context,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withAlpha(210),
                ),
              ),
              SizedBox(height: 1.5.h),
              ...List.generate(steps.length, (index) {
                final (icon, label) = steps[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < steps.length - 1 ? 1.2.h : 0,
                  ),
                  child: _EmptyStepRow(
                    number: index + 1,
                    icon: icon,
                    label: label,
                    isLast: index == steps.length - 1,
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 2.5.h),
        Row(
          children: [
            Expanded(
              child: _BenefitChip(
                icon: Icons.sell_outlined,
                label: tr.package_sale_listings,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _BenefitChip(
                icon: Icons.key_outlined,
                label: tr.package_rent_listings,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        AppButton(
          backgroundColor: AppColors.goldBrandColor,
          onPressed: onBrowse,
          child: Text(
            tr.browse_plans,
            style: appTextStyle(
              context,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.whiteColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyStepRow extends StatelessWidget {
  final int number;
  final IconData icon;
  final String label;
  final bool isLast;

  const _EmptyStepRow({
    required this.number,
    required this.icon,
    required this.label,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.goldBrandColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$number',
                style: appTextStyle(
                  context,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.goldBrandColor,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 2.2.h,
                margin: EdgeInsets.symmetric(vertical: 0.4.h),
                color: AppColors.goldBrandColor.withAlpha(40),
              ),
          ],
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 0.3.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: AppColors.goldBrandColor.withAlpha(200),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    label,
                    style: appTextStyle(
                      context,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withAlpha(160),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BenefitChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BenefitChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.goldBrandColor),
          SizedBox(width: 1.5.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appTextStyle(
                context,
                fontSize: 8.8.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black.withAlpha(150),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionCard extends ConsumerWidget {
  final MySubscriptionItem subscription;
  final VoidCallback onUploadProof;

  const _SubscriptionCard({
    required this.subscription,
    required this.onUploadProof,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(apiLanguageCodeProvider);
    final planName = subscription.package.name.forLang(lang);
    final awaitingReview = ref.watch(awaitingReviewSubscriptionsProvider);
    final isAwaitingAdmin =
        subscription.needsPayment && awaitingReview.contains(subscription.id);

    final statusLabel = _statusLabel(subscription, isAwaitingAdmin);
    final statusColor = _statusColor(subscription, isAwaitingAdmin);
    final headerColors = _headerGradient(subscription, isAwaitingAdmin);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(4.5.w, 3.5.w, 4.5.w, 4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: headerColors,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        planName,
                        style: appTextStyle(
                          context,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.5.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusLabel,
                        style: appTextStyle(
                          context,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.8.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: subscription.package.price,
                        style: appTextStyle(
                          context,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: ' $kAppCurrency',
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
                if (subscription.isActive || subscription.needsPayment) ...[
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: Colors.white.withAlpha(220),
                      ),
                      SizedBox(width: 1.5.w),
                      Text(
                        tr.subscription_days_remaining(subscription.daysRemaining),
                        style: appTextStyle(
                          context,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withAlpha(230),
                        ),
                      ),
                    ],
                  ),
                  if (subscription.isActive) ...[
                    SizedBox(height: 1.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: subscription.timeProgress,
                        minHeight: 6,
                        backgroundColor: Colors.white.withAlpha(50),
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isAwaitingAdmin) ...[
                  _InfoBanner(
                    icon: Icons.hourglass_top_rounded,
                    color: const Color(0xFF1565C0),
                    backgroundColor: const Color(0xFFE8F4FD),
                    message: tr.awaiting_admin_approval_message,
                  ),
                  SizedBox(height: 1.5.h),
                ] else if (subscription.needsPayment) ...[
                  _InfoBanner(
                    icon: Icons.pending_actions_rounded,
                    color: const Color(0xFFE67E22),
                    backgroundColor: const Color(0xFFFFF8E8),
                    message: tr.pending_payment_upload_hint,
                  ),
                  SizedBox(height: 1.5.h),
                ],
                _DateRow(
                  icon: Icons.play_circle_outline_rounded,
                  label: tr.subscription_starts_at,
                  value: _formatDate(subscription.startsAt),
                ),
                SizedBox(height: 1.h),
                _DateRow(
                  icon: Icons.event_busy_outlined,
                  label: tr.subscription_expires_at,
                  value: _formatDate(subscription.expiresAt),
                ),
                if (subscription.isActive) ...[
                  SizedBox(height: 2.h),
                  Text(
                    tr.subscription_usage_title,
                    style: appTextStyle(
                      context,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withAlpha(180),
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  _UsageMeter(
                    icon: Icons.sell_outlined,
                    label: tr.package_sale_listings,
                    usage: subscription.usage.saleAssets,
                  ),
                  SizedBox(height: 1.2.h),
                  _UsageMeter(
                    icon: Icons.key_outlined,
                    label: tr.package_rent_listings,
                    usage: subscription.usage.rentAssets,
                  ),
                ],
                SizedBox(height: 2.h),
                if (subscription.needsPayment && !isAwaitingAdmin)
                  AppButton(
                    backgroundColor: AppColors.goldBrandColor,
                    onPressed: onUploadProof,
                    child: Text(
                      tr.submit_payment_proof,
                      style: appTextStyle(
                        context,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  )
                else if (subscription.isExpiringSoon || subscription.isExpired)
                  AppButton(
                    backgroundColor: AppColors.goldBrandColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SubscriptionsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      tr.renew_now,
                      style: appTextStyle(
                        context,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _headerGradient(MySubscriptionItem sub, bool isAwaitingAdmin) {
    if (sub.needsPayment && !isAwaitingAdmin) {
      return [
        const Color(0xFFE67E22).withAlpha(220),
        const Color(0xFFE67E22),
      ];
    }
    if (isAwaitingAdmin) {
      return [
        const Color(0xFF1565C0).withAlpha(220),
        const Color(0xFF1565C0),
      ];
    }
    if (sub.isExpired) {
      return [
        Colors.grey.shade600.withAlpha(220),
        Colors.grey.shade600,
      ];
    }
    return [
      AppColors.goldBrandColor.withAlpha(220),
      AppColors.goldBrandColor,
    ];
  }

  String _statusLabel(MySubscriptionItem sub, bool isAwaitingAdmin) {
    if (isAwaitingAdmin) return tr.awaiting_admin_approval;
    switch (sub.status.toLowerCase()) {
      case 'active':
        return tr.subscription_status_active;
      case 'pending':
        return tr.subscription_status_pending;
      case 'expired':
        return tr.subscription_status_expired;
      default:
        return sub.status;
    }
  }

  Color _statusColor(MySubscriptionItem sub, bool isAwaitingAdmin) {
    if (isAwaitingAdmin) return const Color(0xFF1565C0);
    switch (sub.status.toLowerCase()) {
      case 'active':
        return const Color(0xFF2E8B47);
      case 'pending':
        return const Color(0xFFE67E22);
      case 'expired':
        return const Color(0xFFC0392B);
      default:
        return Colors.black.withAlpha(160);
    }
  }

  String _formatDate(String raw) {
    try {
      final normalized = raw.contains('T') ? raw : raw.replaceFirst(' ', 'T');
      final dt = DateTime.parse(normalized);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final String message;

  const _InfoBanner({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Text(
              message,
              style: appTextStyle(
                context,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(140),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DateRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.goldBrandColor.withAlpha(200)),
        SizedBox(width: 2.5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: appTextStyle(
                  context,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withAlpha(100),
                ),
              ),
              Text(
                value,
                style: appTextStyle(
                  context,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withAlpha(200),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UsageMeter extends StatelessWidget {
  final IconData icon;
  final String label;
  final SubscriptionAssetUsage usage;

  const _UsageMeter({
    required this.icon,
    required this.label,
    required this.usage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.black.withAlpha(120)),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                label,
                style: appTextStyle(
                  context,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withAlpha(150),
                ),
              ),
            ),
            Text(
              tr.subscription_listings_used(usage.used, usage.limit),
              style: appTextStyle(
                context,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.goldBrandColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: usage.usageRatio,
            minHeight: 7,
            backgroundColor: AppColors.goldBrandColor.withAlpha(25),
            valueColor: AlwaysStoppedAnimation(
              usage.remaining == 0
                  ? Colors.red.shade400
                  : AppColors.goldBrandColor,
            ),
          ),
        ),
        SizedBox(height: 0.4.h),
        Text(
          tr.subscription_listings_remaining(usage.remaining),
          style: appTextStyle(
            context,
            fontSize: 8.8.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black.withAlpha(90),
          ),
        ),
      ],
    );
  }
}
