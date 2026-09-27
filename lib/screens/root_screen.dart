import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dashboard_screen.dart';
import 'class_schedule_screen.dart';
import 'calendar_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _navIndex = 0;

  static const _screens = [
    DashboardScreen(),
    ClassScheduleScreen(),
    CalendarScreen(),
    _ComingSoonScreen(title: 'Task'),
    _ComingSoonScreen(title: 'Notes'),
  ];

  void _onNavTap(int index) => setState(() => _navIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _navIndex, children: _screens),
      bottomNavigationBar: BottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
    );
  }
}


class _ComingSoonScreen extends StatelessWidget {
  final String title;
  const _ComingSoonScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppHeader(title: title),
        Expanded(
          child: Center(
            child: Text(
              '$title screen coming soon.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}
