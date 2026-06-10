import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Top-level background message handler (required by FCM — must be top-level).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase is already initialized before this runs via the isolate setup.
  // Handle background data messages here if needed.
  debugPrint('FCM background message: ${message.messageId}');
}

class NotificationService {
  NotificationService._();

  static final _messaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _androidChannelId = 'high_importance_channel';
  static const _androidChannelName = 'High Importance Notifications';

  /// Call once in [main] after [Firebase.initializeApp].
  static Future<void> initialize() async {
    // 1. Register the background handler.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 2. Request permission (iOS / Android 13+).
    await _requestPermission();

    // 3. Set up local notifications (used to show heads-up on foreground).
    await _initLocalNotifications();

    // 4. Foreground message handler.
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 5. Notification-tap handlers.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // 6. Handle notification that launched the app from terminated state.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }

    // 7. Force foreground presentation on iOS.
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 8. Save and print the FCM token.
    // Note: on iOS simulators APNs is unavailable — token fetch is skipped.
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcmToken', token);
      }
      debugPrint('FCM Token: $token');
    } catch (e) {
      debugPrint('FCM getToken skipped: $e');
    }

    // Listen for token refreshes.
    _messaging.onTokenRefresh.listen((newToken) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcmToken', newToken);
      debugPrint('FCM Token refreshed: $newToken');
      // TODO: send newToken to your backend.
    });
  }

  // ---------------------------------------------------------------------------

  static Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('FCM permission: ${settings.authorizationStatus}');
  }

  static Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Local notification tapped: ${details.payload}');
        // TODO: navigate based on payload.
      },
    );

    // Create the Android high-importance channel.
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        importance: Importance.high,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('FCM foreground message: ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannelId,
          _androidChannelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data['route'],
    );
  }

  static void _handleMessageTap(RemoteMessage message) {
    debugPrint('FCM notification tapped: ${message.data}');
    // TODO: navigate to the relevant screen based on message.data['route'].
  }

  /// Returns the current FCM device token.
  static Future<String?> getToken() async {
    final token = await _messaging.getToken();
    debugPrint("FCM Token: $token");

    return token;
  }
}
