import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
