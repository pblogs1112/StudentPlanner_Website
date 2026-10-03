import 'package:flutter/material.dart';

class ClassItem {
  final String subject;
  final String time;
  final String room;

  ClassItem({required this.subject, required this.time, required this.room});
}

class PlannerTask {
  final String title;
  final String subject;
  final DateTime due;
  final bool completed;

  PlannerTask({
    required this.title,
    required this.subject,
    required this.due,
    required this.completed,
  });

  PlannerTask copyWith({bool? completed}) => PlannerTask(
        title: title,
        subject: subject,
        due: due,
        completed: completed ?? this.completed,
      );
}

class PlannerStore extends ChangeNotifier {
  static const days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat'];

  static const _shortMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  final Map<String, List<ClassItem>> _classesByDay = {
    'Mon': [
      ClassItem(subject: 'Discrete Mathematics', time: '9:00 AM - 10:30 AM', room: 'SJH 406'),
      ClassItem(subject: 'Web Development', time: '10:35 AM - 12:00 PM', room: 'SJH 703'),
      ClassItem(subject: 'Computer Networking', time: '1:00 PM - 2:30 PM', room: 'SJH 301'),
    ],
    'Tues': [
      ClassItem(subject: 'Database Management', time: '9:00 AM - 10:30 AM', room: 'SJH 210'),
      ClassItem(subject: 'Software Engineering', time: '1:00 PM - 2:30 PM', room: 'SJH 110'),
    ],
    'Wed': [
      ClassItem(subject: 'Discrete Mathematics', time: '9:00 AM - 10:30 AM', room: 'SJH 406'),
      ClassItem(subject: 'Web Development', time: '10:35 AM - 12:00 PM', room: 'SJH 703'),
    ],
    'Thurs': [
      ClassItem(subject: 'Database Management', time: '9:00 AM - 10:30 AM', room: 'SJH 210'),
      ClassItem(subject: 'Computer Networking', time: '1:00 PM - 2:30 PM', room: 'SJH 301'),
    ],
    'Fri': [
      ClassItem(subject: 'Discrete Mathematics', time: '9:00 AM - 10:30 AM', room: 'SJH 406'),
      ClassItem(subject: 'Software Engineering', time: '1:00 PM - 2:30 PM', room: 'SJH 110'),
    ],
    'Sat': [],
  };

  final List<PlannerTask> _tasks = [
    PlannerTask(
      title: 'HTML Accessibility Quiz',
      subject: 'Web Development',
      due: DateTime(2026, 7, 2),
      completed: true,
    ),
    PlannerTask(
      title: 'Discrete Math Problem Set 4',
      subject: 'Discrete Mathematics',
      due: DateTime(2026, 7, 13),
      completed: false,
    ),
    PlannerTask(
      title: 'Packet Tracer Lab 3',
      subject: 'Computer Networking',
      due: DateTime(2026, 7, 29),
      completed: false,
    ),
    PlannerTask(
      title: 'SQL Normalization Quiz',
      subject: 'Database Management',
      due: DateTime(2026, 7, 29),
      completed: false,
    ),
    PlannerTask(
      title: 'Sprint Review',
      subject: 'Software Engineering',
      due: DateTime(2026, 7, 30),
      completed: false,
    ),
  ];

  // ---------------------------------------------------------------- classes

  /// Classes for one day, ordered by start time.
  List<ClassItem> classesFor(String day) {
    final list = List<ClassItem>.of(_classesByDay[day] ?? const []);
    list.sort((a, b) => _startMinutes(a.time).compareTo(_startMinutes(b.time)));
    return list;
  }

  /// Classes for today's real weekday (Sunday has none).
  List<ClassItem> classesToday({DateTime? now}) {
    final d = now ?? DateTime.now();
    if (d.weekday > days.length) return const [];
    return classesFor(days[d.weekday - 1]);
  }

  void addClass(String day, ClassItem item) {
    _classesByDay.putIfAbsent(day, () => []).add(item);
    notifyListeners();
  }

  void updateClass(
    String oldDay,
    ClassItem oldItem,
    String newDay,
    ClassItem updated,
  ) {
    _classesByDay[oldDay]?.remove(oldItem);
    _classesByDay.putIfAbsent(newDay, () => []).add(updated);
    notifyListeners();
  }

  void deleteClass(String day, ClassItem item) {
    _classesByDay[day]?.remove(item);
    notifyListeners();
  }

  // ------------------------------------------------------------------ tasks

  /// Pending tasks, soonest due date first.
  List<PlannerTask> get upcomingTasks {
    final list = _tasks.where((t) => !t.completed).toList();
    list.sort((a, b) => a.due.compareTo(b.due));
    return list;
  }

  /// Every task (pending or completed) due on the given day.
  List<PlannerTask> tasksOn(DateTime day) =>
      _tasks.where((t) => _sameDay(t.due, day)).toList();

  void addTask(PlannerTask task) {
    _tasks.add(task);
    notifyListeners();
  }

  void setTaskCompleted(PlannerTask task, bool completed) {
    final i = _tasks.indexOf(task);
    if (i == -1) return;
    _tasks[i] = task.copyWith(completed: completed);
    notifyListeners();
  }

  void deleteTask(PlannerTask task) {
    _tasks.remove(task);
    notifyListeners();
  }

  // ---------------------------------------------------------------- helpers

  static String formatDue(DateTime d) =>
      '${_shortMonths[d.month - 1]} ${d.day}, ${d.year}';

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Minutes after midnight for the start of "9:00 AM - 10:30 AM".
  /// Unparseable times sort last.
  static int _startMinutes(String time) {
    final start = time.split('-').first;
    final m = RegExp(r'(\d{1,2})(?::(\d{2}))?\s*(am|pm)?', caseSensitive: false)
        .firstMatch(start);
    if (m == null) return 24 * 60;
    var hour = int.parse(m.group(1)!) % 12;
    final minute = int.tryParse(m.group(2) ?? '0') ?? 0;
    final meridiem = m.group(3)?.toLowerCase();
    if (meridiem == 'pm') hour += 12;
    if (meridiem == null && int.parse(m.group(1)!) == 12) hour = 12;
    return hour * 60 + minute;
  }
}

/// Makes the store available to every widget below it. Widgets that call
/// [PlannerScope.of] rebuild automatically whenever the store changes.
class PlannerScope extends InheritedNotifier<PlannerStore> {
  const PlannerScope({
    super.key,
    required PlannerStore store,
    required super.child,
  }) : super(notifier: store);

  /// Use inside build(): the widget rebuilds when the store changes.
  static PlannerStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PlannerScope>();
    assert(scope != null, 'No PlannerScope found above this widget.');
    return scope!.notifier!;
  }

  /// Use inside event handlers: reads the store without subscribing.
  static PlannerStore read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<PlannerScope>();
    assert(scope != null, 'No PlannerScope found above this widget.');
    return scope!.notifier!;
  }
}
