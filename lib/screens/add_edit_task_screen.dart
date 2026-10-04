import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({
    super.key,
    this.task,
  });

  @override
  State<AddEditTaskScreen> createState() =>
      _AddEditTaskScreenState();
}

class _AddEditTaskScreenState
    extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  TaskPriority _priority = TaskPriority.medium;

  bool get isEditing => widget.task != null;

  static const Color primaryBlue = Color(0xFF1727A0);

  @override
  void initState() {
    super.initState();

    final task = widget.task;

    _titleController = TextEditingController(
      text: task?.title ?? '',
    );

    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );

    _dueDate = task?.dueDate;
    _priority = task?.priority ?? TaskPriority.medium;

    if (task?.dueTime != null) {
      final parts = task!.dueTime!.split(':');

      if (parts.length == 2) {
        _dueTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 0,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _dueTime = selectedTime;
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final service = TaskService.instance;

    final task = Task(
      id: widget.task?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _dueDate,
      dueTime: _dueTime?.format(context),
      priority: _priority,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    if (isEditing) {
      service.updateTask(task);
    } else {
      service.addTask(task);
    }

    Navigator.pop(context);
  }

  String _dateText() {
    if (_dueDate == null) {
      return 'Select due date';
    }

    return '${_dueDate!.month}/${_dueDate!.day}/${_dueDate!.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEditing ? 'Edit Task' : 'New Task',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            20,
            16,
            30,
          ),
          children: [
            Text(
              'Task Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              isEditing
                  ? 'Update the details of your task.'
                  : 'Create a new task and stay organized.',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 22),

            // TITLE
            _sectionLabel(
              context,
              'Task Title',
            ),

            const SizedBox(height: 8),

            TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                context: context,
                hint: 'Enter task title',
                icon: Icons.title,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter a task title';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            // DESCRIPTION
            _sectionLabel(
              context,
              'Description',
            ),

            const SizedBox(height: 8),

            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: _inputDecoration(
                context: context,
                hint: 'Add a description...',
                icon: Icons.notes_outlined,
              ),
            ),

            const SizedBox(height: 22),

            // PRIORITY
            _sectionLabel(
              context,
              'Priority',
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<TaskPriority>(
              initialValue: _priority,
              decoration: _inputDecoration(
                context: context,
                hint: 'Select priority',
                icon: Icons.flag_outlined,
              ),
              items: const [
                DropdownMenuItem(
                  value: TaskPriority.low,
                  child: Text('Low'),
                ),
                DropdownMenuItem(
                  value: TaskPriority.medium,
                  child: Text('Medium'),
                ),
                DropdownMenuItem(
                  value: TaskPriority.high,
                  child: Text('High'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _priority = value;
                  });
                }
              },
            ),

            const SizedBox(height: 22),

            // DATE AND TIME
            _sectionLabel(
              context,
              'Schedule',
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _scheduleButton(
                    context: context,
                    icon: Icons.calendar_today_outlined,
                    title: 'Due Date',
                    value: _dateText(),
                    onTap: _selectDate,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _scheduleButton(
                    context: context,
                    icon: Icons.access_time,
                    title: 'Due Time',
                    value: _dueTime == null
                        ? 'Select time'
                        : _dueTime!.format(context),
                    onTap: _selectTime,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // SAVE BUTTON
            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  isEditing
                      ? Icons.save_outlined
                      : Icons.add_task,
                ),
                label: Text(
                  isEditing
                      ? 'Update Task'
                      : 'Create Task',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(
    BuildContext context,
    String text,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String hint,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: primaryBlue,
        size: 20,
      ),
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: primaryBlue,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _scheduleButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: primaryBlue,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 7),

            Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}