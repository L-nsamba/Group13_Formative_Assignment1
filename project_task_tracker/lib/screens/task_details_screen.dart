import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetailsScreen extends StatefulWidget {
  // 1. The task received from TaskListScreen
  final Task task;

  const TaskDetailsScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  // 2. Track the active status locally so the dropdown can change it
  late TaskStatus _currentStatus;
  
  // 3. Controller for the Notes input field
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Local task status
    _currentStatus = widget.task.status;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Task Details',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF0F172A)),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('Task Details Content Coming Next...'),
      ),
    );
  }
}