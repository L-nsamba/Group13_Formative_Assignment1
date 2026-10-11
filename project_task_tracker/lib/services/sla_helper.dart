import 'package:flutter/material.dart';

import '../models/task.dart';

enum SlaStatus { onTrack, atRisk, overdue, completed }

const int atRiskHours = 48;

SlaStatus getSlaStatus(Task task) {
  if (task.isCompleted) return SlaStatus.completed;

  final now = DateTime.now();
  if (task.deadline.isBefore(now)) return SlaStatus.overdue;

  final hoursLeft = task.deadline.difference(now).inHours;
  if (hoursLeft <= atRiskHours) return SlaStatus.atRisk;

  return SlaStatus.onTrack;
}

//Helper class for dynamic status display
class StatusFeedback {
  final String label;
  final String message;
  final IconData icon;
  final Color bgColor;
  final Color borderColor;
  final Color accentColor;
  final Color textColor;

  const StatusFeedback({
    required this.label,
    required this.message,
    required this.icon,
    required this.bgColor,
    required this.borderColor,
    required this.accentColor,
    required this.textColor,
  });
}