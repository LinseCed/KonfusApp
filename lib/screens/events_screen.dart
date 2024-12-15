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

  void _showEventDetails(Event event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Date: ${DateTime.parse(event.date).day}.${DateTime.parse(event.date).month}.${DateTime.parse(event.date).year}",
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
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
                    onTap: () => _showEventDetails(event),
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
