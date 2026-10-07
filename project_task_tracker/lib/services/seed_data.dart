import 'package:project_task_tracker/models/member.dart';
import 'package:project_task_tracker/models/task.dart';

final List<Member> seedMembers = [
  Member(id: 'm1', name: 'Jean Bosco Mugabo', role: 'Project Manager'),
  Member(id: 'm2', name: 'Aline Uwase', role: 'UI/UX Designer'),
  Member(id: 'm3', name: 'Patrick Niyigena', role: 'Mobile Developer'),
  Member(id: 'm4', name: 'Diane Umutesi', role: 'QA Tester'),
  Member(id: 'm5', name: 'Eric Habimana', role: 'Documentation'),
];

List<Task> buildSeedTasks() {
  final now = DateTime.now();

  return [
    Task(
      id: 't1',
      title: 'Create task model',
      description: 'Define the Task class with all required fields.',
      assigneeId: 'm3',
      priority: Priority.high,
      deadline: now.subtract(const Duration(days: 2)),
      status: TaskStatus.inProgress,
    ),
    Task(
      id: 't2',
      title: 'Design login and signup screens',
      description: 'Create high-fidelity mockups for the user authentication flows.',
      assigneeId: 'm2',
      priority: Priority.high,
      deadline: now.add(const Duration(days: 5)),
      status: TaskStatus.notStarted,
    ),
    Task(
      id: 't3',
      title: 'Setup project repository',
      description: 'Initialize the git repository, add .gitignore, and configure branch protection rules.',
      assigneeId: 'm1',
      priority: Priority.medium,
      deadline: now.add(const Duration(days: 1)),
      status: TaskStatus.inProgress,
    ),
    Task(
      id: 't4',
      title: 'Implement UI for member list',
      description: 'Code the screen to display all project members with their roles.',
      assigneeId: 'm3',
      priority: Priority.medium,
      deadline: now.add(const Duration(days: 3)),
      status: TaskStatus.todo,
    ),
    Task(
      id: 't5',
      title: 'Create test plan documentation',
      description: 'Draft a comprehensive test plan covering core features.',
      assigneeId: 'm4',
      priority: Priority.low,
      deadline: now.subtract(const Duration(days: 7)),
      status: TaskStatus.done,
    ),
    Task(
      id: 't6',
      title: 'Integrate API for task assignment',
      description: 'Connect the frontend to the backend for assigning tasks to members.',
      assigneeId: 'm3',
      priority: Priority.high,
      deadline: now.add(const Duration(days: 1)),
      status: TaskStatus.done,
    ),
    Task(
      id: 't7',
      title: 'Write user onboarding guide',
      description: 'Create a guide for new users explaining how to use the application.',
      assigneeId: 'm5',
      priority: Priority.low,
      deadline: now.add(const Duration(days: 14)),
      status: TaskStatus.notStarted,
    ),
    Task(
      id: 't8',
      title: 'Set up CI/CD pipeline',
      description: 'Configure GitHub Actions for automated testing and deployment.',
      assigneeId: 'm1',
      priority: Priority.medium,
      deadline: now.subtract(const Duration(days: 1)),
      status: TaskStatus.done,
    ),
  ];
}