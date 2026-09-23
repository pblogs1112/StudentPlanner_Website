import 'package:flutter/material.dart';

/// lib/widgets/bottom_nav_bar.dart
/// Order matches the Screens list: Dashboard, Class Schedule, Calendar,
/// Task, Notes.
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _icons = [
    Icons.home_rounded, // Dashboard
    Icons.schedule_rounded, // Class Schedule
    Icons.calendar_today_rounded, // Calendar
    Icons.checklist_rounded, // Task
    Icons.description_outlined, // Notes
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: const Color(0xFFE8E8E8),
      elevation: 4,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_icons.length, (i) {
              final selected = i == currentIndex;
              return InkWell(
                onTap: () => onTap(i),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    _icons[i],
                    color: selected ? theme.colorScheme.primary : Colors.black54,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
