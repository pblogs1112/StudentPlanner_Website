import 'package:flutter/material.dart';
import '../state/planner_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/class_card.dart';
import '../widgets/class_form_dialog.dart';

class ClassScheduleScreen extends StatefulWidget {
  const ClassScheduleScreen({super.key});

  @override
  State<ClassScheduleScreen> createState() => _ClassScheduleScreenState();
}

class _ClassScheduleScreenState extends State<ClassScheduleScreen> {
  static const _days = PlannerStore.days;
  static const _fullDayNames = {
    'Mon': 'Monday',
    'Tues': 'Tuesday',
    'Wed': 'Wednesday',
    'Thurs': 'Thursday',
    'Fri': 'Friday',
    'Sat': 'Saturday',
  };

  String _selectedDay = 'Mon';

  // One key per day chip, so we can scroll that chip into view whenever
  final List<GlobalKey> _dayKeys =
      List.generate(_days.length, (_) => GlobalKey());

  void _selectDay(String day) {
    setState(() => _selectedDay = day);
    // Wait a frame so the chip's context exists/updates before scrolling.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _dayKeys[_days.indexOf(day)].currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: 0.5,
        );
      }
    });
  }

  // Add/Edit/Delete go through the shared store, so the Dashboard (and any
  // other screen) updates at the same moment.
  Future<void> _addClass() async {
    final store = PlannerScope.read(context);
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => ClassFormDialog(
        title: 'Add Class',
        days: _days,
        initialDay: _selectedDay,
      ),
    );
    if (result == null) return;
    final day = result['day']!;

    store.addClass(
      day,
      ClassItem(
        subject: result['subject']!,
        time: result['time']!,
        room: result['room']!,
      ),
    );
    _selectDay(day); // jump to the day the class was added to
  }

  Future<void> _editClass(ClassItem existing) async {
    final store = PlannerScope.read(context);
    final oldDay = _selectedDay;
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => ClassFormDialog(
        title: 'Edit Class',
        days: _days,
        initialDay: oldDay,
        initialSubject: existing.subject,
        initialTime: existing.time,
        initialRoom: existing.room,
      ),
    );
    if (result == null) return;
    final day = result['day']!;

    store.updateClass(
      oldDay,
      existing,
      day,
      ClassItem(
        subject: result['subject']!,
        time: result['time']!,
        room: result['room']!,
      ),
    );
    _selectDay(day);
  }

  void _deleteClass(ClassItem item) {
    PlannerScope.read(context).deleteClass(_selectedDay, item);
  }

  void _shiftDay(int delta) {
    final index = _days.indexOf(_selectedDay);
    final next = (index + delta).clamp(0, _days.length - 1);
    _selectDay(_days[next]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final classes = PlannerScope.of(context).classesFor(_selectedDay);

    return Column(
      children: [
        const AppHeader(title: 'Class Schedule'),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            0,
          ),
          child: Row(
            children: [
              _RoundIconButton(
                icon: Icons.chevron_left,
                onTap: _days.indexOf(_selectedDay) == 0
                    ? null
                    : () => _shiftDay(-1),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < _days.length; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          ChoiceChip(
                            key: _dayKeys[i],
                            label: Text(_days[i]),
                            selected: _days[i] == _selectedDay,
                            onSelected: (_) => _selectDay(_days[i]),
                            labelStyle: TextStyle(
                              color: _days[i] == _selectedDay
                                  ? theme.colorScheme.onPrimary
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                            backgroundColor: Colors.white,
                            selectedColor: theme.colorScheme.primary,
                            side: BorderSide(
                              color: _days[i] == _selectedDay
                                  ? theme.colorScheme.primary
                                  : Colors.grey.shade300,
                            ),
                            shape: const StadiumBorder(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _RoundIconButton(
                icon: Icons.chevron_right,
                onTap: _days.indexOf(_selectedDay) == _days.length - 1
                    ? null
                    : () => _shiftDay(1),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            0,
          ),
          child: ElevatedButton(
            onPressed: _addClass,
            child: const Text('+ Add Class'),
          ),
        ),
        Expanded(
          child: classes.isEmpty
              ? Center(
                  child: Text(
                    'No classes scheduled for ${_fullDayNames[_selectedDay]}.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: classes.length,
                  itemBuilder: (context, i) {
                    final c = classes[i];
                    return ClassCard(
                      subject: c.subject,
                      day: _selectedDay,
                      time: c.time,
                      room: c.room,
                      onEdit: () => _editClass(c),
                      onDelete: () => _deleteClass(c),
                    );
                  },
                ),
        ),
      ],
    );
  }
}


class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
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
        child: Icon(
          icon,
          size: 20,
          color: enabled ? Colors.black87 : Colors.black26,
        ),
      ),
    );
  }
}
