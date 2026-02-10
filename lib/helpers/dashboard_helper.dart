import 'package:alu_student_platform/models/academic_session.dart';
import 'package:alu_student_platform/models/assignment_model.dart';

class DashboardHelper {
  final List<AcademicSession> sessions;
  final List<Assignment> assignments;

  DashboardHelper({
    required this.sessions,
    required this.assignments,
  });

  DateTime get today => DateTime.now();

  int get academicWeek {
    final semesterStart = DateTime(today.year, 1, 15);
    return ((today.difference(semesterStart).inDays) ~/ 7) + 1;
  }

  List<AcademicSession> get todaySessions {
    return sessions
        .where(
          (s) =>
              s.date.year == today.year &&
              s.date.month == today.month &&
              s.date.day == today.day,
        )
        .toList();
  }

  double get attendancePercentage {
    final attended = sessions.where((s) => s.isPresent == true).length;
    final total = sessions.where((s) => s.isPresent != null).length;
    if (total == 0) return 100;
    return (attended / total) * 100;
  }

  List<Assignment> get upcomingAssignments {
    final sevenDaysFromNow = today.add(const Duration(days: 7));
    return assignments
        .where((a) =>
            !a.isCompleted &&
            a.dueDate.isAfter(today.subtract(const Duration(days: 1))) &&
            a.dueDate.isBefore(sevenDaysFromNow.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  int get pendingAssignmentsCount {
    return assignments.where((a) => !a.isCompleted).length;
  }
}
