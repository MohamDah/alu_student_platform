class AttendanceRecord {
  final String sessionTitle;
  final DateTime date;
  final bool isPresent;

  AttendanceRecord({
    required this.sessionTitle,
    required this.date,
    required this.isPresent,
  });

  Map<String, dynamic> toJson() {
        return {'sessionTitle': sessionTitle,
        'date': date.toIso8601String(),
        'isPresent': isPresent,};
      }
  
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      sessionTitle: json['sessionTitle'],
      date: DateTime.parse(json['date']),
      isPresent: json['isPresent'],
    );
  }
}

