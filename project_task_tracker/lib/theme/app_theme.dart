import 'package:flutter/material.dart';
import 'package:project_task_tracker/models/task.dart';
import 'package:project_task_tracker/services/sla_helper.dart';

class AppColors {
  // Primary Blue Colors
  static const Color primary = Colors.blue;
  static final Color primaryLight = Colors.blue.shade100;

  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Main body text (Dark)
  static const Color textSecondary = Color(
    0xFF757575,
  ); // Subtitles / Secondary text (Medium Gray)
  static const Color textMuted = Color(
    0xFF9E9E9E,
  ); // Hint text / Disabled text (Light Gray)

  // Borders & Dividers
  static const Color border = Color(0xFFE0E0E0);

  // Backgrounds
  static const Color background = Color(0xFFFFFFFF);
}

// Background TaskStatus
Color getStatusBgColor(TaskStatus status) {
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

// Text color matching Priority level
Color getPriorityColor(Priority priority) {
  switch (priority) {
    case Priority.high:
      return const Color(0xFFEF4444); // Red
    case Priority.medium:
      return const Color(0xFFF59E0B); // Amber
    case Priority.low:
      return const Color(0xFF10B981); // Emerald green
  }
}

// color for TaskStatus pill
Color getStatusTextColor(TaskStatus status) {
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

// Formating TaskStatus enum values to display in more human readable way
String formatStatus(TaskStatus status) {
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

// Formating Priority values for display
String formatPriority(Priority priority) {
  switch (priority) {
    case Priority.high:
      return 'High';
    case Priority.medium:
      return 'Medium';
    case Priority.low:
      return 'Low';
  }
}

  //A method for dynamic display of status
  StatusFeedback getStatusFeedback(TaskStatus status) {
    switch (status) {
      case TaskStatus.done:
        return const StatusFeedback(
          label: 'Completed',
          message: 'The task has been marked as finished.',
          icon: Icons.check_circle,
          bgColor: Color(0xFFF0FDF4), // Soft mint green
          borderColor: Color(0xFFDCFCE7),
          accentColor: Color(0xFF16A34A), // Forest green
          textColor: Color(0xFF166534),
        );

      case TaskStatus.inProgress:
        return const StatusFeedback(
          label: 'In Progress',
          message: 'Work is currently ongoing for this task.',
          icon: Icons.timelapse,
          bgColor: Color(0xFFEFF6FF), // Soft sky blue
          borderColor: Color(0xFFDBEAFE),
          accentColor: Color(0xFF2563EB), // Vibrant blue
          textColor: Color(0xFF1E40AF),
        );

      case TaskStatus.todo:
        return const StatusFeedback(
          label: 'To Do',
          message: 'This task is queued and ready for work.',
          icon: Icons.assignment_outlined,
          bgColor: Color(0xFFFEF3C7), // Warm amber
          borderColor: Color(0xFFFDE68A),
          accentColor: Color(0xFFD97706), // Deep amber
          textColor: Color(0xFF92400E),
        );

      case TaskStatus.notStarted:
        return const StatusFeedback(
          label: 'Not Started',
          message: 'No work has begun on this task yet.',
          icon: Icons.pause_circle_outline,
          bgColor: Color(0xFFF8FAFC), // Slate gray
          borderColor: Color(0xFFE2E8F0),
          accentColor: Color(0xFF64748B), // Muted slate
          textColor: Color(0xFF475569),
        );
    }
  }