# TimeMatter

A task-management mobile application built with Flutter.

## Features

- Create new tasks
- Edit existing tasks
- Delete tasks
- Mark tasks as completed
- Set task priority
- Set due dates
- Set due times
- View detailed task information
- Track today's task progress
- Mobile bottom navigation

## Technology Used

- Flutter
- Dart

## Project Structure

```text
lib/
├── models/
│   └── task.dart
│
├── services/
│   └── task_service.dart
│
├── screens/
│   ├── home_screen.dart
│   ├── task_list_screen.dart
│   ├── add_edit_task_screen.dart
│   └── task_details_screen.dart
│
└── widgets/
    ├── task_card.dart
    └── home_bottom_nav.dart

```
Main Screens
Home Screen

Displays today's task progress and provides access to the user's tasks.

Task List Screen

Displays the user's tasks and allows users to complete, delete, or open a task.

Add/Edit Task Screen

Allows users to create and edit tasks.

Task Details Screen

Displays the complete information of a selected task.

Current Status

The main task-management features are implemented, including creating, editing, completing, and deleting tasks.

The Settings screen is still under development, and additional UI improvements and testing are planned.

AI Assistance

I used ChatGPT and Claude as AI development assistants for selected parts of the TimeMatter application, including code generation, implementation ideas, and troubleshooting.

I reviewed and modified the AI-generated code when it did not match my preferred project structure or UI design.

See AI-USAGE.md for the complete AI usage documentation.

Flutter Resources

For more information about Flutter, visit the Flutter documentation.
