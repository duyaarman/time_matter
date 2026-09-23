import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TimeMatterApp());
}

class TimeMatterApp extends StatelessWidget {
  const TimeMatterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Matter',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}