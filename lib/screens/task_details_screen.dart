import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'add_edit_task_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({
    super.key,
    required this.task,
  });

  String get priorityText {
    switch (task.priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditTaskScreen(
                    task: task,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          if (task.description.isNotEmpty) ...[
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
          ],

          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Priority'),
            subtitle: Text(priorityText),
          ),

          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Due Date'),
            subtitle: Text(
              task.dueDate == null
                  ? 'No due date'
                  : '${task.dueDate!.month}/${task.dueDate!.day}/${task.dueDate!.year}',
            ),
          ),

          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Due Time'),
            subtitle: Text(
              task.dueTime ?? 'No due time',
            ),
          ),

          const SizedBox(height: 20),

          SwitchListTile(
            title: const Text('Completed'),
            value: task.isCompleted,
            onChanged: (_) {
              TaskService.instance.toggleTask(task);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}