import 'package:flutter/material.dart';
import 'package:project_task_tracker/services/seed_data.dart';
import 'package:project_task_tracker/models/task.dart';
import 'package:intl/intl.dart';
import 'package:project_task_tracker/models/member.dart';
import 'package:project_task_tracker/screens/create_edit_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  

  const TaskDetailsScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TaskStatus _currentStatus;
  late Task _activeTask;
  final TextEditingController _notesController = TextEditingController();

  // App palette colors
  static const Color brandBlue = Color(0xFF1E4ED8);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  void initState() {
    super.initState();
    _activeTask = widget.task;
    _currentStatus = widget.task.status;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // Member object from seed data, accessed using assignedId
  Member _getAssignee(String assigneeId) {
    return seedMembers.firstWhere(
      (member) => member.id == assigneeId,
      orElse: () => Member(
        id: '',
        name: 'Unassigned User',
        role: 'Team Member',
      ),
    );
  }

  // uppercase initials for circle avatars
  String _getInitials(String fullName) {
    final cleaned = fullName.trim();
    if (cleaned.isEmpty) return '?';
    final parts = cleaned.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  // Formating TaskStatus enum values to display in more human readable way
  String _formatStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.done:
        return 'Done';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.notStarted:
        return 'Not Started';
    }
  }

  // Background TaskStatus 
  Color _getStatusBgColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.done:
        return const Color(0xFFDCFCE7); 
      case TaskStatus.inProgress:
        return const Color(0xFFE0E7FF);
      case TaskStatus.todo:
        return const Color(0xFFFEF3C7); 
      case TaskStatus.notStarted:
        return const Color(0xFFF1F5F9); 
    }
  }

  // color for TaskStatus pill
  Color _getStatusTextColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.done:
        return const Color(0xFF15803D); 
      case TaskStatus.inProgress:
        return const Color(0xFF4338CA); 
      case TaskStatus.todo:
        return const Color(0xFFB45309); 
      case TaskStatus.notStarted:
        return const Color(0xFF475569); 
    }
  }

  // Formating Priority values for display
  String _formatPriority(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  // Text color matching Priority level
  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return const Color(0xFFEF4444); // Red
      case Priority.medium:
        return const Color(0xFFF59E0B); // Amber
      case Priority.low:
        return const Color(0xFF10B981); // Emerald green
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignee = _getAssignee(_activeTask.assigneeId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textDark, size: 18),
          onPressed: () => Navigator.pop(context, _activeTask),
        ),
        title: const Text(
          'Task Details',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header: Title  and  Dynamic Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.task.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(_currentStatus),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatStatus(_currentStatus),
                    style: TextStyle(
                      color: _getStatusTextColor(_currentStatus),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // 2. Category / Subtitle
            Text(
              assignee.role,
              style: const TextStyle(
                color: textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            // 3. Task Description
            Text(
              _activeTask.description,
              style: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // 4. Metadata: Assigned to
            _buildMetadataRow(
              icon: Icons.people_outline,
              label: 'Assigned to',
              valueWidget: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFFE2E8F0),
                    child: Text(
                      _getInitials(assignee.name),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    assignee.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Metadata: Due Date
            _buildMetadataRow(
              icon: Icons.calendar_today_outlined,
              label: 'Due Date',
              valueWidget: Text(
                DateFormat('d MMM yyyy').format(widget.task.deadline),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textDark,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Metadata: Priority
            _buildMetadataRow(
              icon: Icons.flag_outlined,
              label: 'Priority',
              valueWidget: Text(
                _formatPriority(_activeTask.priority),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getPriorityColor(_activeTask.priority),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Metadata: Status Dropdown
            _buildMetadataRow(
              icon: Icons.format_list_bulleted,
              label: 'Status',
              valueWidget: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TaskStatus>(
                    value: _currentStatus,
                    icon: const Icon(Icons.keyboard_arrow_down, color: textMuted),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textDark,
                    ),
                    onChanged: (TaskStatus? newStatus) {
                      if (newStatus != null) {
                        setState(() {
                          _currentStatus = newStatus;
                        });
                      }
                    },
                    items: TaskStatus.values.map((status) {
                      return DropdownMenuItem<TaskStatus>(
                        value: status,
                        child: Text(_formatStatus(status)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 5. SLA Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDCFCE7)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'On Track',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'The task is progressing well.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF166534),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 6. Notes Input Field
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add any additional notes...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: borderColor),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // 7. Edit Task Button (Visual presentation for now)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: () async{
                  // 1. Navigate to CreateEditTaskScreen and await the edited task
                    final updatedTask = await Navigator.push<Task>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateEditTaskScreen(task: _activeTask),
                      ),
                    );

                    // 2. If the user saved changes (did not cancel), refresh this screen
                    if (updatedTask != null) {
                      setState(() {
                        _activeTask = updatedTask;
                        _currentStatus = updatedTask.status;
                      });
                    }
                  
                },
                child: const Text(
                  'Edit Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Helper method for aligned metadata rows
  Widget _buildMetadataRow({
    required IconData icon,
    required String label,
    required Widget valueWidget,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: textMuted),
        const SizedBox(width: 12),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: textMuted,
            ),
          ),
        ),
        Expanded(child: valueWidget),
      ],
    );
  }
}