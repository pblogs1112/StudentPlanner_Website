# AI usage

This project was built with AI assistance. This file is the record of it. It is
graded as the finals badge, and it is worth 100 points.

Start it in week 1 and keep it up as you go. The commit history of this file is
part of the evidence: a file written all at once the night before the deadline
looks exactly like what it is.

## 1. How I used AI

At least six entries. One per real use. Every entry needs a commit link.

### 2026-09-23 - Add Dashboard screen, theme, and shared widgets

- **Tool:Claude**
- **What I asked for: Help building the first screen of the Student Planner: the Dashboard, with an app theme and reusable widgets, following my design system and mockup.**
- **What it gave back: Code for a dashboard screen (dashboard_screen.dart), an app theme (app_theme.dart), and shared widgets (app_header, bottom_nav_bar, class_card, task_card), wired into main.dart.**
- **What I kept, what I changed, and why: I kept the generated Dashboard, theme and widget code as the base, and adjusted parts of it to match my design system so the app follows the colors and styles I defined in my design-system document.**
- **Commit: https://github.com/pblogs1112/StudentPlanner_Website/commit/b43ae8fe8b3ee2e21e479f017bb316837068209f **

### 2026-09-27 - update needs to update then add screen class schedule and calendar and make a modal for class schdule add class

- **Tool:Claude**
- **What I asked for:Add the Class Schedule and Calendar screens, and a modal for adding a class.**
- **What it gave back:Code for calendar_screen.dart, class_schedule_screen.dart, a class_form_dialog.dart widget for the add-class modal, and a new root_screen.dart that main.dart now starts from instead of the Dashboard directly.**
- **What I kept, what I changed, and why: I kept all of it as generated and changed nothing, because it gave me exactly what I needed for the Class Schedule screen, the Calendar screen and the add-class modal.**
- **Commit:** https://github.com/pblogs1112/StudentPlanner_Website/commit/84aec8ada124aa595bc0f2edb9d10fbfcfe79b86

### 2026-10-03 - Shared PlannerStore: Dashboard follows Class Schedule
- **Tool: Claude**
- **What I asked for: Make Today's Classes on the Dashboard update when I change the Class Schedule, using one shared place for the app's data.**
- **What it gave back: A new state/planner_store.dart (the PlannerStore), plus changes to main.dart, dashboard_screen.dart, class_schedule_screen.dart and calendar_screen.dart so they use the store for state management.**
- **What I kept, what I changed, and why:I kept almost all of it as generated, and made one small change in planner_store.dart by updating the initial class schedule data to match my actual classes so the dashboard shows the correct schedule.**
- **Commit:** https://github.com/pblogs1112/StudentPlanner_Website/commit/4e3e80bd1203b3a07515ad1e7a3d1121497322de

### 2026-10-03 - Task and Notes screens, Dashboard Upcoming Tasks from the store

- **Tool:Claude**
- **What I asked for:Real Task and Notes screens, so changes to tasks show up on the Calendar and the Dashboard the same way Today's Classes follows the Class Schedule, and Upcoming Tasks is no longer hardcoded.**
- **What it gave back:Task and Notes screens with add, edit and delete, note and task form dialogs, and the Dashboard changed to show upcoming tasks from the PlannerStore.**
- **What I kept, what I changed, and why:I kept most of the generated code, but made small changes to the task data and screen layout so they match my app design and the tasks update correctly across the Dashboard and Calendar.**
- **Commit:** https://github.com/pblogs1112/StudentPlanner_Website/commit/8fb26a6bb0ae2bc983f92c8ee7a5b2bb1a526143

### 2026-10-03 - Saving data with shared_preferences

- **Tool:Claude**
- **What I asked for:Save classes, tasks and notes so they persist across app restarts.**
- **What it gave back:Persistence in the PlannerStore using shared_preferences, and a change to main.dart so the app loads data before rendering.**
- **What I kept, what I changed, and why:I kept most of the generated code, but made a small change to the persistence logic so classes, tasks, and notes are saved and loaded correctly using `shared_preferences` after restarting the app.**
- **Commit:** https://github.com/pblogs1112/StudentPlanner_Website/commit/8fb26a6

### 20206-10-03 - update task handling in calendar and planner store for better clarity and functionality

- **Tool:Claude**
- **What I asked for:Clean up and improve how tasks are handled in the Calendar and the PlannerStore.**
- **What it gave back:Changes to calendar_screen.dart and planner_store.dart (plus main.dart and the widget test) to update how tasks are handled, for better clarity and functionality.**
- **What I kept, what I changed, and why:I kept all of the generated code because it provided all the important functionality I needed for the app.**
- **Commit:** https://github.com/pblogs1112/StudentPlanner_Website/commit/3855fc0

## 2. Where the AI got it wrong

Three cases. Be specific. If you write that the AI was never wrong, this section
scores zero.

### Case 1 - Wrong Initial Class Data

- **What it gave me:The AI created the PlannerStore with sample class schedule data.**
- **What was wrong with it:The sample classes did not match my actual class schedule, so the Dashboard showed incorrect classes.**
- **What I did instead:I changed the initial class schedule in planner_store.dart to match my actual classes.**
- **Commit:** https://github.com/pblogs1112/StudentPlanner_Website/commit/4e3e80bd1203b3a07515ad1e7a3d1121497322de

### Case 2 - Tasks Were Not Fully Connected

- **What it gave me:The AI created the Task and Notes screens and connected tasks to the PlannerStore.**
- **What was wrong with it:Some of the task handling did not work the way I needed across the Dashboard and Calendar.**
- **What I did instead:I adjusted the task handling so changes to tasks are properly reflected in the Calendar and Dashboard.**
- **Commit:** https://github.com/pblogs1112/StudentPlanner_Website/commit/3855fc0

### Case 3 - Persistence Needed Adjustment

- **What it gave me:The AI added shared_preferences to save classes, tasks, and notes between app restarts.**
- **What was wrong with it:The persistence setup needed a small adjustment to make sure the app loaded the saved data correctly when starting.**
- **What I did instead:I checked and adjusted the persistence logic so the saved classes, tasks, and notes are loaded correctly when the app starts.**
- **Commit:** https://github.com/pblogs1112/StudentPlanner_Website/commit/8fb26a6

## 3. Who wrote what

At least a fifth of this project is code you wrote yourself. Name it, and explain
it in your own words.

> Group projects: give each member their own heading below, and use your GitHub
> handle as the heading. You are graded on your own section.

### Written by me

- **File:lib/widgets/class_card.dart**
- **Commit:https://github.com/pblogs1112/StudentPlanner_Website/commit/b43ae8fe8b3ee2e21e479f017bb316837068209f**
- **What it does and why it is built this way:ClassCard is a StatelessWidget that displays a class's subject, time, and room. It can also show Edit and Delete buttons when callbacks are provided, making it reusable for both viewing and managing classes. It uses the app's theme and AppSpacing for consistent colors and spacing. The private _ActionLabel widget keeps the Edit/Delete buttons organized and the main code clean.**

- **File:lib/widgets/app_header.dart**
- **Commit:https://github.com/pblogs1112/StudentPlanner_Website/commit/b43ae8fe8b3ee2e21e479f017bb316837068209f**
- **What it does and why it is built this way:AppHeader is a reusable StatelessWidget that displays a screen title and an optional subtitle at the top. It uses the app theme for colors and AppSpacing for consistent spacing. It also accounts for the phone's status bar so the content does not overlap with the clock or battery icons. The header adjusts its height based on whether a subtitle is provided.**

- **File:lib/screens/root_screen.dart**
- **Commit:https://github.com/pblogs1112/StudentPlanner_Website/commit/84aec8a**
- **What it does and why it is built this way:RootScreen is the main navigation screen of the app. It uses a StatefulWidget to track the selected tab and an IndexedStack to keep all five screens alive when switching tabs. Tapping a navigation item updates the selected index and displays the correct screen. This keeps navigation centralized while shared app data remains in the PlannerStore.**

-**File: lib/screens/notes_screen.dart**
-**Commit: https://github.com/pblogs1112/StudentPlanner_Website/commit/84aec8a**
-**What it does and why it is built this way: NotesScreen manages the Notes page by letting users search, add, edit, and delete notes through the shared PlannerStore. It uses dialogs for adding and editing notes, filters notes based on the search query, and displays them using NoteCard. It is a StatefulWidget because the search query changes the displayed notes, while the actual note data is kept in the PlannerStore so it can be shared and saved across the app.**

-**File: lib/widgets/note_form_dialog.dart**
-**Commit:https://github.com/pblogs1112/StudentPlanner_Website/commit/84aec8ada124aa595bc0f2edb9d10fbfcfe79b86**
-**What it does and why it is built this way:NoteFormDialog provides a reusable form for adding and editing notes. It includes fields for the title, subject, and note content, with validation to make sure required fields are filled in. It uses controllers to manage the form values and returns the entered data to NotesScreen when saved. It is a StatefulWidget because the selected subject changes while the form is being used.**

### The AI-written part I understand best

- **File:lib/state/planner_store.dart**
- **Commit:https://github.com/pblogs1112/StudentPlanner_Website/commit/4e3e80b**
- **What it does and why we kept it: PlannerStore is the one place the app's classes, tasks and notes live. Every change goes through its methods, which call notifyListeners() and then save the data. PlannerScope shares the store with all the screens, so any screen that reads it rebuilds when the data changes. That's why the Dashboard's Today's Classes updates when I edit the Class Schedule. The data is saved under one shared_preferences key and loaded once at startup, and the sample data stays if nothing is saved. We kept it because one shared store was simpler than each screen holding its own copy.**
