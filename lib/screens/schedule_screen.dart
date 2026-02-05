import 'package:alu_student_platform/models/academic_session.dart';
import 'package:alu_student_platform/theme/alu_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  final List<AcademicSession> sessions;
  final Function(List<AcademicSession>) onUpdate;

  const ScheduleScreen({
    super.key,
    required this.sessions,
    required this.onUpdate,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _showThisWeek = true;

  bool isValidTimeRange(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return endMinutes > startMinutes;
  }

  void _showForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? timeError;
    final titleController = TextEditingController(text: '');
    final locationController = TextEditingController(text: '');
    DateTime selectedDate = DateTime.now();
    TimeOfDay start = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay end = const TimeOfDay(hour: 10, minute: 30);
    String selectedType = 'Class';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Schedule Session',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Session title input
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Session Title *',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Session title is required.';
                    }
                    return null;
                  },
                ),
                // Location input
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                // Type input
                DropdownButton(
                  isExpanded: true,
                  value: selectedType,
                  items:
                      ['Class', 'Mastery Session', 'Study Group', 'PSL Meeting']
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                  onChanged: (v) =>
                      setModalState(() => selectedType = v ?? 'Class'),
                ),
                // Date input
                Row(
                  children: [
                    const Text('Date: '),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: selectedDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setModalState(() => selectedDate = picked);
                        }
                      },
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                      ),
                    ),
                  ],
                ),
                // Start time input
                Row(
                  children: [
                    const Text('Start: '),
                    TextButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: ctx,
                          initialTime: start,
                        );
                        if (picked != null) {
                          setModalState(() {
                            start = picked;
                            timeError = !isValidTimeRange(start, end)
                                ? 'End time must be after start time.'
                                : null;
                          });
                        }
                      },
                      child: Text(start.format(ctx)),
                    ),
                    const Spacer(),
                    const Text('End: '),
                    TextButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: ctx,
                          initialTime: end,
                        );
                        if (picked != null) {
                          setModalState(() {
                            end = picked;
                            timeError = !isValidTimeRange(start, end)
                                ? 'End time must be after start time.'
                                : null;
                          });
                        }
                      },
                      child: Text(end.format(ctx)),
                    ),
                  ],
                ),
                if (timeError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        timeError!,
                        style: const TextStyle(
                          color: ALUColors.redRisk,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ALUColors.navyBlue,
                      foregroundColor: ALUColors.white,
                    ),
                    onPressed: () {
                      if (!(formKey.currentState?.validate() ?? false)) {
                        return;
                      }

                      if (!isValidTimeRange(start, end)) {
                        return;
                      }

                      final newList = List<AcademicSession>.from(
                        widget.sessions,
                      );

                      newList.add(
                        AcademicSession(
                          id: DateTime.now().toString(),
                          title: titleController.text.trim(),
                          date: selectedDate,
                          startTime: start,
                          endTime: end,
                          location: locationController.text.trim().isEmpty
                              ? null
                              : locationController.text.trim(),
                          type: selectedType,
                        ),
                      );

                      widget.onUpdate(newList);
                      Navigator.pop(ctx);
                    },
                    child: const Text('Confirm Schedule'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime _weekStart(DateTime now) =>
      now.subtract(Duration(days: now.weekday - 1));

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekStart = _weekStart(now);
    final weekEnd = weekStart.add(const Duration(days: 6));

    List<Widget> items = widget.sessions
        .map((e) => Text(e.toString()))
        .toList();

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
      body: widget.sessions.isEmpty
          ? const Center(child: Text('Your schedule is empty.'))
          : ListView(children: items),
      bottomNavigationBar: _showThisWeek
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: ALUColors.navyBlue.withValues(alpha: 0.06),
              child: Text(
                'Week of ${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d').format(weekEnd)}',
              ),
            )
          : null,
    );
  }
}
