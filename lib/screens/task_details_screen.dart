import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'add_edit_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late bool _reminderEnabled;

  Task get task => widget.task;

  @override
  void initState() {
    super.initState();
    _reminderEnabled = false;
  }

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

  Color get priorityColor {
    switch (task.priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  String get dueDateText {
    if (task.dueDate == null) {
      return 'No due date';
    }

    return '${task.dueDate!.month}/${task.dueDate!.day}/${task.dueDate!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Task title and priority
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      priorityText,
                      style: TextStyle(
                        color: priorityColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Description
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    task.description.isEmpty
                        ? 'No description'
                        : task.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: task.description.isEmpty
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Due date and time
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text('Due Date'),
                  subtitle: Text(dueDateText),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Due Time'),
                  subtitle: Text(
                    task.dueTime ?? 'No due time',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Reminder settings
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: const Text(
                'Reminder Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _reminderEnabled
                    ? 'Reminder enabled'
                    : 'Reminder disabled',
              ),
              value: _reminderEnabled,
              onChanged: (value) {
                setState(() {
                  _reminderEnabled = value;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // Edit Task
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditTaskScreen(
                      task: task,
                    ),
                  ),
                );

                setState(() {});
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Task'),
            ),
          ),

          const SizedBox(height: 10),

          // Mark as completed
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                TaskService.instance.toggleTask(task);
                setState(() {});
              },
              icon: Icon(
                task.isCompleted
                    ? Icons.undo
                    : Icons.check_circle_outline,
              ),
              label: Text(
                task.isCompleted
                    ? 'Mark as Incomplete'
                    : 'Mark as Completed',
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Delete Task
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                _showDeleteDialog(context);
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              label: const Text(
                'Delete Task',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task?'),
          content: const Text(
            'Are you sure you want to delete this task?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                TaskService.instance.deleteTask(task);

                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}