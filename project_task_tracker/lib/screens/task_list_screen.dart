import 'package:flutter/material.dart';
import 'package:project_task_tracker/services/seed_data.dart';
import 'package:project_task_tracker/models/task.dart';
import 'package:intl/intl.dart';
import 'package:project_task_tracker/models/member.dart';
import 'package:project_task_tracker/screens/task_details_screen.dart';
import 'package:project_task_tracker/services/storage_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});
  @override
  State<TaskListScreen> createState() => _TaskListScreen();
}

class _TaskListScreen extends State<TaskListScreen> {
  //I have noticed issue here, the filter section is not scrolling horizontally
  final List<String> filters = ["All", "In Progress", "To Do", "Done"];
  String selectedFilter = "All";
  //final taskList = buildSeedTasks();
  List<Task> taskList = [];
  bool isLoading = true;


  
  
  List<Task> get filteredTasks {
    // 1. If "All" is active, return the entire list
    if (selectedFilter == 'All') {
      return taskList;
    }

    // 2. Otherwise, filter items matching the selected TaskStatus
    return taskList.where((task) {
      switch (selectedFilter) {
        case 'In Progress':
          return task.status == TaskStatus.inProgress;
        case 'Not Started':
          return task.status == TaskStatus.notStarted;
        case 'To Do':
          return task.status == TaskStatus.todo;
        case 'Done':
          return task.status == TaskStatus.done;
        default:
          return true;
      }
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await DatabaseHelper.instance.getTasks();

      if (!mounted) return;

      setState(() {
        taskList = tasks;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not load tasks: $e')));
    }
  }
  @override
  void dispose() {
    // Clean up controller memory when screen is destroyed
    _searchController.dispose();
    super.dispose();
  }

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
  void _showPriorityFilterSheet() {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Takes only as much vertical height as needed
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Title and Reset button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter by Priority',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                if (selectedPriority != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedPriority = null; // Clear filter
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Color(0xFFEF4444)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Priority options
            _buildPriorityTile('All Priorities', null),
            _buildPriorityTile('High Priority', Priority.high, const Color(0xFFEF4444)),
            _buildPriorityTile('Medium Priority', Priority.medium, const Color(0xFFF59E0B)),
            _buildPriorityTile('Low Priority', Priority.low, const Color(0xFF10B981)),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
  }

Widget _buildPriorityTile(String label, Priority? priority, [Color? dotColor]) {
  final bool isSelected = selectedPriority == priority;

  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: dotColor != null
        ? Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          )
        : const SizedBox(width: 10),
    title: Text(
      label,
      style: TextStyle(
        fontSize: 15,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        color: isSelected ? const Color(0xFF1E4ED8) : const Color(0xFF0F172A),
      ),
    ),
    trailing: isSelected
        ? const Icon(Icons.check, color: Color(0xFF1E4ED8), size: 20)
        : null,
    onTap: () {
      setState(() {
        selectedPriority = priority;
      });
      Navigator.pop(context); // Dismiss the sheet
    },
  );
  }

  @override
  Widget build(BuildContext context) {
    
    const Color darkBlue = Color(0xFF1E4ED8);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // Light canvas background
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        centerTitle: true,
        
        title: const Text(
          'Tasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        // User Avatar
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),

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
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
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
                  physics: const BouncingScrollPhysics(),

                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      ...filters.map((filter) {
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
                                : Text(
                                    filter,
                                    style: TextStyle(color: Colors.black),
                                  ),
                          ),
                        );
                      }),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                filteredTasks.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48.0),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: Color(0xFF94A3B8),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No "$selectedFilter" tasks found',
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              // Inside itemBuilder:

                              final task = filteredTasks[index];
                              final member = _getMemberById(task.assigneeId);
                              final initials = _getInitials(member.name);
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
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

                                        PopupMenuButton<String>(
                                          icon: const Icon(
                                            Icons.more_vert,
                                            color: Color(0xFF64748B),
                                            size: 20,
                                          ),
                                          onSelected: (String value) async {
                                            if (value == 'edit') {
                                              // 2. Await the updated task returned when TaskDetailsScreen pops back
                                              final updatedTask =
                                                  await Navigator.push<Task>(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TaskDetailsScreen(
                                                            task: task,
                                                          ),
                                                    ),
                                                  );

                                              // 3. If a task was returned, update the list in place
                                              if (updatedTask != null) {
                                                setState(() {
                                                  // Find the exact slot where this task lives in taskList
                                                  final index = taskList
                                                      .indexWhere(
                                                        (item) =>
                                                            item.id ==
                                                            updatedTask.id,
                                                      );
                                                  if (index != -1) {
                                                    taskList[index] =
                                                        updatedTask; // Replace old task with new one
                                                  }
                                                });
                                              }
                                            } else if (value == 'delete') {
                                              try {
                                                await DatabaseHelper.instance
                                                    .deleteTask(task.id);

                                                if (!mounted) return;

                                                setState(() {
                                                  taskList.removeWhere(
                                                    (item) =>
                                                        item.id == task.id,
                                                  );
                                                });

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Task "${task.title}" deleted',
                                                    ),
                                                  ),
                                                );
                                              } catch (e) {
                                                if (!mounted) return;

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Could not delete task: $e',
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              [
                                                const PopupMenuItem<String>(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit_outlined,
                                                        size: 18,
                                                        color: Color(
                                                          0xFF1E4ED8,
                                                        ),
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
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 12,
                                              backgroundColor: const Color(
                                                0xFFE2E8F0,
                                              ),
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
                                              DateFormat('d MMM yyy')
                                                  .format(task.deadline),
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
                                            color: _getStatusBgColor(
                                              task.status,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            _formatStatus(task.status),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: _getStatusTextColor(
                                                task.status,
                                              ),
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
