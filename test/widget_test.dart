// A widget test: it builds your app in memory and checks what is on screen.
// Run them all with: flutter test
//
// You are not required to write more of these, but a project with a few real
// tests reads very differently from one with none.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/main.dart';

void main() {
  testWidgets('Dashboard shows its title, greeting, and today\'s classes',
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

    // One of today's sample classes should be visible
    expect(find.text('Discrete Mathematics'), findsOneWidget);

    // One of the sample upcoming tasks, still Pending
    expect(find.text('Packet Tracer Lab 3'), findsOneWidget);
    expect(find.text('Pending'), findsWidgets);
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