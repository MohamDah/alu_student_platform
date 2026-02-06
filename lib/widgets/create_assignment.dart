import 'package:flutter/material.dart';
import '/theme/alu_colors.dart';
import '../models/assignment_model.dart';

void main() {
  runApp(CreateAssignment());
}

class CreateAssignment extends StatelessWidget {
  const CreateAssignment({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const CreateAssignmentForm(),
          );
        },
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ALUColors.yellow,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Text(
            "Create Assignment",
            style: TextStyle(
              color: ALUColors.navyBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// Form that slides up when "Create Assignment" button is clicked

class CreateAssignmentForm extends StatefulWidget {
  final Assignment? assignment;

  const CreateAssignmentForm({
    super.key,
    this.assignment,
  }); // Optional parameter for editing existing assignment

  @override
  State<CreateAssignmentForm> createState() => _CreateAssignmentFormState();
}

class _CreateAssignmentFormState extends State<CreateAssignmentForm> {
  // Controllers for a form

  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  DateTime? _selectedDate;
  String _priority = 'Medium'; // Default value
  String _assignmentType = 'Formative'; // Default value

  @override
  void initState() {
    super.initState();
    if (widget.assignment != null) {
      _titleController.text = widget.assignment!.title;
      _courseController.text = widget.assignment!.courseName;
      _selectedDate = widget.assignment!.dueDate;
      _priority = widget.assignment!.priority;
      _assignmentType = widget.assignment!.type;
    }
  }
  // function to pick a date

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ALUColors.navyBlue,
              onPrimary: Colors.white,
              onSurface: ALUColors.navyBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget to put modal above keyboard when it appears

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          // Allows scrolling on small screens
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content height
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                widget.assignment == null
                    ? "Add New Assignment"
                    : "Edit Assignment",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ALUColors.navyBlue,
                ),
              ),
              const SizedBox(height: 20),

              // Assignment title input
              _buildLabel("Assignment Title"),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: ALUColors.navyBlue),
                decoration: _inputDecoration("e.g. User Research and Design"),
              ),
              const SizedBox(height: 16),

              // // Course name input
              _buildLabel("Course Name"),
              TextField(
                controller: _courseController,
                style: const TextStyle(color: ALUColors.navyBlue),
                decoration: _inputDecoration(
                  "e.g. Mobile Application Development",
                ),
              ),
              const SizedBox(height: 16),

              // Due Date & Priority Row inputs
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Due Date"),
                        InkWell(
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: ALUColors.navyBlue,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedDate == null
                                      ? "Select Date"
                                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                  style: TextStyle(
                                    color: _selectedDate == null
                                        ? Colors.grey
                                        : ALUColors.navyBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Priority"),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _priority,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: ALUColors.navyBlue,
                              ),
                              items: ['High', 'Medium', 'Low'].map((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _priority = val!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Assignment Type (Formative or Summative) input
              _buildLabel("Assignment Type"),
              Row(
                children: [
                  _buildTypeChip("Formative"),
                  const SizedBox(width: 12),
                  _buildTypeChip("Summative"),
                ],
              ),
              const SizedBox(height: 30),

              // Cancel or Create task buttons in row format
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the modal
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ALUColors.navyBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: ALUColors.navyBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.isEmpty ||
                            _courseController.text.isEmpty ||
                            _selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all required fields"),
                            ),
                          );
                          return;
                        }

                        // Create the new assignment object
                        final newAssignment = {
                          'id': DateTime.now().toString(),
                          'title': _titleController.text,
                          'courseName': _courseController.text,
                          'dueDate': _selectedDate!.toIso8601String(),
                          'priority': _priority,
                          'type': _assignmentType,
                          'isCompleted': widget.assignment?.isCompleted ?? false,
                        };
                        Navigator.pop(context, newAssignment);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ALUColors.navyBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        widget.assignment == null ? "Create Task" : "Save Changes",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets for Styling

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: ALUColors.navyBlue,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: ALUColors.navyBlue, width: 2),
      ),
    );
  }

  // Custom switching between Formative/Summative
  Widget _buildTypeChip(String label) {
    bool isSelected = _assignmentType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _assignmentType = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? ALUColors.navyBlue : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? ALUColors.navyBlue : Colors.transparent,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

