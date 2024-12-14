import 'package:flutter/material.dart';
import 'package:konfus_app/services/event_service.dart';
import 'package:konfus_app/models/event_model.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends State<EventsScreen> {
  final EventService eventService = EventService();
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() {
    setState(() {
      _eventsFuture = eventService.fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktionsabende'),
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final events = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async {
                _fetchEvents();
                await _eventsFuture; // Wait for the fetch to complete
              },
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  String date =
                      "${DateTime.parse(event.date).day}.${DateTime.parse(event.date).month}.${DateTime.parse(event.date).year}";
                  return ListTile(
                    leading: Icon(Icons.event),
                    title: Text(event.title),
                    subtitle: Text(date),
                  );
                },
              ),
            );
          } else {
            return Center(child: Text('No Events available'));
          }
        },
      ),
    );
  }
}
