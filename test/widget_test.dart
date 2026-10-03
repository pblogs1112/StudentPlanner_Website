import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:final_project/main.dart';
import 'package:final_project/state/planner_store.dart';

void main() {
  testWidgets('Dashboard shows its title, greeting, and section labels',
      (tester) async {
    // Build the app. We build StudentPlannerApp directly, not a
    // DevicePreview wrapper, because a test does not need the phone frame.
    await tester.pumpWidget(const StudentPlannerApp());

    // App header
    expect(find.text('Student Planner'), findsOneWidget);
    expect(find.text('"Stay organized. Stay focused. Stay ahead."'),
        findsOneWidget);

    // Greeting
    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('Student !'), findsOneWidget);

    // Section labels (today's classes depend on the real weekday, so we do
    // not assert on a specific class here)
    expect(find.text("TODAY'S CLASSES"), findsOneWidget);
    expect(find.text('UPCOMING TASKS'), findsOneWidget);

    // One of the sample upcoming tasks, still Pending
    expect(find.text('Packet Tracer Lab 3'), findsOneWidget);
    expect(find.text('Pending'), findsWidgets);
  });

  testWidgets('Dashboard follows class changes made in the store',
      (tester) async {
    final today = DateTime.now().weekday;
    if (today > PlannerStore.days.length) return; // Sunday: no classes to show

    final store = PlannerStore();
    await tester.pumpWidget(StudentPlannerApp(store: store));
    expect(find.text('Brand New Class'), findsNothing);

    store.addClass(
      PlannerStore.days[today - 1],
      ClassItem(subject: 'Brand New Class', time: '6:00 AM - 7:00 AM', room: 'T1'),
    );
    await tester.pump();
    expect(find.text('Brand New Class'), findsOneWidget);
  });

  test('Classes for a day are sorted by start time', () {
    final store = PlannerStore();
    store.addClass(
      'Mon',
      ClassItem(subject: 'Early Bird', time: '7:30 AM - 9:00 AM', room: 'X1'),
    );
    final monday = DateTime(2026, 9, 28); // a Monday
    expect(store.classesToday(now: monday).first.subject, 'Early Bird');
    expect(store.classesToday(now: DateTime(2026, 9, 27)), isEmpty); // Sunday
  });

  testWidgets('Bottom nav bar shows all five icons', (tester) async {
    await tester.pumpWidget(const StudentPlannerApp());

    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);
    expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
    expect(find.byIcon(Icons.checklist_rounded), findsOneWidget);
    expect(find.byIcon(Icons.description_outlined), findsOneWidget);
  });

  testWidgets('Dashboard Upcoming Tasks follow the Task store', (tester) async {
    final store = PlannerStore();
    await tester.pumpWidget(StudentPlannerApp(store: store));

    // A task due before everything else jumps to the top of the Dashboard.
    store.addTask(PlannerTask(
      title: 'Brand New Task',
      subject: 'Web Development',
      due: DateTime(2026, 7, 1),
      completed: false,
    ));
    await tester.pump();
    expect(find.text('Brand New Task'), findsOneWidget);

    // Completing it removes it from Upcoming Tasks.
    store.setTaskCompleted(store.upcomingTasks.first, true);
    await tester.pump();
    expect(find.text('Brand New Task'), findsNothing);
  });

  test('Calendar sees tasks added or completed in the store', () {
    final store = PlannerStore();
    final day = DateTime(2026, 8, 5);
    expect(store.tasksOn(day), isEmpty);

    final task = PlannerTask(
      title: 'Lab Report',
      subject: 'Computer Networking',
      due: day,
      completed: false,
    );
    store.addTask(task);
    expect(store.tasksOn(day).single.completed, isFalse);

    store.setTaskCompleted(task, true);
    expect(store.tasksOn(day).single.completed, isTrue);

    store.deleteTask(store.tasksOn(day).single);
    expect(store.tasksOn(day), isEmpty);
  });

  test('Notes can be added, edited, and deleted', () {
    final store = PlannerStore();
    final before = store.notes.length;
    final note = PlannerNote(
      title: 'Quick note',
      subject: 'General',
      body: 'Hello',
      updated: DateTime(2026, 9, 1),
    );
    store.addNote(note);
    expect(store.notes.length, before + 1);

    store.updateNote(
      note,
      PlannerNote(
        title: 'Renamed',
        subject: 'General',
        body: 'Hello',
        updated: DateTime(2026, 9, 2),
      ),
    );
    expect(store.notes.first.title, 'Renamed'); // newest edit first

    store.deleteNote(store.notes.first);
    expect(store.notes.length, before);
  });

  testWidgets('Task and Notes tabs open their screens', (tester) async {
    await tester.pumpWidget(const StudentPlannerApp());

    await tester.tap(find.byIcon(Icons.checklist_rounded));
    await tester.pump();
    expect(find.text('+ Add Task'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.description_outlined));
    await tester.pump();
    expect(find.text('+ Add Note'), findsOneWidget);
  });

  testWidgets('Calendar opens on the real current date', (tester) async {
    await tester.pumpWidget(const StudentPlannerApp());
    await tester.tap(find.byIcon(Icons.calendar_today_rounded));
    await tester.pump();

    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final now = DateTime.now();
    // Month title and the selected-day heading both show today's month.
    expect(find.text(months[now.month - 1]), findsOneWidget);
    expect(find.textContaining('${months[now.month - 1]} ${now.day}'),
        findsOneWidget);
  });

  group('Saved data (shared_preferences)', () {
    test('Added classes, tasks and notes survive a restart', () async {
      SharedPreferences.setMockInitialValues({});
      final first = PlannerStore();
      await first.load();

      first.addClass(
        'Sat',
        ClassItem(subject: 'Saved Class', time: '8:00 AM - 9:00 AM', room: 'R1'),
      );
      first.addTask(PlannerTask(
        title: 'Saved Task',
        subject: 'Web Development',
        due: DateTime(2026, 10, 10),
        completed: false,
      ));
      first.addNote(PlannerNote(
        title: 'Saved Note',
        subject: 'General',
        body: 'Still here',
        updated: DateTime(2026, 10, 3),
      ));
      await first.saved;

      // A brand new store, like reopening the app.
      final second = PlannerStore();
      await second.load();
      expect(second.classesFor('Sat').single.subject, 'Saved Class');
      expect(second.allTasks.any((t) => t.title == 'Saved Task'), isTrue);
      expect(second.notes.any((n) => n.title == 'Saved Note'), isTrue);
      expect(
        second.allTasks.firstWhere((t) => t.title == 'Saved Task').due,
        DateTime(2026, 10, 10),
      );
    });

    test('Checked and deleted items stay that way after a restart', () async {
      SharedPreferences.setMockInitialValues({});
      final first = PlannerStore();
      await first.load();

      final target = first.upcomingTasks.first;
      first.setTaskCompleted(target, true);
      first.deleteTask(first.upcomingTasks.first);
      await first.saved;

      final second = PlannerStore();
      await second.load();
      expect(
        second.allTasks.firstWhere((t) => t.title == target.title).completed,
        isTrue,
      );
      expect(second.allTasks.length, first.allTasks.length);
    });

    test('First run keeps the sample data', () async {
      SharedPreferences.setMockInitialValues({});
      final store = PlannerStore();
      await store.load();
      expect(store.allTasks, isNotEmpty);
      expect(store.classesFor('Mon'), isNotEmpty);
    });

    test('Unreadable saved data falls back to the sample data', () async {
      SharedPreferences.setMockInitialValues({PlannerStore.storageKey: 'oops'});
      final store = PlannerStore();
      await store.load();
      expect(store.allTasks, isNotEmpty);
      expect(store.classesFor('Mon'), isNotEmpty);
    });
  });
}
