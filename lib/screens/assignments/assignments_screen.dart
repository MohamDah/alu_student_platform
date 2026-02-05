import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/theme/alu_colors.dart';
import '../../models/assignment_model.dart';
import '../../widgets/assignments_list.dart';
import 'create_assignment.dart';

void main() {
  runApp(const MaterialApp(home: AssignmentsScreen()));
}

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Assignment> _assignments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? assignmentsString = prefs.getString('assignments_data');
    if (assignmentsString != null) {
      setState(() {
        _assignments = Assignment.decode(assignmentsString);
      });
    }
  }

  Future<void> _saveAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Assignment.encode(_assignments);
    await prefs.setString('assignments_data', encodedData);
  }

  void _addOrUpdateAssignment(Map<String, dynamic> data) {
    setState(() {
      // CheckING if ID exists
      final index = _assignments.indexWhere((element) => element.id == data['id']);
      
      if (index != -1) {
        // UPDATE existing ONE
        _assignments[index] = Assignment.fromMap(data);
      } else {
        // ADD new assignment
        _assignments.add(Assignment.fromMap(data));
      }
      _saveAssignments();
    });
  }

  void _deleteAssignment(String id) {
    setState(() {
      _assignments.removeWhere((item) => item.id == id);
      _saveAssignments();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Assignment removed")));
  }

  void _toggleComplete(String id) {
    setState(() {
      final index = _assignments.indexWhere((item) => item.id == id);
      if (index != -1) {
        _assignments[index].isCompleted = !_assignments[index].isCompleted;
        _saveAssignments();
      }
    });
  }

  void _editAssignment(Assignment assignment) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateAssignmentForm(assignment: assignment), // Pass data to form
    );

    if (result != null) {
      _addOrUpdateAssignment(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ALUColors.navyBlue,
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
            ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AssignmentListView(
                  assignments: _assignments,
                  filterType: 'All',
                  onDelete: _deleteAssignment,
                  onToggleComplete: _toggleComplete,
                  onEdit: _editAssignment, // Pass the function!
                ),
                AssignmentListView(
                  assignments: _assignments,
                  filterType: 'Formative',
                  onDelete: _deleteAssignment,
                  onToggleComplete: _toggleComplete,
                  onEdit: _editAssignment,
                ),
                AssignmentListView(
                  assignments: _assignments,
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
