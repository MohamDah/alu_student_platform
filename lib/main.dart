import 'dart:convert';

import 'package:alu_student_platform/models/academic_session.dart';
import 'package:alu_student_platform/screens/schedule_screen.dart';
import 'package:alu_student_platform/theme/alu_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        useMaterial3: true,
        scaffoldBackgroundColor: ALUColors.navyBlue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ALUColors.navyBlue,
          primary: ALUColors.navyBlue,
          secondary: ALUColors.yellow,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ALUColors.navyBlue,
          foregroundColor: ALUColors.white,
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('sessions') ?? '[]';
    setState(() {
      _sessions = (jsonDecode(raw) as List)
          .map((e) => AcademicSession.fromJson(e))
          .toList();
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'sessions',
      jsonEncode(_sessions.map((e) => e.toJson()).toList()),
    );
  }

  void _updateSessions(List<AcademicSession> updated) {
    setState(() => _sessions = updated);
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(sessions: _sessions),
      const AssignmentsPlaceholder(),
      ScheduleScreen(sessions: _sessions, onUpdate: _updateSessions),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('ALU Student Platform')),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ALUColors.navyBlue,
        currentIndex: _selectedIndex,
        selectedItemColor: ALUColors.yellow,
        unselectedItemColor: ALUColors.grey,
        onTap: (i) => setState(() => _selectedIndex = i),
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
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final List<AcademicSession> sessions;

  const DashboardScreen({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todaySessions = sessions
        .where(
          (s) =>
              s.date.year == now.year &&
              s.date.month == now.month &&
              s.date.day == now.day,
        )
        .toList();

    final upcomingAssignments = 0;
    final presentCount =
        sessions.where((s) => s.isPresent == true).length;
    final attendance =
        sessions.isEmpty ? 100 : ((presentCount / sessions.length) * 100).round();
    final atRisk = attendance < 75;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today: ${DateFormat('EEE, MMM d').format(now)}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          _section('Attendance'),
          Card(
            color: atRisk ? ALUColors.redRisk : Colors.green,
            child: ListTile(
              title: const Text(
                'Overall Attendance',
                style: TextStyle(color: ALUColors.white),
              ),
              trailing: Text(
                '$attendance%',
                style: const TextStyle(
                  color: ALUColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _section("Today's Academic Sessions"),
          todaySessions.isEmpty
              ? const Text(
                  'No sessions today.',
                  style: TextStyle(color: Colors.white70),
                )
              : Column(
                  children: todaySessions
                      .map(
                        (s) => Card(
                          child: ListTile(
                            title: Text(s.title),
                            subtitle: Text(
                              '${s.startTime.format(context)} - ${s.endTime.format(context)}',
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
          const SizedBox(height: 16),
          _section('Assignments Due (Next 7 Days)'),
          Text(
            '$upcomingAssignments pending',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          _section('Summary'),
          Card(
            child: ListTile(
              title: const Text('Pending Assignments'),
              trailing: Text(
                upcomingAssignments.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: ALUColors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AssignmentsPlaceholder extends StatelessWidget {
  const AssignmentsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Assignments Screen',
        style: TextStyle(color: ALUColors.white),
      ),
    );
  }
}
