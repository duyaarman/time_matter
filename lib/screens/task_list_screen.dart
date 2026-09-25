import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../widgets/task_card.dart';
import 'add_edit_task_screen.dart';
import 'task_details_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int selectedTab = 0;
  String searchQuery = '';

  static const Color primaryBlue = Color(0xFF1727A0);
  static const Color backgroundColor = Color(0xFFF5F6FA);

  @override
  Widget build(BuildContext context) {
    final taskService = TaskService.instance;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(
                  taskService.tasks,
                ),
              );
            },
          ),
        ],
      ),

      body: AnimatedBuilder(
        animation: taskService,
        builder: (context, child) {
          final allTasks = taskService.tasks;

          final activeTasks = allTasks
              .where((task) => !task.isCompleted)
              .where(
                (task) => task.title
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()),
              )
              .toList();

          final completedTasks = allTasks
              .where((task) => task.isCompleted)
              .where(
                (task) => task.title
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()),
              )
              .toList();

          final tasks = selectedTab == 0
              ? activeTasks
              : completedTasks;

          return Column(
            children: [
              // TABS
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    _tabButton(
                      title: 'Active (${activeTasks.length})',
                      selected: selectedTab == 0,
                      onTap: () {
                        setState(() {
                          selectedTab = 0;
                        });
                      },
                    ),
                    _tabButton(
                      title: 'Completed (${completedTasks.length})',
                      selected: selectedTab == 1,
                      onTap: () {
                        setState(() {
                          selectedTab = 1;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // TASK LIST
              Expanded(
                child: tasks.isEmpty
                    ? _emptyState()
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          18,
                          16,
                          100,
                        ),
                        children: [
                          Text(
                            selectedTab == 0
                                ? 'Active Tasks'
                                : 'Completed Tasks',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          ...tasks.map(
                            (task) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10),
                              child: TaskCard(
                                task: task,

                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TaskDetailsScreen(
                                        task: task,
                                      ),
                                    ),
                                  );
                                },

                                onToggle: () {
                                  taskService.toggleTask(task);
                                },

                                onDelete: () {
                                  taskService.deleteTask(task);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),

      // ADD BUTTON
      bottomSheet: Container(
        color: backgroundColor,
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          12,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditTaskScreen(),
                ),
              );
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            icon: const Icon(Icons.add),

            label: const Text(
              'Add New Task',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected
                    ? primaryBlue
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? primaryBlue
                  : Colors.grey.shade700,
              fontWeight: selected
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selectedTab == 0
                ? Icons.task_alt
                : Icons.check_circle_outline,
            size: 65,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 15),

          Text(
            selectedTab == 0
                ? 'No active tasks.'
                : 'No completed tasks.',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            selectedTab == 0
                ? 'Tap + to create your first task.'
                : 'Completed tasks will appear here.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// SEARCH
class TaskSearchDelegate extends SearchDelegate {
  final List tasks;

  TaskSearchDelegate(this.tasks);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = tasks
        .where(
          (task) => task.title
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
        .toList();

    if (results.isEmpty) {
      return const Center(
        child: Text('No tasks found.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final task = results[index];

        return ListTile(
          leading: Icon(
            task.isCompleted
                ? Icons.check_box
                : Icons.check_box_outline_blank,
          ),
          title: Text(task.title),
          subtitle: Text(task.description),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}