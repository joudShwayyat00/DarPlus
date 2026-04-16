import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      title: tr.notification_booking_confirmed_title,
      message: tr.notification_booking_confirmed_message,
      time: "2 hours ago",
      type: NotificationType.booking,
      isRead: false,
    ),
    _NotificationItem(
      title: tr.special_offer_title,
      message: tr.special_offer_message,
      time: "5 hours ago",
      type: NotificationType.promo,
      isRead: false,
    ),
    _NotificationItem(
      title: tr.payment_received_title,
      message: tr.payment_received_message,
      time: "1 day ago",
      type: NotificationType.payment,
      isRead: true,
    ),
    _NotificationItem(
      title: tr.review_request_title,
      message: tr.review_request_message,
      time: "2 days ago",
      type: NotificationType.review,
      isRead: true,
    ),
    _NotificationItem(
      title: tr.new_property_alert_title,
      message: tr.new_property_alert_message,
      time: "3 days ago",
      type: NotificationType.alert,
      isRead: true,
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
          tr.notifications,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification.isRead = true;
                }
              });
            },
            child: Text(
              tr.mark_all_read,
              style: appTextStyle(
                context,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.goldBrandColor,
              ),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(_notifications[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 60,
            color: Colors.black.withAlpha(60),
          ),
          SizedBox(height: 2.h),
          Text(
            tr.no_notifications_yet,
            style: appTextStyle(
              context,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black.withAlpha(120),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            tr.will_notify_when_something_arrives,
            style: appTextStyle(
              context,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black.withAlpha(80),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(_NotificationItem notification) {
    return Dismissible(
      key: Key(notification.title + notification.time),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 1.5.h),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(200),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 5.w),
        child: Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.remove(notification);
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1.5.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : AppColors.goldBrandColor.withAlpha(8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? Colors.black.withAlpha(10)
                : AppColors.goldBrandColor.withAlpha(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: _getTypeColor(notification.type).withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTypeIcon(notification.type),
                size: 20,
                color: _getTypeColor(notification.type),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: appTextStyle(
                            context,
                            fontSize: 11.5.sp,
                            fontWeight: notification.isRead
                                ? FontWeight.w700
                                : FontWeight.w800,
                            color: Colors.black.withAlpha(220),
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.goldBrandColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    notification.message,
                    style: appTextStyle(
                      context,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withAlpha(140),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    notification.time,
                    style: appTextStyle(
                      context,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withAlpha(80),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Icons.calendar_today_rounded;
      case NotificationType.promo:
        return Icons.local_offer_rounded;
      case NotificationType.payment:
        return Icons.payment_rounded;
      case NotificationType.review:
        return Icons.star_rounded;
      case NotificationType.alert:
        return Icons.home_rounded;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Colors.blue;
      case NotificationType.promo:
        return AppColors.goldBrandColor;
      case NotificationType.payment:
        return Colors.green;
      case NotificationType.review:
        return Colors.amber;
      case NotificationType.alert:
        return Colors.purple;
    }
  }
}

enum NotificationType { booking, promo, payment, review, alert }

class _NotificationItem {
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  bool isRead;

  _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });
}
