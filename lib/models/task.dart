enum TaskPriority {
  low,
  medium,
  high,
}

class Task {
  final String id;
  String title;
  String description;
  DateTime? dueDate;
  String? dueTime;
  TaskPriority priority;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.dueTime,
    this.priority = TaskPriority.medium,
    this.isCompleted = false,
  });
}