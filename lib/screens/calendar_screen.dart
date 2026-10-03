import 'package:flutter/material.dart';
import '../state/planner_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _weekdayHeaders = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _weekdayFullNames = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  // Starts on the real current date, so the Calendar opens on today.
  late DateTime _visibleMonth;
  late DateTime _selectedDate;
  late final DateTime _today;

  @override
  void initState() {
    super.initState();
    _today = _dateOnly(DateTime.now());
    _selectedDate = _today;
    _visibleMonth = DateTime(_today.year, _today.month);
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  List<DateTime> _gridDays() {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final gridStart = firstOfMonth.subtract(Duration(days: firstOfMonth.weekday - 1));
    return List.generate(42, (i) => gridStart.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = _gridDays();
    final store = PlannerScope.of(context);
    final events = store.tasksOn(_selectedDate);

    return Column(
      children: [
        const AppHeader(title: 'Calendar'),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _RoundIconButton(
                    icon: Icons.chevron_left,
                    onTap: () => _changeMonth(-1),
                  ),
                  Column(
                    children: [
                      Text(
                        _monthNames[_visibleMonth.month - 1],
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontSize: 20, color: Colors.black87),
                      ),
                      Text(
                        '${_visibleMonth.year}',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: Colors.black54),
                      ),
                    ],
                  ),
                  _RoundIconButton(
                    icon: Icons.chevron_right,
                    onTap: () => _changeMonth(1),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  for (final h in _weekdayHeaders)
                    Expanded(
                      child: Center(
                        child: Text(
                          h,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              for (int week = 0; week < 6; week++)
                Row(
                  children: [
                    for (int d = 0; d < 7; d++)
                      _DayCell(
                        date: days[week * 7 + d],
                        inCurrentMonth:
                            days[week * 7 + d].month == _visibleMonth.month,
                        isSelected: _dateOnly(days[week * 7 + d]) ==
                            _dateOnly(_selectedDate),
                        isToday: _dateOnly(days[week * 7 + d]) == _today,
                        eventCount: store.tasksOn(days[week * 7 + d]).length,
                        onTap: () =>
                            setState(() => _selectedDate = days[week * 7 + d]),
                      ),
                  ],
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text(
                '${_weekdayFullNames[_selectedDate.weekday - 1]}, '
                '${_monthNames[_selectedDate.month - 1]} ${_selectedDate.day}',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (events.isEmpty)
                Text(
                  'No events scheduled.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                )
              else
                for (final e in events) _EventCard(event: e),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool inCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final int eventCount;
  final VoidCallback onTap;

  const _DayCell({
    required this.date,
    required this.inCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.eventCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dotCount = eventCount.clamp(0, 2);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? theme.colorScheme.primary : null,
                  // Ring marks today when another day is selected.
                  border: isToday && !isSelected
                      ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                      : null,
                ),
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : (inCurrentMonth ? Colors.black87 : Colors.black26),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                height: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < dotCount; i++)
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final PlannerTask event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeBg =
        event.completed ? theme.colorScheme.tertiary : theme.colorScheme.primaryContainer;
    final badgeFg = event.completed
        ? theme.colorScheme.onTertiary
        : theme.colorScheme.onPrimaryContainer;

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  event.subject,
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration:
                BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(20)),
            child: Text(
              event.completed ? 'Completed' : 'Pending',
              style: TextStyle(color: badgeFg, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
