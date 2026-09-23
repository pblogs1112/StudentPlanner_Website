import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/class_card.dart';
import '../widgets/task_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;

  // Sample data for now. Once shared_preferences is wired up, load
  // today's classes and pending tasks from the class_schedules / tasks
  // keys instead of this hard-coded list.
  final List<Map<String, String>> _todayClasses = const [
    {
      'subject': 'Discrete Mathematics',
      'time': '9:00 AM - 10:30 AM',
      'room': 'SJH 406',
    },
    {
      'subject': 'Computer Networking',
      'time': '1:00 PM - 2:30 PM',
      'room': 'SJH 301',
    },
    {
      'subject': 'Web Development',
      'time': '10:35 AM - 12:00 PM',
      'room': 'SJH 703',
    },
  ];

  final List<Map<String, dynamic>> _upcomingTasks = const [
    {
      'title': 'Packet Tracer Lab 3',
      'subject': 'Computer Networking',
      'due': 'Jul 13, 2026',
      'completed': false,
    },
    {
      'title': 'SQL Normalization Quiz',
      'subject': 'Database Management',
      'due': 'Jul 29, 2026',
      'completed': false,
    },
    {
      'title': 'Discrete Math Problem Set 4',
      'subject': 'Discrete Mathematics',
      'due': 'July 29, 2026',
      'completed': false,
    },
  ];

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          const AppHeader(
            title: 'Student Planner',
            subtitle: '"Stay organized. Stay focused. Stay ahead."',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text('Welcome back,', style: theme.textTheme.bodyMedium),
                Text('Student !', style: theme.textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.lg),
                _SectionLabel('TODAY\'S CLASSES'),
                const SizedBox(height: AppSpacing.sm),
                for (final c in _todayClasses)
                  ClassCard(
                    subject: c['subject']!,
                    day: '', // not shown on the Dashboard card
                    time: c['time']!,
                    room: c['room']!,
                    // onEdit/onDelete left null: Dashboard shows the
                    // compact card with no Edit/Delete controls.
                  ),
                const SizedBox(height: AppSpacing.lg),
                _SectionLabel('UPCOMING TASKS'),
                const SizedBox(height: AppSpacing.sm),
                for (final t in _upcomingTasks)
                  TaskCard(
                    title: t['title'] as String,
                    subject: t['subject'] as String,
                    dueDate: t['due'] as String,
                    completed: t['completed'] as bool,
                    // onChanged left null: Dashboard shows the Pending/
                    // Completed badge only, no checkbox.
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          BottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            fontSize: 13,
          ),
    );
  }
}
