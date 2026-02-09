import 'package:alu_student_platform/models/academic_session.dart';
import 'package:alu_student_platform/models/assignment_model.dart';
import 'package:alu_student_platform/screens/assignments_screen.dart';
import 'package:alu_student_platform/screens/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/alu_colors.dart';

void main() {
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Student Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ALUColors.navyBlue,
        scaffoldBackgroundColor: ALUColors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ALUColors.navyBlue,
          primary: ALUColors.navyBlue,
          secondary: ALUColors.red,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ALUColors.navyBlue,
          foregroundColor: ALUColors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ALUColors.red,
          foregroundColor: ALUColors.navyBlue,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  List<AcademicSession> _sessions = [];
  List<Assignment> _assignments = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load sessions
      final sessionString = prefs.getString('sessions') ?? '[]';
      _sessions = AcademicSession.decode(sessionString);

      // Load assignments
      final assignmentsString = prefs.getString('assignments') ?? '[]';
      _assignments = Assignment.decode(assignmentsString);
    });
  }

  Future<void> _saveSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'sessions',
      AcademicSession.encode(_sessions)
    );
  }

  void _updateSession(List<AcademicSession> newList) {
    setState(() => _sessions = newList);
    _saveSessionData();
  }

  Future<void> _saveAssignmentData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'assignments',
      Assignment.encode(_assignments),
    );
  }

  void _updateAssignment(List<Assignment> newList) {
    setState(() => _assignments = newList);
    _saveAssignmentData();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeDashboard(sessions: _sessions, assignments: _assignments),
      AssignmentsScreen(
        assignments: _assignments,
        onUpdate: _updateAssignment,
      ),
      ScheduleScreen(sessions: _sessions, onUpdate: _updateSession),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ALUColors.navyBlue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ALUColors.white,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

/// adding the dashboard finally-----------------------

class HomeDashboard extends StatelessWidget {
  final List<AcademicSession> sessions;
  final List<Assignment> assignments;

  const HomeDashboard({
    super.key,
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

  List<Assignment> getUpcomingAssignments() {
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

  @override
  Widget build(BuildContext context) {
    final attendance = attendancePercentage;
    final upcomingAssignments = getUpcomingAssignments();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date & Academic Week
            Text(
              "Today: ${today.day}/${today.month}/${today.year}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Academic Week $academicWeek",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 20),

            // Attendance Card
            Card(
              color: attendance < 75
                  ? Colors.red.shade100
                  : Colors.green.shade100,
              child: ListTile(
                leading: Icon(
                  Icons.school,
                  color: attendance < 75 ? Colors.red : Colors.green,
                ),
                title: Text("Attendance: ${attendance.toStringAsFixed(1)}%"),
                subtitle: attendance < 75
                    ? const Text(
                        "⚠️ Attendance below 75%",
                        style: TextStyle(color: Colors.red),
                      )
                    : const Text("Good standing"),
              ),
            ),

            const SizedBox(height: 20),

            // Pending assignments count
            Card(
              color: pendingAssignmentsCount > 0
                  ? Colors.orange.shade100
                  : Colors.blue.shade100,
              child: ListTile(
                leading: Icon(
                  Icons.assignment_late,
                  color: pendingAssignmentsCount > 0
                      ? Colors.orange
                      : Colors.blue,
                ),
                title: Text("Pending Assignments: $pendingAssignmentsCount"),
              ),
            ),

            const SizedBox(height: 20),

            // Upcoming Assignments (Next 7 Days)
            Text(
              "Assignments Due in Next 7 Days",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            upcomingAssignments.isEmpty
                ? const Text("No assignments due in the next 7 days.")
                : Column(
                    children: upcomingAssignments.map((a) {
                      final todayMidnight = DateTime(today.year, today.month, today.day);
                      final dueDateMidnight = DateTime(a.dueDate.year, a.dueDate.month, a.dueDate.day);
                      final daysUntilDue = dueDateMidnight.difference(todayMidnight).inDays;
                      return Card(
                        color: daysUntilDue <= 2 ? Colors.red.shade50 : null,
                        child: ListTile(
                          title: Text(a.title),
                          subtitle: Text(
                            "${a.courseName} - Due: ${a.dueDate.day}/${a.dueDate.month}/${a.dueDate.year} - ${a.priority}",
                          ),
                          trailing: Text(
                            daysUntilDue == 0
                                ? "Due Today"
                                : daysUntilDue == 1
                                    ? "Due Tomorrow"
                                    : "In $daysUntilDue days",
                            style: TextStyle(
                              color: daysUntilDue <= 2 ? Colors.red : null,
                              fontWeight:
                                  daysUntilDue <= 2 ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 20),

            // Today's Sessions
            Text(
              "Today's Sessions",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            todaySessions.isEmpty
                ? const Text("No sessions today.")
                : Column(
                    children: todaySessions.map((s) {
                      return Card(
                        child: ListTile(
                          title: Text(s.title),
                          subtitle: Text(
                            "${s.startTime.format(context)} - ${s.endTime.format(context)}",
                          ),
                          trailing: Icon(
                            s.isPresent == true
                                ? Icons.check_circle
                                : s.isPresent == false
                                    ? Icons.cancel
                                    : Icons.help_outline,
                            color: s.isPresent == true
                                ? Colors.green
                                : s.isPresent == false
                                    ? Colors.red
                                    : Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
