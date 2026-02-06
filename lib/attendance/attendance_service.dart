import 'dart:convert';
import '../models/attendance_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceService {
  static const _key = 'attendance_records';

  List<AttendanceRecord> _records = [];

  /// Load attendance records from SharedPreferences
  Future<void> loadAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key) ?? '[]';

    _records = (jsonDecode(raw) as List)
        .map((e) => AttendanceRecord.fromJson(e))
        .toList();
  }

  /// Save attendance records to SharedPreferences
  Future<void> _saveAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(_records.map((e) => e.toJson()).toList()),
    );
  }

  // Returns the total number of sessions recorded
  int getTotalSessions() {
    return _records.length;
  }

  // Return the total number of sessions attended
  int getPresentSessions() {
    int count = 0;
    for (var record in _records) {
      if (record.isPresent) {
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
  List<AttendanceRecord> getAttendanceHistory() {
    return List.from(_records); // return a copy for safety
  }
}