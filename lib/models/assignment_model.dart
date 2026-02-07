import 'dart:convert';

class Assignment {
  String id;
  String title;
  String courseName;
  DateTime dueDate;
  String priority; // 'High', 'Medium', or 'Low'
  String type;     // 'Formative' or 'Summative'
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

  // Convert an Assignment to a Map (for saving)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'courseName': courseName,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'type': type,
      'isCompleted': isCompleted,
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'],
      title: map['title'],
      courseName: map['courseName'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: map['priority'],
      type: map['type'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  // encode or decode list
  static String encode(List<Assignment> assignments) => json.encode(
        assignments.map<Map<String, dynamic>>((a) => a.toMap()).toList(),
      );

  static List<Assignment> decode(String assignments) =>
      (json.decode(assignments) as List<dynamic>)
          .map<Assignment>((item) => Assignment.fromMap(item))
          .toList();
}
