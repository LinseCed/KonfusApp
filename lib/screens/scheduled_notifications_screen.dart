import 'package:flutter/material.dart';
import 'package:konfus_app/services/notification_service.dart';

class ScheduledNotificationsScreen extends StatelessWidget {
  const ScheduledNotificationsScreen({super.key});

  Future<void> _showScheduledNotifications(BuildContext context) async {
    final notifications = await NotificationService.getScheduledNotifications();

    // Build a list of scheduled notifications
    final notificationList = notifications
        .map((notification) =>
            'ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}')
        .toList();

    // Show as a dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scheduled Notifications'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: notificationList.map((text) => Text(text)).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scheduled Notifications')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => {_showScheduledNotifications(context)},
          child: const Text('Check Scheduled Notifications'),
        ),
      ),
    );
  }
}
