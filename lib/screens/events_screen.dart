import 'package:flutter/material.dart';
import 'package:konfus_app/services/event_service.dart';
import 'package:konfus_app/models/event_model.dart';

class EventsScreen extends StatelessWidget {
  final EventService eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktionsabende'),
      ),
      body: FutureBuilder<List<Event>>(
          future: eventService.fetchEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final events = snapshot.data!;
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  String date =
                      "${DateTime.parse(event.date).day}.${DateTime.parse(event.date).month.toString()}.${DateTime.parse(event.date).year.toString()}";
                  return ListTile(
                    leading: Icon(Icons.event),
                    title: Text(event.title),
                    subtitle: Text(date),
                  );
                },
              );
            } else {
              return Center(child: Text('No Events available'));
            }
          }),
    );
  }
}
