import 'package:flutter/material.dart';
import '../state/planner_store.dart';

class TaskFormDialog extends StatefulWidget {
  final String title;
  final List<String> subjects;
  final String initialTitle;
  final String? initialSubject;
  final DateTime? initialDue;

  const TaskFormDialog({
    super.key,
    required this.title,
    required this.subjects,
    this.initialTitle = '',
    this.initialSubject,
    this.initialDue,
  });

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late List<String> _subjects;
  String? _subject;
  late DateTime _due;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    // Keep the task's current subject selectable even if its class was
    // removed from the schedule since.
    _subjects = List<String>.of(widget.subjects);
    final initial = widget.initialSubject;
    if (initial != null && !_subjects.contains(initial)) _subjects.add(initial);
    _subject = initial ?? (_subjects.isNotEmpty ? _subjects.first : null);
    _due = widget.initialDue ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _due,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _due = picked);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop({
        'title': _titleController.text.trim(),
        'subject': _subject!,
        'due': DateTime(_due.year, _due.month, _due.day),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialTitle.isNotEmpty;

    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task'),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _subject,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Subject'),
                items: [
                  for (final s in _subjects)
                    DropdownMenuItem(value: s, child: Text(s)),
                ],
                onChanged: (v) => setState(() => _subject = v),
                validator: (v) => v == null ? 'Add a class first' : null,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due date',
                    suffixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                  ),
                  child: Text(PlannerStore.formatDue(_due)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(isEdit ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
