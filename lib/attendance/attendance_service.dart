import 'dart:convert';
import '../models/academic_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceService {
  static const _key = 'sessions';

  List<AcademicSession> _sessionRecords = [];

  /// Load attendance records from SharedPreferences
  Future<List<AcademicSession>> loadAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key) ?? '[]';

    _sessionRecords = (jsonDecode(raw) as List)
        .map((e) => AcademicSession.fromJson(e))
        .toList();

    return _sessionRecords;
  }

  // Returns the total number of sessions recorded
  int getTotalSessions() {
    return _sessionRecords.length;
  }

  // Return the total number of sessions attended
  int getPresentSessions() {
    int count = 0;
    for (var record in _sessionRecords) {
      if (record.isPresent == true) {
        count++;
      }
    }
    return count;
  }

  // Returns the attendance percentage as a double
  double getAttendancePercentage() {
    int total = getTotalSessions();
    int present = getPresentSessions();

    if (total == 0) {
      return 100.0; // no sessions yet
    }

    return (present / total) * 100;
  }

  // Returns true if attendance is below 75%
  bool isAttendanceBelowThreshold() {
    return getAttendancePercentage() < 75.0;
  }

  // Returns a list of all attendance records (history)
  List<AcademicSession> getAttendanceHistory() {
    return List.from(_sessionRecords); // return a copy for safety
  }
}