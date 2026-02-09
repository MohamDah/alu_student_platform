import 'package:alu_student_platform/models/academic_session.dart';
import 'package:alu_student_platform/models/assignment_model.dart';
import 'package:alu_student_platform/screens/assignments_screen.dart';
import 'package:alu_student_platform/screens/dashboard_screen.dart';
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
      DashboardScreen(sessions: _sessions, assignments: _assignments),
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
