import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:konfus_app/services/notification_service.dart';

class NotificationsTestScreen extends StatelessWidget {
  const NotificationsTestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notification Test'),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                NotificationService.showNotification(
                    id: 0,
                    title: 'Test Notification',
                    body: 'This is a test Notification');
              },
              child: const Text('Show test Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                NotificationService.scheduleNotificaiton(
                    id: 1,
                    title: 'Scheduled Notification',
                    body: 'This is a scheduled Notification',
                    scheduledDate: DateTime.now().add(Duration(seconds: 10)));
              },
              child: const Text('Scheduled Notification in 10s'),
            ),
          ],
        )));
  }
}
