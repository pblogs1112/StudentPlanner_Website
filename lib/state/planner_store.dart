import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassItem {
  final String subject;
  final String time;
  final String room;

  ClassItem({required this.subject, required this.time, required this.room});

  Map<String, dynamic> toJson() =>
      {'subject': subject, 'time': time, 'room': room};

  factory ClassItem.fromJson(Map<String, dynamic> json) => ClassItem(
        subject: json['subject'] as String,
        time: json['time'] as String,
        room: json['room'] as String,
      );
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

  Map<String, dynamic> toJson() => {
        'title': title,
        'subject': subject,
        'due': due.toIso8601String(),
        'completed': completed,
      };

  factory PlannerTask.fromJson(Map<String, dynamic> json) => PlannerTask(
        title: json['title'] as String,
        subject: json['subject'] as String,
        due: DateTime.parse(json['due'] as String),
        completed: json['completed'] as bool,
      );

  PlannerTask copyWith({
    String? title,
    String? subject,
    DateTime? due,
    bool? completed,
  }) =>
      PlannerTask(
        title: title ?? this.title,
        subject: subject ?? this.subject,
        due: due ?? this.due,
        completed: completed ?? this.completed,
      );
}

class PlannerNote {
  final String title;
  final String subject;
  final String body;
  final DateTime updated;

  PlannerNote({
    required this.title,
    required this.subject,
    required this.body,
    required this.updated,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'subject': subject,
        'body': body,
        'updated': updated.toIso8601String(),
      };

  factory PlannerNote.fromJson(Map<String, dynamic> json) => PlannerNote(
        title: json['title'] as String,
        subject: json['subject'] as String,
        body: json['body'] as String,
        updated: DateTime.parse(json['updated'] as String),
      );
}

DateTime _fromToday(int days) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + days);
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
      due: _fromToday(-3),
      completed: true,
    ),
    PlannerTask(
      title: 'Discrete Math Problem Set 4',
      subject: 'Discrete Mathematics',
      due: _fromToday(2),
      completed: false,
    ),
    PlannerTask(
      title: 'Packet Tracer Lab 3',
      subject: 'Computer Networking',
      due: _fromToday(5),
      completed: false,
    ),
    PlannerTask(
      title: 'SQL Normalization Quiz',
      subject: 'Database Management',
      due: _fromToday(5),
      completed: false,
    ),
    PlannerTask(
      title: 'Sprint Review',
      subject: 'Software Engineering',
      due: _fromToday(9),
      completed: false,
    ),
  ];

  final List<PlannerNote> _notes = [
    PlannerNote(
      title: 'Normal forms cheat sheet',
      subject: 'Database Management',
      body: '1NF: atomic values only. 2NF: no partial dependency on the key. '
          '3NF: no transitive dependency. Review before the SQL quiz.',
      updated: DateTime(2026, 7, 20),
    ),
    PlannerNote(
      title: 'Subnetting reminders',
      subject: 'Computer Networking',
      body: 'Block size = 256 - the interesting octet of the mask. '
          'Bring the Packet Tracer file to the lab.',
      updated: DateTime(2026, 7, 22),
    ),
  ];

  // ------------------------------------------------------------ persistence

  /// The one shared_preferences key that holds classes, tasks and notes.
  /// Bump the suffix if the saved shape ever changes.
  static const storageKey = 'planner_data_v1';

  SharedPreferences? _prefs;
  Future<void> _lastSave = Future<void>.value();

  /// Completes once every save started so far has finished. Tests await this.
  Future<void> get saved => _lastSave;

  /// Loads saved data. Call once at startup, before runApp. On the very
  /// first run (nothing saved yet) or if the saved data is unreadable, the
  /// sample data stays in place. Until this succeeds the store never writes,
  /// so a store built without load() (like in most tests) touches no storage.
  Future<void> load() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final raw = _prefs!.getString(storageKey);
      if (raw == null) return;

      final data = jsonDecode(raw) as Map<String, dynamic>;

      final classes = <String, List<ClassItem>>{};
      (data['classes'] as Map<String, dynamic>).forEach((day, list) {
        classes[day] = [
          for (final c in list as List)
            ClassItem.fromJson(c as Map<String, dynamic>),
        ];
      });
      for (final d in days) {
        classes.putIfAbsent(d, () => []);
      }
      final tasks = [
        for (final t in data['tasks'] as List)
          PlannerTask.fromJson(t as Map<String, dynamic>),
      ];
      final notes = [
        for (final n in data['notes'] as List)
          PlannerNote.fromJson(n as Map<String, dynamic>),
      ];

      // Only replace the sample data once everything parsed cleanly.
      _classesByDay
        ..clear()
        ..addAll(classes);
      _tasks
        ..clear()
        ..addAll(tasks);
      _notes
        ..clear()
        ..addAll(notes);
      notifyListeners();
    } catch (_) {
      // Unreadable or missing storage: keep the sample data.
    }
  }

  /// Snapshots the current data now and writes it in the background.
  /// Writes are chained so they land in the order they were made.
  void _save() {
    final prefs = _prefs;
    if (prefs == null) return;
    final json = jsonEncode({
      'classes': {
        for (final e in _classesByDay.entries)
          e.key: [for (final c in e.value) c.toJson()],
      },
      'tasks': [for (final t in _tasks) t.toJson()],
      'notes': [for (final n in _notes) n.toJson()],
    });
    _lastSave = _lastSave
        .then<void>((_) => prefs.setString(storageKey, json))
        .catchError((Object _) {});
  }

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

  /// Every distinct subject on the class schedule, A to Z. The Task and
  /// Notes forms use this for their subject dropdown.
  List<String> get subjects {
    final set = <String>{
      for (final list in _classesByDay.values)
        for (final c in list) c.subject,
    };
    return set.toList()..sort();
  }

  void addClass(String day, ClassItem item) {
    _classesByDay.putIfAbsent(day, () => []).add(item);
    notifyListeners();
    _save();
  }

  void updateClass(
    String oldDay,
    ClassItem oldItem,
    String newDay,
    ClassItem updated,
  ) {
    _classesByDay[oldDay]?.remove(oldItem);
    _classesByDay.putIfAbsent(newDay, () => []).add(updated);
    _renameSubjectIfGone(oldItem.subject, updated.subject);
    notifyListeners();
    _save();
  }

  /// When a class is renamed and its old name is no longer on the schedule,
  /// move that subject's tasks and notes to the new name so they stay linked.
  /// If another day still has a class with the old name, nothing changes.
  void _renameSubjectIfGone(String from, String to) {
    if (from == to || subjects.contains(from)) return;
    for (var i = 0; i < _tasks.length; i++) {
      if (_tasks[i].subject == from) {
        _tasks[i] = _tasks[i].copyWith(subject: to);
      }
    }
    for (var i = 0; i < _notes.length; i++) {
      final n = _notes[i];
      if (n.subject == from) {
        _notes[i] = PlannerNote(
          title: n.title,
          subject: to,
          body: n.body,
          updated: n.updated,
        );
      }
    }
  }

  void deleteClass(String day, ClassItem item) {
    _classesByDay[day]?.remove(item);
    notifyListeners();
    _save();
  }

  // ------------------------------------------------------------------ tasks

  /// Pending tasks, soonest due date first.
  /// Pending tasks due today or later, soonest first. Overdue and
  /// completed tasks are left out (the Task screen still lists them).
  List<PlannerTask> get upcomingTasks => upcomingTasksFrom(DateTime.now());

  List<PlannerTask> upcomingTasksFrom(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final list = _tasks
        .where((t) => !t.completed && !t.due.isBefore(today))
        .toList();
    list.sort((a, b) => a.due.compareTo(b.due));
    return list;
  }

  /// Every task (pending or completed) due on the given day.
  List<PlannerTask> tasksOn(DateTime day) =>
      _tasks.where((t) => _sameDay(t.due, day)).toList();

  void addTask(PlannerTask task) {
    _tasks.add(task);
    notifyListeners();
    _save();
  }

  /// Every task, soonest due date first (completed ones included).
  List<PlannerTask> get allTasks {
    final list = List<PlannerTask>.of(_tasks);
    list.sort((a, b) => a.due.compareTo(b.due));
    return list;
  }

  void updateTask(PlannerTask old, PlannerTask updated) {
    final i = _tasks.indexOf(old);
    if (i == -1) return;
    _tasks[i] = updated;
    notifyListeners();
    _save();
  }

  void setTaskCompleted(PlannerTask task, bool completed) {
    final i = _tasks.indexOf(task);
    if (i == -1) return;
    _tasks[i] = task.copyWith(completed: completed);
    notifyListeners();
    _save();
  }

  void deleteTask(PlannerTask task) {
    _tasks.remove(task);
    notifyListeners();
    _save();
  }

  // ------------------------------------------------------------------ notes

  /// Notes, most recently edited first.
  List<PlannerNote> get notes {
    final list = List<PlannerNote>.of(_notes);
    list.sort((a, b) => b.updated.compareTo(a.updated));
    return list;
  }

  void addNote(PlannerNote note) {
    _notes.add(note);
    notifyListeners();
    _save();
  }

  void updateNote(PlannerNote old, PlannerNote updated) {
    final i = _notes.indexOf(old);
    if (i == -1) return;
    _notes[i] = updated;
    notifyListeners();
    _save();
  }

  void deleteNote(PlannerNote note) {
    _notes.remove(note);
    notifyListeners();
    _save();
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
