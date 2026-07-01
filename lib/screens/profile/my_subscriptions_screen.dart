import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/controller/local_provider.dart';
import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/features/packages/data/models/my_subscription_item.dart';
import 'package:dar_plus_app/features/packages/data/models/payment_info_response.dart';
import 'package:dar_plus_app/features/packages/data/models/subscription_asset_usage.dart';
import 'package:dar_plus_app/features/packages/presentation/providers/packages_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/profile/subscriptions_screen.dart';
import 'package:dar_plus_app/screens/profile/widgets/content_widgets.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/app_net_image.dart';
import 'package:dar_plus_app/utils/widgets/login_required_view.dart';
import 'package:dar_plus_app/utils/widgets/payment_submission_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class MySubscriptionsScreen extends ConsumerWidget {
  const MySubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          : Builder(
              builder: (context) {
                final subscriptionsAsync =
                    ref.watch(mySubscriptionsControllerProvider);
                final paymentInfoAsync = ref.watch(paymentInfoControllerProvider);

                if (subscriptionsAsync.isLoading && !subscriptionsAsync.hasValue) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.goldBrandColor,
                    ),
                  );
                }

                if (subscriptionsAsync.hasError && !subscriptionsAsync.hasValue) {
                  return Center(
                    child: ContentErrorRetry(
                      onRetry: () => _refreshAll(ref),
                    ),
                  );
                }

                return _SubscriptionsBody(
                  subscriptions: subscriptionsAsync.value ?? [],
                  paymentInfoAsync: paymentInfoAsync,
                  onRefresh: () => _refreshAll(ref),
                );
              },
            ),
    );
  }

  Future<void> _refreshAll(WidgetRef ref) async {
    await Future.wait([
      ref.read(mySubscriptionsControllerProvider.notifier).refresh(),
      ref.read(paymentInfoControllerProvider.notifier).refresh(),
    ]);
  }
}

class _SubscriptionsBody extends ConsumerWidget {
  final List<MySubscriptionItem> subscriptions;
  final AsyncValue<PaymentInfoResponse?> paymentInfoAsync;
  final Future<void> Function() onRefresh;

  const _SubscriptionsBody({
    required this.subscriptions,
    required this.paymentInfoAsync,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentCard = paymentInfoAsync.when(
      data: (info) => info == null ? null : _PaymentInfoCard(info: info),
      loading: () => _PaymentInfoLoadingCard(),
      error: (_, __) => _PaymentInfoErrorCard(onRetry: onRefresh),
    );

    return RefreshIndicator(
      color: AppColors.goldBrandColor,
      onRefresh: onRefresh,
      child: subscriptions.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              children: [
                if (paymentCard != null) ...[
                  paymentCard,
                  SizedBox(height: 2.h),
                ],
                _EmptySubscriptions(onBrowse: () => _openPlans(context)),
              ],
            )
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
              children: [
                if (paymentCard != null) ...[
                  paymentCard,
                  SizedBox(height: 2.h),
                ],
                ...subscriptions.map(
                  (subscription) => Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: _SubscriptionCard(subscription: subscription),
                  ),
                ),
              ],
            ),
    );
  }

  void _openPlans(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SubscriptionsScreen()),
    );
  }
}

class _PaymentInfoCard extends StatelessWidget {
  final PaymentInfoResponse info;

  const _PaymentInfoCard({required this.info});

  @override
  Widget build(BuildContext context) {
    final fields = <_PaymentField>[
      _PaymentField(tr.bank_account_name, info.bankAccountName),
      _PaymentField(tr.bank_account_number, info.bankAccountNumber),
      _PaymentField(tr.bank_iban, info.bankIban),
      _PaymentField(tr.bank_swift, info.bankSwift),
      _PaymentField(tr.bank_cliq, info.bankCliq),
      _PaymentField(tr.bank_phone, info.bankPhone),
    ].where((field) => field.value.trim().isNotEmpty).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(4.5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.8.w),
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor.withAlpha(22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance_rounded,
                  color: AppColors.goldBrandColor,
                  size: 22,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.payment_info_title,
                      style: appTextStyle(
                        context,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.black.withAlpha(220),
                      ),
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      tr.payment_info_subtitle,
                      style: appTextStyle(
                        context,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withAlpha(110),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (info.bankImage != null && info.bankImage!.isNotEmpty) ...[
            SizedBox(height: 1.5.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AppNetImage(
                url: info.bankImage!,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ],
          SizedBox(height: 1.5.h),
          ...fields.map(
            (field) => _PaymentInfoRow(
              label: field.label,
              value: field.value,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentField {
  final String label;
  final String value;

  const _PaymentField(this.label, this.value);
}

class _PaymentInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _PaymentInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7F4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: appTextStyle(
                      context,
                      fontSize: 8.8.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withAlpha(100),
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    value,
                    style: appTextStyle(
                      context,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withAlpha(210),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _copyValue(context, value),
              icon: Icon(
                Icons.copy_rounded,
                size: 18,
                color: AppColors.goldBrandColor.withAlpha(200),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              tooltip: tr.copied_to_clipboard,
            ),
          ],
        ),
      ),
    );
  }

  void _copyValue(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr.copied_to_clipboard),
        backgroundColor: Colors.black.withAlpha(220),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _PaymentInfoLoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        color: AppColors.goldBrandColor,
        strokeWidth: 2.5,
      ),
    );
  }
}

class _PaymentInfoErrorCard extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _PaymentInfoErrorCard({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              tr.something_went_wrong,
              style: appTextStyle(
                context,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(140),
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              tr.try_again,
              style: appTextStyle(
                context,
                fontSize: 10.sp,
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

class _EmptySubscriptions extends StatelessWidget {
  final VoidCallback onBrowse;

  const _EmptySubscriptions({required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppColors.goldBrandColor.withAlpha(18),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.workspace_premium_outlined,
            size: 48,
            color: AppColors.goldBrandColor.withAlpha(200),
          ),
        ),
        SizedBox(height: 2.5.h),
        Text(
          tr.my_subscription_empty_title,
          textAlign: TextAlign.center,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(210),
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
            color: Colors.black.withAlpha(110),
            height: 1.4,
          ),
        ),
        SizedBox(height: 3.h),
        AppButton(
          backgroundColor: AppColors.goldBrandColor,
          onPressed: onBrowse,
          child: Text(
            tr.browse_plans,
            style: appTextStyle(
              context,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.whiteColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubscriptionCard extends ConsumerStatefulWidget {
  final MySubscriptionItem subscription;

  const _SubscriptionCard({required this.subscription});

  @override
  ConsumerState<_SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends ConsumerState<_SubscriptionCard> {
  bool _isProcessing = false;

  MySubscriptionItem get sub => widget.subscription;

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(apiLanguageCodeProvider);
    final planName = sub.package.name.forLang(lang);
    final statusLabel = _statusLabel(sub.status);
    final statusColor = _statusColor(sub.status);

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
                colors: [
                  AppColors.goldBrandColor.withAlpha(220),
                  AppColors.goldBrandColor,
                ],
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
                    _StatusBadge(label: statusLabel, color: statusColor),
                  ],
                ),
                SizedBox(height: 0.8.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: sub.package.price,
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
                if (sub.isActive || sub.isExpiringSoon) ...[
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
                        tr.subscription_days_remaining(sub.daysRemaining),
                        style: appTextStyle(
                          context,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withAlpha(230),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: sub.timeProgress,
                      minHeight: 6,
                      backgroundColor: Colors.white.withAlpha(50),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DateRow(
                  icon: Icons.play_circle_outline_rounded,
                  label: tr.subscription_starts_at,
                  value: _formatDate(sub.startsAt),
                ),
                SizedBox(height: 1.h),
                _DateRow(
                  icon: Icons.event_busy_outlined,
                  label: tr.subscription_expires_at,
                  value: _formatDate(sub.expiresAt),
                ),
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
                  usage: sub.usage.saleAssets,
                ),
                SizedBox(height: 1.2.h),
                _UsageMeter(
                  icon: Icons.key_outlined,
                  label: tr.package_rent_listings,
                  usage: sub.usage.rentAssets,
                ),
                SizedBox(height: 2.2.h),
                if (sub.needsPayment)
                  AppButton(
                    backgroundColor: AppColors.goldBrandColor,
                    onPressed: _isProcessing ? () {} : _submitPaymentProof,
                    child: _actionChild(tr.submit_payment_proof),
                  )
                else if (sub.isExpired || sub.isExpiringSoon)
                  AppButton(
                    backgroundColor: AppColors.goldBrandColor,
                    onPressed: _isProcessing ? () {} : _renewSubscription,
                    child: _actionChild(tr.renew_now),
                  )
                else
                  AppButton(
                    backgroundColor: AppColors.goldBrandColor,
                    onPressed: _openPlans,
                    child: Text(
                      tr.upgrade_plan,
                      style: appTextStyle(
                        context,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                if (!sub.needsPayment) ...[
                  SizedBox(height: 1.2.h),
                  AppButton(
                    backgroundColor: Colors.transparent,
                    borderColor: AppColors.goldBrandColor.withAlpha(120),
                    onPressed: _openPlans,
                    child: Text(
                      tr.browse_plans,
                      style: appTextStyle(
                        context,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.goldBrandColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionChild(String label) {
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
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.whiteColor,
      ),
    );
  }

  Future<void> _submitPaymentProof() async {
    await showPaymentSubmissionSheet(context: context, subscription: sub);
  }

  Future<void> _renewSubscription() async {
    setState(() => _isProcessing = true);
    try {
      await ref
          .read(subscribeControllerProvider.notifier)
          .subscribe(sub.package.id);
      await ref.read(mySubscriptionsControllerProvider.notifier).refresh();
      if (!mounted) return;

      final subscriptions =
          ref.read(mySubscriptionsControllerProvider).value ?? [];
      MySubscriptionItem? pendingSub;
      for (final item in subscriptions) {
        if (item.needsPayment && item.package.id == sub.package.id) {
          pendingSub = item;
          break;
        }
      }

      if (pendingSub != null) {
        await showPaymentSubmissionSheet(
          context: context,
          subscription: pendingSub,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr.subscription_renew_message),
            backgroundColor: Colors.black.withAlpha(220),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _openPlans() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SubscriptionsScreen()),
    );
  }

  String _formatDate(String raw) {
    try {
      final normalized = raw.contains('T') ? raw : raw.replaceFirst(' ', 'T');
      final dt = DateTime.parse(normalized);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final month = months[dt.month - 1];
      return '${dt.day.toString().padLeft(2, '0')} $month ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return tr.subscription_status_active;
      case 'pending':
        return tr.subscription_status_pending;
      case 'expired':
        return tr.subscription_status_expired;
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF2E8B47);
      case 'pending':
        return const Color(0xFFE67E22);
      case 'expired':
        return const Color(0xFFC0392B);
      default:
        return Colors.white.withAlpha(200);
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: appTextStyle(
          context,
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          color: color,
        ),
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
