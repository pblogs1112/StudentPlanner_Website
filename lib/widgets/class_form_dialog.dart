import 'package:flutter/material.dart';

/// lib/widgets/class_form_dialog.dart
/// Modal used by the Class Schedule screen to add or edit a class.
/// Returns a {day, subject, time, room} map via Navigator.pop when
/// saved, or null if the user cancels.
class ClassFormDialog extends StatefulWidget {
  final String title;
  final List<String> days;
  final String initialDay;
  final String initialSubject;
  final String initialTime;
  final String initialRoom;

  const ClassFormDialog({
    super.key,
    required this.title,
    required this.days,
    required this.initialDay,
    this.initialSubject = '',
    this.initialTime = '',
    this.initialRoom = '',
  });

  @override
  State<ClassFormDialog> createState() => _ClassFormDialogState();
}

class _ClassFormDialogState extends State<ClassFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _day;
  late final TextEditingController _subjectController;
  late final TextEditingController _timeController;
  late final TextEditingController _roomController;

  @override
  void initState() {
    super.initState();
    _day = widget.initialDay;
    _subjectController = TextEditingController(text: widget.initialSubject);
    _timeController = TextEditingController(text: widget.initialTime);
    _roomController = TextEditingController(text: widget.initialRoom);
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _timeController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop({
        'day': _day,
        'subject': _subjectController.text.trim(),
        'time': _timeController.text.trim(),
        'room': _roomController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialSubject.isNotEmpty;

    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _day,
                decoration: const InputDecoration(labelText: 'Day'),
                items: [
                  for (final d in widget.days)
                    DropdownMenuItem(value: d, child: Text(d)),
                ],
                onChanged: (v) => setState(() => _day = v ?? _day),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  hintText: 'e.g. 9:00 AM - 10:30 AM',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: 'Room'),
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
