import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// lib/widgets/class_card.dart
/// Appears on Dashboard (compact, no edit/delete) and Class Schedule
/// (full, with edit/delete). Passing null for onEdit/onDelete hides
/// the corresponding action.
class ClassCard extends StatelessWidget {
  final String subject;
  final String day;
  final String time;
  final String room;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ClassCard({
    super.key,
    required this.subject,
    required this.day,
    required this.time,
    required this.room,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            '$time  Room: $room',
            style: theme.textTheme.labelSmall?.copyWith(fontSize: 13),
          ),
          if (showActions) ...[
            const Divider(height: 20),
            Row(
              children: [
                if (onEdit != null)
                  _ActionLabel(icon: Icons.edit, label: 'Edit', onTap: onEdit!),
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
