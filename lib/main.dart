import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'theme/app_theme.dart';
import 'screens/root_screen.dart';
import 'state/planner_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved classes, tasks and notes before the first frame, so the app
  // never flashes the sample data first.
  final store = PlannerStore();
  await store.load();

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => StudentPlannerApp(store: store),
    ),
  );
}

class StudentPlannerApp extends StatefulWidget {
  final PlannerStore? store;
  const StudentPlannerApp({super.key, this.store});

  @override
  State<StudentPlannerApp> createState() => _StudentPlannerAppState();
}

class _StudentPlannerAppState extends State<StudentPlannerApp> {
  late final PlannerStore _store = widget.store ?? PlannerStore();

  @override
  void dispose() {
    if (widget.store == null) _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlannerScope(
      store: _store,
      child: MaterialApp(
        title: 'Student Planner',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const RootScreen(),
      ),
    );
  }
}
