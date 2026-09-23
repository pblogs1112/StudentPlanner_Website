import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// lib/widgets/app_header.dart
/// Shown at the top of all five screens. On the Dashboard, [subtitle]
/// carries the app tagline; other screens can omit it.
class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AppHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topInset = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      color: theme.colorScheme.primary,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        topInset + AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontSize: 26,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
