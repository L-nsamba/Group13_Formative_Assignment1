import 'package:flutter/material.dart';
import 'package:project_task_tracker/models/task.dart';
import 'package:project_task_tracker/services/storage_service.dart';
import 'package:project_task_tracker/theme/app_theme.dart';
import 'package:project_task_tracker/widgets/section_card.dart';
import 'package:project_task_tracker/widgets/stat_card.dart';
import 'package:project_task_tracker/widgets/status_row.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final tasks = await DatabaseHelper.instance.getTasks();

      if (!mounted) return;

      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Could not load task statistics.';
        _isLoading = false;
      });

      debugPrint('Dashboard load error: $e');
    }
  }

  int get _totalTasks => _tasks.length;

  int get _completedTasks =>
      _tasks.where((task) => task.status == TaskStatus.done).length;

  int get _inProgressTasks =>
      _tasks.where((task) => task.status == TaskStatus.inProgress).length;

  int get _todoTasks => _tasks
      .where(
        (task) =>
            task.status == TaskStatus.todo ||
            task.status == TaskStatus.notStarted,
      )
      .length;

  int get _overdueTasks {
    final now = DateTime.now();

    return _tasks.where((task) {
      return task.status != TaskStatus.done && task.deadline.isBefore(now);
    }).length;
  }

  double get _completionRate =>
      _totalTasks == 0 ? 0 : _completedTasks / _totalTasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E4ED8),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Task Overview',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh dashboard',
            onPressed: _loadTasks,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _loadTasks,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadTasks,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Your team at a glance',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Summary statistic cards
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.35,
                    children: [
                      StatCard(
                        title: 'Total Tasks',
                        value: '$_totalTasks',
                        icon: Icons.assignment_outlined,
                        color: const Color(0xFF2563EB),
                        background: const Color(0xFFEAF2FF),
                      ),
                      StatCard(
                        title: 'Completed',
                        value: '$_completedTasks',
                        icon: Icons.check_circle_outline,
                        color: const Color(0xFF16804A),
                        background: const Color(0xFFE4F7EC),
                      ),
                      StatCard(
                        title: 'In Progress',
                        value: '$_inProgressTasks',
                        icon: Icons.pending_actions,
                        color: const Color(0xFF9A5B00),
                        background: const Color(0xFFFFF2D9),
                      ),
                      StatCard(
                        title: 'Overdue',
                        value: '$_overdueTasks',
                        icon: Icons.calendar_today_outlined,
                        color: const Color(0xFFB42318),
                        background: const Color(0xFFFCE8E8),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Overall completion
                  SectionCard(
                    title: 'Overall completion',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Completed tasks',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${(_completionRate * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _completionRate,
                            minHeight: 10,
                            backgroundColor: AppColors.border,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF1E4ED8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_completedTasks of $_totalTasks tasks completed',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Task status breakdown
                  SectionCard(
                    title: 'Task status',
                    child: Column(
                      children: [
                        StatusRow(
                          label: 'To Do',
                          count: _todoTasks,
                          total: _totalTasks,
                          color: const Color(0xFF64748B),
                        ),
                        const SizedBox(height: 18),
                        StatusRow(
                          label: 'In Progress',
                          count: _inProgressTasks,
                          total: _totalTasks,
                          color: const Color(0xFF2563EB),
                        ),
                        const SizedBox(height: 18),
                        StatusRow(
                          label: 'Done',
                          count: _completedTasks,
                          total: _totalTasks,
                          color: const Color(0xFF16804A),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
