import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// lib/widgets/task_card.dart
/// Appears on Dashboard (onChanged null -> badge only, read-only) and
/// Task screen (onChanged set -> shows a checkbox the user can toggle).
class TaskCard extends StatelessWidget {
  final String title;
  final String subject;
  final String dueDate;
  final bool completed;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.completed,
    this.onChanged,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showActions = onEdit != null || onDelete != null;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(color: theme.colorScheme.secondary, width: 4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onChanged != null) ...[
            Checkbox(
              value: completed,
              onChanged: (v) => onChanged!(v ?? false),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  '$subject  Due $dueDate',
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 13),
                ),
                if (showActions) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (onEdit != null)
                        _ActionLabel(
                            icon: Icons.edit, label: 'Edit', onTap: onEdit!),
                      if (onEdit != null && onDelete != null)
                        const SizedBox(width: 16),
                      if (onDelete != null)
                        _ActionLabel(
                            icon: Icons.delete_outline,
                            label: 'Delete',
                            onTap: onDelete!),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          _StatusBadge(completed: completed),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool completed;
  const _StatusBadge({required this.completed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg =
        completed ? theme.colorScheme.tertiary : theme.colorScheme.primaryContainer;
    final fg = completed
        ? theme.colorScheme.onTertiary
        : theme.colorScheme.onPrimaryContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        completed ? 'Completed' : 'Pending',
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ActionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionLabel(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        ],
      ),
    );
  }
}
