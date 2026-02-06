import 'package:alu_student_platform/models/academic_session.dart';
import 'package:alu_student_platform/theme/alu_colors.dart';
import 'package:alu_student_platform/widgets/session_card.dart';
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

  void _showForm(BuildContext context, {AcademicSession? existing}) {
    final formKey = GlobalKey<FormState>();
    String? timeError;
    final titleController = TextEditingController(text: existing?.title ?? '');
    final locationController = TextEditingController(
      text: existing?.location ?? '',
    );
    DateTime selectedDate = existing?.date ?? DateTime.now();
    TimeOfDay start =
        existing?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay end = existing?.endTime ?? const TimeOfDay(hour: 10, minute: 30);
    String selectedType = existing?.type ?? 'Class';

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
                  existing == null ? 'Schedule Session' : 'Edit Session',
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
                      if (existing == null) {
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
                      } else {
                        final idx = newList.indexWhere(
                          (e) => e.id == existing.id,
                        );
                        newList[idx] = AcademicSession(
                          id: existing.id,
                          title: titleController.text.trim(),
                          date: selectedDate,
                          startTime: start,
                          endTime: end,
                          location: locationController.text.trim().isEmpty
                              ? null
                              : locationController.text.trim(),
                          type: selectedType,
                          isPresent: existing.isPresent,
                        );
                      }

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

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekStart = _weekStart(now);
    final weekEnd = weekStart.add(const Duration(days: 6));

    final filtered = widget.sessions.where((s) {
      if (!_showThisWeek) return true;
      return !s.date.isBefore(weekStart) && !s.date.isAfter(weekEnd);
    }).toList();
    filtered.sort((a, b) {
      final dateCompare = a.date.compareTo(b.date);
      if (dateCompare != 0) return dateCompare;

      final hourCompare = a.startTime.hour.compareTo(b.startTime.hour);
      if (hourCompare != 0) return hourCompare;

      return a.startTime.hour.compareTo(b.startTime.hour);
    });

    final items = <Widget>[];
    DateTime? currentDate;
    for (final s in filtered) {
      if (currentDate == null || !_isSameDay(currentDate, s.date)) {
        currentDate = s.date;
        items.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
            child: Text(
              DateFormat('EEEE, MMM, d').format(s.date),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }

      items.add(
        SessionCard(
          session: s,
          onEdit: () => _showForm(context, existing: s),
          onDelete: () {
            final newList = List<AcademicSession>.from(widget.sessions);
            newList.removeWhere((e) => e.id == s.id);
            widget.onUpdate(newList);
          },
          onMarkPresent: () {
            final newList = List<AcademicSession>.from(widget.sessions);
            final idx = newList.indexWhere((e) => e.id == s.id);
           if (idx >= 0) {
              newList[idx].isPresent = true;
              widget.onUpdate(newList);
            }
          },
          onMarkAbsent: () {
            final newList = List<AcademicSession>.from(widget.sessions);
            final idx = newList.indexWhere((e) => e.id == s.id);
            if (idx >= 0) {
              newList[idx].isPresent = false;
              widget.onUpdate(newList);
            }
          },
        ),
      );
    }

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
