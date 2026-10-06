# TimeMatter

A task-management mobile application built with Flutter.

[![Made with AI](https://img.shields.io/badge/Made_with-AI_assistance-blue)](AI-USAGE.md)

## Features

- Create new tasks
- Edit existing tasks
- Delete tasks
- Mark tasks as completed
- Set task priority
- Set due dates
- Set due times
- Search tasks
- View detailed task information
- Track today's task progress
- View task reminders
- Enable Dark Mode
- Set a personalized user name
- Save tasks locally
- Mobile bottom navigation

## Technology Used

- Flutter
- Dart
- Material 3
- SharedPreferences
- Git
- GitHub

## Project Structure

```text
lib/
├── models/
│   └── task.dart
│
├── services/
│   ├── task_service.dart
│   ├── reminder_service.dart
│   ├── theme_service.dart
│   └── user_name_service.dart
│
├── screens/
│   ├── home_screen.dart
│   ├── task_list_screen.dart
│   ├── add_edit_task_screen.dart
│   ├── task_details_screen.dart
│   ├── reminders_screen.dart
│   └── settings_screen.dart
│
└── widgets/
    ├── task_card.dart
    └── home_bottom_nav.dart
```

##Main Screens
#Home Screen

Displays today's tasks, upcoming deadlines, task progress, and navigation to other parts of the app.

#Task List Screen

Displays active and completed tasks and allows users to search, complete, delete, or open a task.

#Add/Edit Task Screen

Allows users to create and edit tasks with descriptions, priorities, due dates, and due times.

#Task Details Screen

Displays the complete information of a selected task.

#Reminders Screen

Displays tasks that have scheduled due dates or due times.

#Settings Screen

Allows users to enable Dark Mode and task reminders and view information about the application.

#Data Persistence

TimeMatter uses SharedPreferences to save task data, user settings, Dark Mode preferences, reminder settings, and the personalized user name locally.

#Current Status

The main task-management features are implemented and working, including creating, editing, completing, deleting, searching, reminders, Dark Mode, and local data persistence.

## AI Assistance

I used ChatGPT and Claude as AI development assistants for selected parts of the TimeMatter application, including code generation, implementation ideas, and troubleshooting.

I reviewed and modified the AI-generated code when it did not match my preferred project structure or UI design.

See [AI-USAGE.md](AI-USAGE.md) for the complete AI usage documentation.

## Flutter Resources

For more information about Flutter, visit the [Flutter documentation](https://docs.flutter.dev/).
