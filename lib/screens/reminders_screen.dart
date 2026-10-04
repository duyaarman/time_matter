import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_service.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  static const Color primaryBlue = Color(0xFF1727A0);

  String _dateText(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Reminders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: AnimatedBuilder(
        animation: TaskService.instance,
        builder: (context, child) {
          final scheduledTasks = TaskService.instance.tasks
              .where(
                (task) =>
                    task.dueDate != null ||
                    task.dueTime != null,
              )
              .toList();

          scheduledTasks.sort((a, b) {
            if (a.dueDate == null && b.dueDate == null) {
              return 0;
            }

            if (a.dueDate == null) {
              return 1;
            }

            if (b.dueDate == null) {
              return -1;
            }

            return a.dueDate!.compareTo(b.dueDate!);
          });

          if (scheduledTasks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 70,
                      color: colorScheme.onSurfaceVariant,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'No reminders',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Tasks with a due date or time will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${scheduledTasks.length} Scheduled Task${scheduledTasks.length == 1 ? '' : 's'}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              ...scheduledTasks.map(
                (task) => _reminderCard(
                  context,
                  task,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _reminderCard(
    BuildContext context,
    Task task,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: primaryBlue,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.isCompleted
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (task.dueDate != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 15,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _dateText(task.dueDate!),
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                  if (task.dueTime != null) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 15,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          task.dueTime!,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (task.isCompleted) ...[
                    const SizedBox(height: 7),
                    const Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}