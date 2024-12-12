import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:konfus_app/models/event_model.dart';

class EventService {
  final String apiUrl = "http://212.132.97.160:8080/api/events";

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}
