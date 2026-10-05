enum Priority { low, medium, high }

enum TaskStatus { todo, inProgress, done }

// Definition of the params that Task will be able to accept
class Task { 
  final String id;
  final String title;
  final String description;
  final String assigneeId;
  final Priority priority;
  final DateTime deadline;
  final TaskStatus status;

  // Carrying out instantiation 
  Task({
    required this.id,
    required this.title,
    this.description = '', 
    required this.assigneeId,
    required this.priority,
    required this.deadline,
    this.status = TaskStatus.todo,
  });

  bool get isCompleted => status == TaskStatus.done;

  // CopyWith allows the initial pattern of Task to be replicated 
  // and allows editing specific fields without having to change all (like PATCH as used in API's)
  Task copyWith({
    String? title,
    String? description,
    String? assigneeId,
    Priority? priority,
    DateTime? deadline,
    TaskStatus? status,
  }) => Task(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    assigneeId: assigneeId ?? this.assigneeId,
    priority: priority ?? this.priority,
    deadline: deadline ?? this.deadline,
    status: status ?? this.status,
  );

  // Converting the raw Task instance into a Map for data to be saved or sent
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'assigneeId': assigneeId,
    'priority': priority.name,
    'deadline': deadline.toIso8601String(),
    'status': status.name,
  };

  // Converting the Map back to a Raw instance for data to be in a usable Dart object
  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    description: map['description'] ?? '',
    assigneeId: map['assigneeId'],
    priority: Priority.values.byName(map['priority']),
    deadline: DateTime.parse(map['deadline']),
    status: TaskStatus.values.byName(map['status']),
  );
}
