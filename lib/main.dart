import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService.initialize();
  NotificationService.scheduleNotification(
      id: 1,
      title: 'Scheduled Notification',
      body: 'This is a scheduled Notification',
      scheduledDate: DateTime.now().add(Duration(seconds: 10)));
  runApp(const KonfusApp());
}

class KonfusApp extends StatelessWidget {
  const KonfusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Konfus',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}
