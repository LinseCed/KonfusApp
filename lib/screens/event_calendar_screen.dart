import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:konfus_app/models/event_model.dart';
import 'package:konfus_app/services/event_service.dart';

class EventCalendarScreen extends StatefulWidget {
  @override
  _EventCalendarScreenState createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  final EventService eventService = EventService();
  Map<DateTime, List<Event>> eventsByDate = {};
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchAndGroupEvents();
  }

  Future<void> fetchAndGroupEvents() async {
    final events = await eventService.fetchEvents();
    final Map<DateTime, List<Event>> groupedEvents = {};

    for (var event in events) {
      final eventDate = DateTime.parse(event.date).toLocal();
      final normalizedDate =
          DateTime(eventDate.year, eventDate.month, eventDate.day);
      if (groupedEvents[normalizedDate] == null) {
        groupedEvents[normalizedDate] = [];
      }
      groupedEvents[normalizedDate]!.add(event);
    }

    setState(() {
      eventsByDate = groupedEvents;
    });
  }

  List<Event> getEventsForSelectedDay() {
    final normalizedDay =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    return eventsByDate[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalendar'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: selectedDay,
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) {
              final events =
                  eventsByDate[DateTime(day.year, day.month, day.day)] ?? [];
              return events;
            },
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: getEventsForSelectedDay().length,
              itemBuilder: (context, index) {
                final event = getEventsForSelectedDay()[index];
                String date =
                    "${DateTime.parse(event.date).day}.${DateTime.parse(event.date).month.toString()}.${DateTime.parse(event.date).year.toString()}";
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(date),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
