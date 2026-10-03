import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String subject;
  final String body;
  final String updated;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const NoteCard({
    super.key,
    required this.title,
    required this.subject,
    required this.body,
    required this.updated,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  subject,
                  style: TextStyle(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            'Edited $updated',
            style: theme.textTheme.labelSmall
                ?.copyWith(fontSize: 12, color: Colors.black54),
          ),
          if (onEdit != null || onDelete != null) ...[
            const SizedBox(height: 8),
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
