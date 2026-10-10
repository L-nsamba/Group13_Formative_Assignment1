import 'package:flutter/material.dart';
import 'package:project_task_tracker/services/seed_data.dart';
import 'package:project_task_tracker/models/task.dart';
import 'package:intl/intl.dart';
import 'package:project_task_tracker/models/member.dart';
import 'package:project_task_tracker/screens/task_details_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});
  @override
  State<TaskListScreen> createState() => _TaskListScreen();
}

class _TaskListScreen extends State<TaskListScreen> {
  final List<String> filters = ["All", "On Track", "At Risk", "Overdue"];
  String selectedFilter = "All";
  final taskList = buildSeedTasks();

  String _formatStatus(TaskStatus s) {
    final spaced = s.name.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    );
    return spaced[0].toUpperCase() + spaced.substring(1);
  }

  //Color for status
  Color _getStatusBgColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.done:
        return const Color(0xFFDCFCE7); // Soft light green
      case TaskStatus.inProgress:
        return const Color(0xFFE0E7FF); // Soft light blue / indigo
      case TaskStatus.todo:
        return const Color(0xFFFEF3C7); // Soft amber / yellow
      case TaskStatus.notStarted:
        return const Color(0xFFF1F5F9); // Soft neutral slate gray
    }
  }

  //This method is for text inside the status when background changes
  Color _getStatusTextColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.done:
        return const Color(0xFF15803D); // Deep green
      case TaskStatus.inProgress:
        return const Color(0xFF4338CA); // Deep indigo
      case TaskStatus.todo:
        return const Color(0xFFB45309); // Dark amber
      case TaskStatus.notStarted:
        return const Color(0xFF475569); // Dark slate gray
    }
  }

  String _getInitials(String fullName) {
    final cleaned = fullName.trim();
    if (cleaned.isEmpty) return '?';
    final words = cleaned.split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    final firstInitial = words[0][0];
    final secondInitial = words[1][0];

    return '$firstInitial$secondInitial'.toUpperCase();
  }

  Member _getMemberById(String assigneeId) {
    return seedMembers.firstWhere(
      (member) => member.id == assigneeId,
      // Fallback in case an invalid or missing ID is passed
      orElse: () => Member(id: '', name: 'Unassigned User', role: 'No Role'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Primary dark blue matching your palette
    const Color darkBlue = Color(0xFF1E4ED8);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Light canvas background
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        centerTitle: true,
        // I think it is okay if we remove menu icon, I don't see its importance
        /*leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // Can open a drawer or show navigation
            },
          )*/
        title: const Text(
          'Tasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        // 3. User Avatar
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF3B82F6),
              child: Text(
                _getInitials(seedMembers.first.name),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Lighter blue accent
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF94A3B8),
                        ),
                        hintText: "Search tasks....",
                        hintStyle: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.tune,
                      color: Color(0xFF475569),
                      size: 20,
                    ),
                    onPressed: () => {},
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: filters.map((filter) {
                final bool isSelected = selectedFilter == filter;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1E4ED8)
                          : Colors.white,
                      border: isSelected
                          ? Border.all(color: Color(0xFF1E4ED8))
                          : Border.all(color: Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: isSelected
                        ? Text(
                            filter,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          )
                        : Text(filter, style: TextStyle(color: Colors.black)),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                // Inside itemBuilder:

                final task = taskList[index];
                final member = _getMemberById(task.assigneeId);
                final initials = _getInitials(member.name);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          //Icon(Icons.more_vert, size: 20, color: Color(0xFF64748B),),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Color(0xFF64748B),
                              size: 20,
                            ),
                            onSelected: (String value) {
                              if (value == 'edit') {
                                // Navigate to TaskDetailsScreen, passing this specific task
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TaskDetailsScreen(task: task),
                                  ),
                                );
                              } else if (value == 'delete') {
                                // Remove task from list and refresh the screen
                                setState(() {
                                  taskList.removeWhere(
                                    (item) => item.id == task.id,
                                  );
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Task "${task.title}" deleted',
                                    ),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                      color: Color(0xFF1E4ED8),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Edit / Details'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: const Color(0xFFE2E8F0),
                                child: Text(
                                  initials,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),
                              Text(
                                DateFormat('d MMM yyy').format(task.deadline),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusBgColor(task.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _formatStatus(task.status),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _getStatusTextColor(task.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating Action Button for task creation
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkBlue,
        onPressed: () async {
          final newTask = await Navigator.pushNamed(context, '/create-edit');

          if (newTask != null && newTask is Task) {
            setState(() {
              taskList.insert(0, newTask);
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
