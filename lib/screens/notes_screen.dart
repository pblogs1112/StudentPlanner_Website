import 'package:flutter/material.dart';
import '../state/planner_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/note_card.dart';
import '../widgets/note_form_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String _query = '';

  Future<void> _addNote() async {
    final store = PlannerScope.read(context);
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => NoteFormDialog(
        title: 'Add Note',
        subjects: store.subjects,
      ),
    );
    if (result == null) return;

    store.addNote(PlannerNote(
      title: result['title']!,
      subject: result['subject']!,
      body: result['body']!,
      updated: DateTime.now(),
    ));
  }

  Future<void> _editNote(PlannerNote existing) async {
    final store = PlannerScope.read(context);
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => NoteFormDialog(
        title: 'Edit Note',
        subjects: store.subjects,
        initialTitle: existing.title,
        initialSubject: existing.subject,
        initialBody: existing.body,
      ),
    );
    if (result == null) return;

    store.updateNote(
      existing,
      PlannerNote(
        title: result['title']!,
        subject: result['subject']!,
        body: result['body']!,
        updated: DateTime.now(),
      ),
    );
  }

  bool _matches(PlannerNote n) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return n.title.toLowerCase().contains(q) ||
        n.subject.toLowerCase().contains(q) ||
        n.body.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = PlannerScope.of(context);
    final notes = store.notes.where(_matches).toList();

    return Column(
      children: [
        const AppHeader(title: 'Notes'),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Search notes',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
          child: ElevatedButton(
            onPressed: _addNote,
            child: const Text('+ Add Note'),
          ),
        ),
        Expanded(
          child: notes.isEmpty
              ? Center(
                  child: Text(
                    _query.trim().isEmpty
                        ? 'No notes yet.'
                        : 'No notes match "${_query.trim()}".',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: notes.length,
                  itemBuilder: (context, i) {
                    final n = notes[i];
                    return NoteCard(
                      title: n.title,
                      subject: n.subject,
                      body: n.body,
                      updated: PlannerStore.formatDue(n.updated),
                      onEdit: () => _editNote(n),
                      onDelete: () => store.deleteNote(n),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
