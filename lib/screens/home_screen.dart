import 'package:flutter/material.dart';
import 'package:konfus_app/screens/event_calendar_screen.dart';
import 'package:konfus_app/screens/events_screen.dart';
import 'package:konfus_app/screens/notifications_test_screen.dart';
import 'package:konfus_app/screens/scheduled_notifications_screen.dart';
import 'package:konfus_app/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    EventsScreen(),
    EventCalendarScreen(),
    const NotificationsTestScreen(),
    const ScheduledNotificationsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification test',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Scheduled Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
