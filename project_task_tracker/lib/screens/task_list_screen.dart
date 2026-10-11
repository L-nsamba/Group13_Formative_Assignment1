import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_task_tracker/models/member.dart';
import 'package:project_task_tracker/models/task.dart';
import 'package:project_task_tracker/screens/task_details_screen.dart';
import 'package:project_task_tracker/services/storage_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  //I have noticed issue here, the filter section is not scrolling horizontally
  final List<String> filters = ['All', 'In Progress', 'To Do', 'Done'];
  final TextEditingController _searchController = TextEditingController();

  String selectedFilter = 'All';
  String _searchQuery = '';
  Priority? selectedPriority;

  List<Task> taskList = [];
  List<Member> _members = [];
  bool isLoading = true;

  List<Task> get filteredTasks {
    // 1. If "All" is active, return the entire list

    final query = _searchQuery.trim().toLowerCase();

    return taskList.where((task) {
      // Status filter
      final matchesStatus = switch (selectedFilter) {
        'In Progress' => task.status == TaskStatus.inProgress,
        'To Do' =>
          task.status == TaskStatus.todo ||
              task.status == TaskStatus.notStarted,
        'Done' => task.status == TaskStatus.done,
        _ => true,
      };

      // Priority filter
      final matchesPriority =
          selectedPriority == null || task.priority == selectedPriority;

      // Search by task title, description, or assignee name
      final member = _getMemberById(task.assigneeId);
      final matchesSearch =
          query.isEmpty ||
          task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query) ||
          member.name.toLowerCase().contains(query);

      return matchesStatus && matchesPriority && matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final results = await Future.wait([
        DatabaseHelper.instance.getTasks(),
        DatabaseHelper.instance.getMembers(),
      ]);

      if (!mounted) return;

      setState(() {
        taskList = results[0] as List<Task>;
        _members = results[1] as List<Member>;
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
    _searchController.dispose();
    super.dispose();
  }

  String _formatStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.notStarted:
        return 'Not Started';
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.done:
        return 'Done';
    }
  }

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

  String _getInitials(String fullName) {
    final cleaned = fullName.trim();
    if (cleaned.isEmpty) return '?';

    final words = cleaned.split(RegExp(r'\s+'));
    if (words.length == 1) return words.first[0].toUpperCase();

    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  Member _getMemberById(String assigneeId) {
    for (final member in _members) {
      if (member.id == assigneeId) return member;
    }

    return Member(id: '', name: 'Unassigned User', role: 'No Role');
  }

  Future<void> _showPriorityFilterSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        setState(() => selectedPriority = null);
                        Navigator.pop(sheetContext);
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Color(0xFFEF4444)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              _buildPriorityTile('All Priorities', null),
              _buildPriorityTile(
                'High Priority',
                Priority.high,
                const Color(0xFFEF4444),
              ),
              _buildPriorityTile(
                'Medium Priority',
                Priority.medium,
                const Color(0xFFF59E0B),
              ),
              _buildPriorityTile(
                'Low Priority',
                Priority.low,
                const Color(0xFF10B981),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriorityTile(
    String label,
    Priority? priority, [
    Color? dotColor,
  ]) {
    final isSelected = selectedPriority == priority;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: dotColor == null
          ? const SizedBox(width: 10)
          : Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
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
        setState(() => selectedPriority = priority);
        Navigator.pop(context);
      },
    );
  }

  Future<void> _openTaskDetails(Task task) async {
    final updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task)),
    );

    if (updatedTask == null || !mounted) return;

    setState(() {
      final index = taskList.indexWhere((item) => item.id == updatedTask.id);
      if (index != -1) taskList[index] = updatedTask;
    });
  }

  Future<void> _deleteTask(Task task) async {
    try {
      await DatabaseHelper.instance.deleteTask(task.id);
      if (!mounted) return;

      setState(() {
        taskList.removeWhere((item) => item.id == task.id);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task "${task.title}" deleted')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not delete task: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF1E4ED8);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tasks',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [Padding(padding: const EdgeInsets.only(right: 16))],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() => _searchQuery = value);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xFF94A3B8),
                              ),
                              hintText: 'Search tasks...',
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
                          tooltip: 'Filter by priority',
                          icon: const Icon(
                            Icons.tune,
                            color: Color(0xFF475569),
                            size: 20,
                          ),
                          onPressed: _showPriorityFilterSheet,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: filters.map((filter) {
                      final isSelected = selectedFilter == filter;
                      return GestureDetector(
                        onTap: () => setState(() => selectedFilter = filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? darkBlue : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? darkBlue
                                  : const Color(0xFFE2E8F0),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredTasks.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.inbox_outlined,
                                  size: 48,
                                  color: Color(0xFF94A3B8),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _searchQuery.isNotEmpty ||
                                          selectedPriority != null ||
                                          selectedFilter != 'All'
                                      ? 'No matching tasks found'
                                      : 'No tasks yet. Create your first task.',
                                  textAlign: TextAlign.center,
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
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
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
                                          style: const TextStyle(
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
                                        onSelected: (value) async {
                                          if (value == 'edit') {
                                            await _openTaskDetails(task);
                                          } else if (value == 'delete') {
                                            await _deleteTask(task);
                                          }
                                        },
                                        itemBuilder: (_) => const [
                                          PopupMenuItem<String>(
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
                                          PopupMenuItem<String>(
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
                                  if (task.description.isNotEmpty)
                                    Text(
                                      task.description,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  const SizedBox(height: 14),
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
                                      Expanded(
                                        child: Text(
                                          member.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        DateFormat('d MMM yyyy')
                                            .format(task.deadline),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          _formatStatus(task.status),
                                          style: TextStyle(
                                            fontSize: 12,
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
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkBlue,
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/create-edit');

          if (!mounted || result is! Task) return;

          setState(() {
            final index = taskList.indexWhere((task) => task.id == result.id);
            if (index == -1) {
              taskList.insert(0, result);
            } else {
              taskList[index] = result;
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
