import 'package:alu_student_platform/models/academic_session.dart';
import 'package:alu_student_platform/theme/alu_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionCard extends StatelessWidget {
  final AcademicSession session;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMarkPresent;
  final VoidCallback onMarkAbsent;

  const SessionCard({
    super.key,
    required this.session,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkPresent,
    required this.onMarkAbsent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.event, color: ALUColors.navyBlue),
            title: Text(
              session.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${DateFormat('MMM d').format(session.date)} / ${session.startTime.format(context)} - ${session.endTime.format(context)} / ${session.type}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: ALUColors.redRisk,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Status: ',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                if (session.isPresent == null)
                  const Text(
                    'Unrecorded',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  )
                else if (session.isPresent!)
                  const Text(
                    'Present',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  )
                else
                  const Text(
                    'Absent',
                    style: TextStyle(
                      color: ALUColors.redRisk,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onMarkPresent,
                  icon: const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green,
                  ),
                  label: const Text(
                    'Present',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
                TextButton.icon(
                  onPressed: onMarkAbsent,
                  icon: const Icon(
                    Icons.cancel,
                    size: 16,
                    color: ALUColors.redRisk,
                  ),
                  label: const Text(
                    'Absent',
                    style: TextStyle(color: ALUColors.redRisk, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
