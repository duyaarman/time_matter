import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/reminder_service.dart';
import '../services/task_service.dart';
import '../services/user_name_service.dart';
import '../widgets/home_bottom_nav.dart';
import 'add_edit_task_screen.dart';
import 'reminders_screen.dart';
import 'settings_screen.dart';
import 'task_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color primaryBlue = Color(0xFF1727A0);

  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final savedName = await UserNameService.getName();

    if (savedName == null || savedName.trim().isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNameDialog();
      });
    } else if (mounted) {
      setState(() {
        _userName = savedName;
      });
    }
  }

  Future<void> _showNameDialog() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Welcome to Time Matter!'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Your name',
              hintText: 'Enter your name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();

                if (name.isEmpty) {
                  return;
                }

                await UserNameService.saveName(name);

                if (mounted) {
                  setState(() {
                    _userName = name;
                  });
                }

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _todayDate() {
    final now = DateTime.now();

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  bool _isToday(DateTime? date) {
    if (date == null) {
      return false;
    }

    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final taskService = TaskService.instance;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // LEFT MENU
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 25),

              const Icon(
                Icons.access_time_filled,
                color: primaryBlue,
                size: 50,
              ),

              const SizedBox(height: 10),

              const Text(
                'Time Matter',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),

              const SizedBox(height: 30),

              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.checklist),
                title: const Text('My Tasks'),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TaskListScreen(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // TOP BAR
      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Time Matter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          AnimatedBuilder(
            animation: Listenable.merge([
              taskService,
              ReminderService.instance,
            ]),
            builder: (context, child) {
              final hasReminders =
                  ReminderService.instance.isEnabled &&
                  taskService.tasks.any(
                    (task) =>
                        task.dueDate != null ||
                        task.dueTime != null,
                  );

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RemindersScreen(),
                        ),
                      );
                    },
                  ),

                  if (hasReminders)
                    Positioned(
                      right: 10,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      // BODY
      body: AnimatedBuilder(
        animation: taskService,
        builder: (context, child) {
          final allTasks = taskService.tasks;

          final todayTasks = allTasks
              .where((task) => _isToday(task.dueDate))
              .toList();

          final completedToday = todayTasks
              .where((task) => task.isCompleted)
              .length;

          final todayProgress = todayTasks.isEmpty
              ? 0.0
              : completedToday / todayTasks.length;

          final upcomingTasks = allTasks
              .where(
                (task) =>
                    task.dueDate != null &&
                    task.dueDate!.isAfter(DateTime.now()) &&
                    !task.isCompleted,
              )
              .toList()
            ..sort(
              (a, b) => a.dueDate!.compareTo(b.dueDate!),
            );

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              16,
              18,
              16,
              20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GREETING
                Text(
                  _userName.isEmpty
                      ? '${_greeting()}!'
                      : '${_greeting()}, $_userName!',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  _todayDate(),
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 22),

                // TODAY'S TASKS CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Today's Tasks",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${todayTasks.length} Tasks',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (todayTasks.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                          child: Text(
                            'No tasks for today.',
                            style: TextStyle(
                              color:
                                  colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      else
                        ...todayTasks.take(3).map(
                          (task) => _todayTaskItem(
                            context,
                            task,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // UPCOMING DEADLINES
                _sectionHeader(
                  context,
                  'Upcoming Deadlines',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const TaskListScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                if (upcomingTasks.isEmpty)
                  _emptyCard(
                    context,
                    Icons.calendar_today_outlined,
                    'No upcoming deadlines.',
                  )
                else
                  ...upcomingTasks.take(3).map(
                    (task) => _deadlineCard(
                      context,
                      task,
                    ),
                  ),

                const SizedBox(height: 18),

                // TODAY'S PROGRESS
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Today's Progress",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            '${(todayProgress * 100).round()}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child:
                                      CircularProgressIndicator(
                                    value: todayProgress,
                                    strokeWidth: 7,
                                    backgroundColor:
                                        colorScheme
                                            .surfaceContainerHighest,
                                    color: primaryBlue,
                                  ),
                                ),

                                Text(
                                  '${(todayProgress * 100).round()}%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$completedToday of ${todayTasks.length} tasks completed',
                                  style: TextStyle(
                                    color: colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  child:
                                      LinearProgressIndicator(
                                    value: todayProgress,
                                    minHeight: 8,
                                    backgroundColor:
                                        colorScheme
                                            .surfaceContainerHighest,
                                    color: primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ADD TASK BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AddEditTaskScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10),
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
              ],
            ),
          );
        },
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: HomeBottomNav(
        onHome: () {},

        onTasks: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TaskListScreen(),
            ),
          );
        },

        onAdd: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditTaskScreen(),
            ),
          );
        },

        onSettings: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SettingsScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _todayTaskItem(
    BuildContext context,
    Task task,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Icon(
            task.isCompleted
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            color: task.isCompleted
                ? primaryBlue
                : colorScheme.onSurfaceVariant,
            size: 22,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),

          if (task.priority == TaskPriority.high)
            const Icon(
              Icons.circle,
              color: Colors.red,
              size: 12,
            )
          else if (task.priority == TaskPriority.medium)
            const Icon(
              Icons.circle,
              color: Colors.amber,
              size: 12,
            )
          else
            const Icon(
              Icons.circle,
              color: Colors.blue,
              size: 12,
            ),
        ],
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    String title,
    VoidCallback onViewAll,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Theme.of(context)
                .colorScheme
                .onSurface,
          ),
        ),

        const Spacer(),

        TextButton(
          onPressed: onViewAll,
          child: const Text(
            'View All',
            style: TextStyle(
              color: primaryBlue,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyCard(
    BuildContext context,
    IconData icon,
    String text,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: colorScheme.onSurfaceVariant,
          ),

          const SizedBox(width: 12),

          Text(
            text,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _deadlineCard(
    BuildContext context,
    Task task,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 22,
            color: colorScheme.onSurfaceVariant,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${task.dueDate!.month}/${task.dueDate!.day}/${task.dueDate!.year}',
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Upcoming',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}