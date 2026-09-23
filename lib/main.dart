import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const StudentPlannerApp(),
    ),
  );
}

class StudentPlannerApp extends StatelessWidget {
  const StudentPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}
