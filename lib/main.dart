import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/task_service.dart';
import 'services/theme_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TaskService.instance.loadTasks();
  await ThemeService.instance.loadTheme();

  runApp(const TimeMatterApp());
}

class TimeMatterApp extends StatefulWidget {
  const TimeMatterApp({super.key});

  @override
  State<TimeMatterApp> createState() => _TimeMatterAppState();
}

class _TimeMatterAppState extends State<TimeMatterApp> {
  @override
  void initState() {
    super.initState();

    ThemeService.instance.addListener(_themeChanged);
  }

  @override
  void dispose() {
    ThemeService.instance.removeListener(_themeChanged);
    super.dispose();
  }

  void _themeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Matter',

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),

      themeMode: ThemeService.instance.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      home: HomeScreen(),
    );
  }
}