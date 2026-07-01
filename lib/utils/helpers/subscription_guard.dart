import 'package:dar_plus_app/features/packages/data/models/subscription_status_response.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/profile/my_subscriptions_screen.dart';
import 'package:dar_plus_app/screens/profile/subscriptions_screen.dart';
import 'package:flutter/material.dart';

Future<void> showSubscriptionBlockedDialog({
  required BuildContext context,
  required SubscriptionStatusResponse status,
}) {
  final isPending = status.isPending;
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        isPending ? tr.awaiting_admin_approval : tr.subscription_required_title,
      ),
      content: Text(status.message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(tr.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => isPending
                    ? const MySubscriptionsScreen()
                    : const SubscriptionsScreen(),
              ),
            );
          },
          child: Text(isPending ? tr.my_subscriptions : tr.renew_now),
        ),
      ],
    ),
  );
}

void showSubscriptionApiErrorDialog({
  required BuildContext context,
  required String message,
}) {
  final lower = message.toLowerCase();
  final isPending = lower.contains('pending');
  final isSubscriptionIssue = lower.contains('subscription');

  if (!isSubscriptionIssue) return;

  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        isPending ? tr.awaiting_admin_approval : tr.subscription_required_title,
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(tr.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => isPending
                    ? const MySubscriptionsScreen()
                    : const SubscriptionsScreen(),
              ),
            );
          },
          child: Text(isPending ? tr.my_subscriptions : tr.renew_now),
        ),
      ],
    ),
  );
}
