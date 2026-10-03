import 'package:flutter/material.dart';
import '../state/planner_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/class_card.dart';
import '../widgets/task_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = PlannerScope.of(context);
    final classes = store.classesToday();
    // Next three pending tasks, soonest first. Follows the Task screen.
    final tasks = store.upcomingTasks.take(3).toList();

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
              if (tasks.isEmpty)
                const _EmptyNote('No upcoming tasks.')
              else
                for (final t in tasks)
                  TaskCard(
                    title: t.title,
                    subject: t.subject,
                    dueDate: PlannerStore.formatDue(t.due),
                    completed: t.completed,
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
