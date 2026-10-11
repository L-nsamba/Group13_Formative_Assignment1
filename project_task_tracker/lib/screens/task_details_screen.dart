import 'package:flutter/material.dart';
import 'package:project_task_tracker/services/seed_data.dart';
import 'package:project_task_tracker/models/task.dart';
import 'package:intl/intl.dart';
import 'package:project_task_tracker/models/member.dart';
import 'package:project_task_tracker/screens/create_edit_task_screen.dart';
import 'package:project_task_tracker/services/storage_service.dart';
import 'package:project_task_tracker/theme/app_theme.dart';
import 'package:project_task_tracker/widgets/build_metadata_row.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

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
      orElse: () =>
          Member(id: '', name: 'Unassigned User', role: 'Team Member'),
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

  @override
  Widget build(BuildContext context) {
    final assignee = _getAssignee(_activeTask.assigneeId);
    final feedback = getStatusFeedback(_currentStatus);

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
                    _activeTask.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusBgColor(_currentStatus),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    formatStatus(_currentStatus),
                    style: TextStyle(
                      color: getStatusTextColor(_currentStatus),
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
            const SizedBox(height: 40),

            // 4. Metadata: Assigned to
            buildMetadataRow(
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
            const SizedBox(height: 40),

            // Metadata: Due Date
            buildMetadataRow(
              icon: Icons.calendar_today_outlined,
              label: 'Due Date',
              valueWidget: Text(
                DateFormat('d MMM yyyy').format(_activeTask.deadline),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textDark,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Metadata: Priority
            buildMetadataRow(
              icon: Icons.flag_outlined,
              label: 'Priority',
              valueWidget: Text(
                formatPriority(_activeTask.priority),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: getPriorityColor(_activeTask.priority),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Metadata: Status Dropdown
            buildMetadataRow(
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
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color.fromRGBO(100, 116, 139, 1),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textDark,
                    ),
                    onChanged: (TaskStatus? newStatus) async {
                      if (newStatus == null) return;

                      final updatedTask = widget.task.copyWith(
                        status: newStatus,
                      );

                      try {
                        await DatabaseHelper.instance.updateTask(updatedTask);

                        if (!mounted) return;

                        setState(() {
                          _currentStatus = newStatus;
                          _activeTask = updatedTask;
                        });
                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Could not update status: $e'),
                          ),
                        );
                      }
                    },
                    items: TaskStatus.values.map((status) {
                      return DropdownMenuItem<TaskStatus>(
                        value: status,
                        child: Text(formatStatus(status)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // 5. SLA Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: feedback.bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDCFCE7)),
              ),
              child: Column(
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
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Icon(
                        feedback.icon,
                        color: feedback.accentColor,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        feedback.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: feedback.accentColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    feedback.message,
                    style: TextStyle(fontSize: 13, color: feedback.textColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            const SizedBox(height: 40),

            // 7. Edit Task Button
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
                onPressed: () async {
                  // 1. Navigate to CreateEditTaskScreen and await the edited task
                  final updatedTask = await Navigator.push<Task>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateEditTaskScreen(task: _activeTask),
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
}
