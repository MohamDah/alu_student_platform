import 'package:flutter/material.dart';
import 'dart:convert';

class AcademicSession {
  String id;
  String title;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String? location;
  String type; // Class, Mastery Session, Study Group, PSL Meeting
  bool? isPresent;

  AcademicSession({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.type,
    this.isPresent,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date.toIso8601String(),
    'startTime': '${startTime.hour}:${startTime.minute}',
    'endTime': '${endTime.hour}:${endTime.minute}',
    'location': location,
    'type': type,
    'isPresent': isPresent,
  };

  factory AcademicSession.fromJson(Map<String, dynamic> json) {
    final startParts = json['startTime'].split(':');
    final endParts = json['endTime'].split(':');
    return AcademicSession(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      startTime: TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      ),
      location: json['location'],
      type: json['type'],
      isPresent: json['isPresent'],
    );
  }

  // Encode or decode list of academic sessions
  static String encode(List<AcademicSession> sessions) => jsonEncode(
    sessions.map<Map<String, dynamic>>((a) => a.toJson()).toList(),
  );

  static List<AcademicSession> decode(String sessions) =>
      (jsonDecode(sessions) as List<dynamic>)
          .map<AcademicSession>((item) => AcademicSession.fromJson(item))
          .toList();
}
