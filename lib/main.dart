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
        scaffoldBackgroundColor: ALUColors.navyBlue,
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: ALUColors.white),
          bodyLarge: TextStyle(color: ALUColors.white),
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
    Center(child: Text('Dashboard Screen', style: TextStyle(color: Colors.white))),
    Center(child: Text('Assignments Screen', style: TextStyle(color: Colors.white))),
    Center(child: Text('Schedule Screen', style: TextStyle(color: Colors.white))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALU Student Platform', style: TextStyle(color: Colors.white)),
        backgroundColor: ALUColors.navyBlue,
      ),
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