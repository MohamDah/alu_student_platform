import 'dart:convert';

class Assignment {
  String id;
  String title;
  String courseName;
  DateTime dueDate;
  String priority; // 'High', 'Medium', or 'Low'
  String type; // 'Formative' or 'Summative'
  bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.courseName,
    required this.dueDate,
    required this.priority,
    required this.type,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'courseName': courseName,
    'dueDate': dueDate.toIso8601String(),
    'priority': priority,
    'type': type,
    'isCompleted': isCompleted,
  };

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      courseName: json['courseName'],
      dueDate: DateTime.parse(json['dueDate']),
      priority: json['priority'],
      type: json['type'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // Encode or decode list of assignments
  static String encode(List<Assignment> assignments) => jsonEncode(
    assignments.map<Map<String, dynamic>>((a) => a.toJson()).toList(),
  );

  static List<Assignment> decode(String assignments) =>
      (jsonDecode(assignments) as List<dynamic>)
          .map<Assignment>((item) => Assignment.fromJson(item))
          .toList();
}
