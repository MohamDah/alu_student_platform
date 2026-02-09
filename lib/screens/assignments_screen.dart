import 'package:flutter/material.dart';
import '/theme/alu_colors.dart';
import '../models/assignment_model.dart';
import '../widgets/assignments_list.dart';
import '../widgets/create_assignment.dart';

class AssignmentsScreen extends StatefulWidget {
  final List<Assignment> assignments;
  final Function(List<Assignment>) onUpdate;

  const AssignmentsScreen({
    super.key,
    required this.assignments,
    required this.onUpdate,
  });

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addOrUpdateAssignment(Map<String, dynamic> data) {
    final newList = List<Assignment>.from(widget.assignments);
    // Checking if ID exists
    final index = newList.indexWhere((element) => element.id == data['id']);

    if (index != -1) {
      // UPDATE existing ONE
      newList[index] = Assignment.fromJson(data);
    } else {
      // ADD new assignment
      newList.add(Assignment.fromJson(data));
    }

    widget.onUpdate(newList);
  }

  void _deleteAssignment(String id) {
    final newList = List<Assignment>.from(widget.assignments);
    newList.removeWhere((item) => item.id == id);

    widget.onUpdate(newList);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Assignment removed")));
  }

  void _toggleComplete(String id) {
    final newList = List<Assignment>.from(widget.assignments);
    final index = newList.indexWhere((item) => item.id == id);
    if (index != -1) {
      newList[index].isCompleted = !newList[index].isCompleted;
    }
    widget.onUpdate(newList);
  }

  void _editAssignment(Assignment assignment) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CreateAssignmentForm(assignment: assignment), // Pass data to form
    );

    if (result != null) {
      _addOrUpdateAssignment(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: ALUColors.navyBlue,
        foregroundColor: ALUColors.white,
      ),
      backgroundColor: ALUColors.white,
      body: Column(
        children: [
          Container(
            color: ALUColors.navyBlue,
            child: TabBar(
              controller: _tabController,
              indicatorColor: ALUColors.redRisk,
              labelColor: ALUColors.white,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Formative'),
                Tab(text: 'Summative'),
              ],
            ),
          ),

          if (_tabController.index == 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () async {
                  final result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const CreateAssignmentForm(),
                  );
                  if (result != null) {
                    _addOrUpdateAssignment(result);
                  }
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ALUColors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Create Assignment",
                    style: TextStyle(
                      color: ALUColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AssignmentListView(
                  assignments: widget.assignments,
                  filterType: 'All',
                  onDelete: _deleteAssignment,
                  onToggleComplete: _toggleComplete,
                  onEdit: _editAssignment, // Pass the function!
                ),
                AssignmentListView(
                  assignments: widget.assignments,
                  filterType: 'Formative',
                  onDelete: _deleteAssignment,
                  onToggleComplete: _toggleComplete,
                  onEdit: _editAssignment,
                ),
                AssignmentListView(
                  assignments: widget.assignments,
                  filterType: 'Summative',
                  onDelete: _deleteAssignment,
                  onToggleComplete: _toggleComplete,
                  onEdit: _editAssignment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
