import 'package:alu_student_platform/theme/alu_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _showThisWeek = true;

  void _showForm(BuildContext context) {}

  DateTime _weekStart(DateTime now) =>
      now.subtract(Duration(days: now.weekday - 1));

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekStart = _weekStart(now);
    final weekEnd = weekStart.add(const Duration(days: 6));


    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Schedule'),
        backgroundColor: ALUColors.navyBlue,
        foregroundColor: ALUColors.white,
        actions: [
          TextButton(
            onPressed: () => setState(() => _showThisWeek = !_showThisWeek),
            child: Text(
              _showThisWeek ? 'Show All' : 'This Week',
              style: const TextStyle(
                color: ALUColors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        backgroundColor: ALUColors.yellow,
        child: const Icon(Icons.calendar_month, color: ALUColors.navyBlue),
      ),
      bottomNavigationBar: _showThisWeek ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: ALUColors.navyBlue.withValues(alpha: 0.06),
        child: Text(
          'Week of ${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d').format(weekEnd)}'
        ),
      ) : null,
    );
  }
}
