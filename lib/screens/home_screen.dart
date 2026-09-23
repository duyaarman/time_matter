import 'package:flutter/material.dart';
import '../services/task_service.dart';
import 'task_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskService = TaskService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Matter'),
      ),
      body: AnimatedBuilder(
        animation: taskService,
        builder: (context, child) {
          final total = taskService.totalCount;
          final completed = taskService.completedCount;
          final progress = taskService.progress;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Stay organized and keep track of your tasks.',
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 24),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Today's Progress",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                        ),

                        const SizedBox(height: 12),

                        Text(
                          '$completed of $total tasks completed',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TaskListScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.list),
                    label: const Text('View My Tasks'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}