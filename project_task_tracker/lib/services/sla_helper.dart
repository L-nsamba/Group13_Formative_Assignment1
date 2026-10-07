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