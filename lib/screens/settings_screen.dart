import 'package:flutter/material.dart';

import '../services/reminder_service.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color primaryBlue = Color(0xFF1727A0);

  @override
  void initState() {
    super.initState();

    ReminderService.instance.loadReminderSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Appearance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // DARK MODE
          Card(
            child: ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              subtitle: const Text(
                'Change app appearance',
              ),
              trailing: AnimatedBuilder(
                animation: ThemeService.instance,
                builder: (context, child) {
                  return Switch(
                    value: ThemeService.instance.isDarkMode,
                    onChanged: (value) {
                      ThemeService.instance.toggleDarkMode(
                        value,
                      );
                    },
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'App Preferences',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // REMINDERS
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.notifications,
              ),
              title: const Text(
                'Enable Reminder',
              ),
              subtitle: const Text(
                'Show task reminders',
              ),
              trailing: AnimatedBuilder(
                animation: ReminderService.instance,
                builder: (context, child) {
                  return Switch(
                    value: ReminderService
                        .instance
                        .isEnabled,
                    onChanged: (value) {
                      ReminderService.instance
                          .setEnabled(value);
                    },
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'About',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // ABOUT
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.info_outline,
              ),
              title: const Text(
                'About Time Matter',
              ),
              subtitle: const Text(
                'Version 1.0',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Time Matter',
                  applicationVersion: '1.0',
                  applicationIcon: const Icon(
                    Icons.access_time,
                    color: primaryBlue,
                    size: 40,
                  ),
                  children: const [
                    Text(
                      'A task-management application built with Flutter.',
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // APP INFORMATION
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 65,
                    color: primaryBlue,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Time Matter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Version 1.0',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}