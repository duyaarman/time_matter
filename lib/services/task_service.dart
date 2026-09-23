import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskService extends ChangeNotifier {
  TaskService._();

  static final TaskService instance = TaskService._();

  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  int get completedCount {
    return _tasks.where((task) => task.isCompleted).length;
  }

  int get totalCount {
    return _tasks.length;
  }

  double get progress {
    if (_tasks.isEmpty) {
      return 0;
    }

    return completedCount / totalCount;
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere(
      (task) => task.id == updatedTask.id,
    );

    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void toggleTask(Task task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.removeWhere(
      (item) => item.id == task.id,
    );

    notifyListeners();
  }
}