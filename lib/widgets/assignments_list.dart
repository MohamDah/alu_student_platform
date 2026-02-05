import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment_model.dart';
import '../theme/alu_colors.dart';

class AssignmentListView extends StatelessWidget {
  final List<Assignment> assignments;
  final String
  filterType; // 'All', 'Formative assignments', 'Summative assignments'
  final Function(String id) onDelete;
  final Function(String id) onToggleComplete;
  final Function(Assignment assignment) onEdit;
  const AssignmentListView({
    super.key,
    required this.assignments,
    required this.filterType,
    required this.onDelete,
    required this.onToggleComplete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // FILTER the list based on the tab
    List<Assignment> filteredList = filterType == 'All'
        ? assignments
        : assignments.where((a) => a.type == filterType).toList();

    // SORT by due date
    filteredList.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    // EMPTY STATE
    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "No assignments found",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Displaying in list view
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 80),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _getPriorityColor(item.priority),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: item.isCompleted ? Colors.grey : ALUColors.navyBlue,
                  decoration: item.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              subtitle: Text(
                "Due: ${DateFormat('MMM dd, yyyy').format(item.dueDate)}",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              trailing: _buildPriorityBadge(item.priority),

              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      _detailRow("Course:", item.courseName),
                      const SizedBox(height: 8),
                      _detailRow("Type:", item.type),
                      const SizedBox(height: 20),

                      // Action buttons

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Delete
                          TextButton.icon(
                            onPressed: () => onDelete(item.id),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: ALUColors.redRisk,
                              size: 20,
                            ),
                            label: const Text(
                              "Remove",
                              style: TextStyle(color: ALUColors.redRisk),
                            ),
                          ),
                          const Spacer(),
                          // Edit
                          TextButton.icon(
                            onPressed: () => onEdit(item),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 20,
                            ),
                            label: const Text(
                              "Edit",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // COMPLETE
                          ElevatedButton.icon(
                            onPressed: () => onToggleComplete(item.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: item.isCompleted
                                  ? Colors.grey
                                  : ALUColors.navyBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            icon: Icon(
                              item.isCompleted ? Icons.undo : Icons.check,
                              size: 18,
                            ),
                            label: Text(item.isCompleted ? "Undo" : "Complete"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper for Priority Colors
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return ALUColors.redRisk;
      case 'Medium':
        return ALUColors.yellow;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Helper for Priority Badge
  Widget _buildPriorityBadge(String priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPriorityColor(priority).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: _getPriorityColor(priority) == ALUColors.yellow
              ? Colors.orange[800]
              : _getPriorityColor(priority),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: ALUColors.navyBlue,
          ),
        ),
        Text(value, style: const TextStyle(color: Colors.black87)),
      ],
    );
  }
}

