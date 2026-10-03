import 'package:flutter/material.dart';
import '../state/planner_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/class_card.dart';
import '../widgets/task_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Tasks stay as sample data until the Task screen is ready.
  static const _upcomingTasks = [
    {'title': 'Packet Tracer Lab 3', 'subject': 'Computer Networking', 'due': 'Jul 13, 2026', 'completed': false},
    {'title': 'SQL Normalization Quiz', 'subject': 'Database Management', 'due': 'Jul 29, 2026', 'completed': false},
    {'title': 'Discrete Math Problem Set 4', 'subject': 'Discrete Mathematics', 'due': 'July 29, 2026', 'completed': false},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final classes = PlannerScope.of(context).classesToday();

    return Column(
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
              if (classes.isEmpty)
                const _EmptyNote('No classes today.')
              else
                for (final c in classes)
                  ClassCard(
                    subject: c.subject,
                    day: '',
                    time: c.time,
                    room: c.room,
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
                ),
            ],
          ),
        ),
      ],
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

class _EmptyNote extends StatelessWidget {
  final String text;
  const _EmptyNote(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Colors.black54),
    );
  }
}
