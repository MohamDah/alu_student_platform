import 'package:alu_student_platform/screens/schedule_screen.dart';
import 'package:flutter/material.dart';
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
          secondary: ALUColors.yellow,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ALUColors.navyBlue,
          foregroundColor: ALUColors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ALUColors.yellow,
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

  // These are the 3 placeholder screens for now
  static const List<Widget> _screens = [
    Center(
      child: Text('Dashboard Screen', style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text('Assignments Screen', style: TextStyle(color: Colors.white)),
    ),
    ScheduleScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ALUColors.navyBlue,
        items: const <BottomNavigationBarItem>[
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
        selectedItemColor: ALUColors.yellow,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
