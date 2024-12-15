import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification service and sets up notification channels for Android.
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(initializationSettings);

    if (Platform.isAndroid) {
      // Request notification permission for Android 13+
      if (await Permission.notification.isDenied) {
        final status = await Permission.notification.request();
        if (status.isDenied || status.isPermanentlyDenied) {
          print("Notification permission denied.");
        }
      }

      final androidPlugin =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        // Request exact alarm permission for Android 12+ (API 31+)
        final granted = await androidPlugin.requestExactAlarmsPermission();
        if (granted != true) {
          print("Exact alarms permission denied.");
        }

        // Create notification channel
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'channel_id',
            'Scheduled Notifications',
            description: 'Notifications for scheduled tasks',
            importance: Importance.max,
          ),
        );
      }
    }
  }

  /// Schedules a notification at a specific date and time.
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          iOS: DarwinNotificationDetails(),
          android: AndroidNotificationDetails(
            'channel_id',
            'Scheduled Notifications',
            channelDescription: 'Notifications for scheduled tasks',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      print("Notification scheduled for $scheduledDate");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  /// Displays an instant notification.
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id', // Channel ID must match the created channel
          'Instant Notifications',
          channelDescription: 'Notifications for instant tasks',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );

      await _notificationsPlugin.show(id, title, body, notificationDetails);
    } catch (e) {
      print("Error showing notification: $e");
    }
  }

  /// Cancels a specific notification by ID.
  static Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
    } catch (e) {
      print("Error canceling notification: $e");
    }
  }

  /// Retrieves all scheduled notifications.
  static Future<List<PendingNotificationRequest>> getScheduledNotifications() {
    return _notificationsPlugin.pendingNotificationRequests();
  }
}
