import 'package:flutter/material.dart';
import '../state/planner_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form_dialog.dart';

enum _TaskFilter { all, pending, completed }

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  _TaskFilter _filter = _TaskFilter.all;

  static const _labels = {
    _TaskFilter.all: 'All',
    _TaskFilter.pending: 'Pending',
    _TaskFilter.completed: 'Completed',
  };

  // Add/Edit/Delete/Check go through the shared store, so the Dashboard's
  // Upcoming Tasks and the Calendar's event dots update at the same moment.
  Future<void> _addTask() async {
    final store = PlannerScope.read(context);
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => TaskFormDialog(
        title: 'Add Task',
        subjects: store.subjects,
      ),
    );
    if (result == null) return;

    store.addTask(PlannerTask(
      title: result['title'] as String,
      subject: result['subject'] as String,
      due: result['due'] as DateTime,
      completed: false,
    ));
  }

  Future<void> _editTask(PlannerTask existing) async {
    final store = PlannerScope.read(context);
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => TaskFormDialog(
        title: 'Edit Task',
        subjects: store.subjects,
        initialTitle: existing.title,
        initialSubject: existing.subject,
        initialDue: existing.due,
      ),
    );
    if (result == null) return;

    store.updateTask(
      existing,
      existing.copyWith(
        title: result['title'] as String,
        subject: result['subject'] as String,
        due: result['due'] as DateTime,
      ),
    );
  }

  List<PlannerTask> _visible(PlannerStore store) {
    final all = store.allTasks;
    switch (_filter) {
      case _TaskFilter.all:
        return all;
      case _TaskFilter.pending:
        return all.where((t) => !t.completed).toList();
      case _TaskFilter.completed:
        return all.where((t) => t.completed).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = PlannerScope.of(context);
    final tasks = _visible(store);

    return Column(
      children: [
        const AppHeader(title: 'Task'),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
          child: Row(
            children: [
              for (final f in _TaskFilter.values) ...[
                if (f != _TaskFilter.all) const SizedBox(width: 8),
                ChoiceChip(
                  label: Text(_labels[f]!),
                  selected: _filter == f,
                  onSelected: (_) => setState(() => _filter = f),
                  labelStyle: TextStyle(
                    color: _filter == f
                        ? theme.colorScheme.onPrimary
                        : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: theme.colorScheme.primary,
                  side: BorderSide(
                    color: _filter == f
                        ? theme.colorScheme.primary
                        : Colors.grey.shade300,
                  ),
                  shape: const StadiumBorder(),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
          child: ElevatedButton(
            onPressed: _addTask,
            child: const Text('+ Add Task'),
          ),
        ),
        Expanded(
          child: tasks.isEmpty
              ? Center(
                  child: Text(
                    _filter == _TaskFilter.completed
                        ? 'No completed tasks yet.'
                        : _filter == _TaskFilter.pending
                            ? 'No pending tasks. Nice work!'
                            : 'No tasks yet.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: tasks.length,
                  itemBuilder: (context, i) {
                    final t = tasks[i];
                    return TaskCard(
                      title: t.title,
                      subject: t.subject,
                      dueDate: PlannerStore.formatDue(t.due),
                      completed: t.completed,
                      onChanged: (v) => store.setTaskCompleted(t, v),
                      onEdit: () => _editTask(t),
                      onDelete: () => store.deleteTask(t),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
