import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class TaskService extends ChangeNotifier {
  TaskService._();

  static final TaskService instance = TaskService._();

  static const String _tasksKey = 'tasks';

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

  Future<void> loadTasks() async {
    final preferences = await SharedPreferences.getInstance();

    final savedTasks = preferences.getString(_tasksKey);

    if (savedTasks == null) {
      return;
    }

    final List<dynamic> decodedTasks = jsonDecode(savedTasks);

    _tasks.clear();

    for (final item in decodedTasks) {
      final data = Map<String, dynamic>.from(item);

      _tasks.add(
        Task(
          id: data['id'],
          title: data['title'],
          description: data['description'] ?? '',
          dueDate: data['dueDate'] != null
              ? DateTime.parse(data['dueDate'])
              : null,
          dueTime: data['dueTime'],
          priority: TaskPriority.values.firstWhere(
            (priority) => priority.name == data['priority'],
            orElse: () => TaskPriority.medium,
          ),
          isCompleted: data['isCompleted'] ?? false,
        ),
      );
    }

    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final preferences = await SharedPreferences.getInstance();

    final encodedTasks = jsonEncode(
      _tasks.map((task) {
        return {
          'id': task.id,
          'title': task.title,
          'description': task.description,
          'dueDate': task.dueDate?.toIso8601String(),
          'dueTime': task.dueTime,
          'priority': task.priority.name,
          'isCompleted': task.isCompleted,
        };
      }).toList(),
    );

    await preferences.setString(_tasksKey, encodedTasks);
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);

    await _saveTasks();

    notifyListeners();
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere(
      (task) => task.id == updatedTask.id,
    );

    if (index != -1) {
      _tasks[index] = updatedTask;

      await _saveTasks();

      notifyListeners();
    }
  }

  Future<void> toggleTask(Task task) async {
    task.isCompleted = !task.isCompleted;

    await _saveTasks();

    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    _tasks.removeWhere(
      (item) => item.id == task.id,
    );

    await _saveTasks();

    notifyListeners();
  }
}