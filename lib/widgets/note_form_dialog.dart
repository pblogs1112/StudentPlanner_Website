import 'package:flutter/material.dart';

class NoteFormDialog extends StatefulWidget {
  static const general = 'General';

  final String title;
  final List<String> subjects;
  final String initialTitle;
  final String initialSubject;
  final String initialBody;

  const NoteFormDialog({
    super.key,
    required this.title,
    required this.subjects,
    this.initialTitle = '',
    this.initialSubject = general,
    this.initialBody = '',
  });

  @override
  State<NoteFormDialog> createState() => _NoteFormDialogState();
}

class _NoteFormDialogState extends State<NoteFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final List<String> _subjects;
  late String _subject;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _bodyController = TextEditingController(text: widget.initialBody);
    _subjects = [NoteFormDialog.general, ...widget.subjects];
    if (!_subjects.contains(widget.initialSubject)) {
      _subjects.add(widget.initialSubject);
    }
    _subject = widget.initialSubject;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop({
        'title': _titleController.text.trim(),
        'subject': _subject,
        'body': _bodyController.text.trim(),
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
                decoration: const InputDecoration(labelText: 'Title'),
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
                onChanged: (v) => setState(() => _subject = v ?? _subject),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  alignLabelWithHint: true,
                ),
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                minLines: 4,
                maxLines: 8,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
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
