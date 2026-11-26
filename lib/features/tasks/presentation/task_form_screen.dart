import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskDraft {
  const TaskDraft(
    this.title,
    this.description,
    this.priority, {
    this.dueDate,
  });

  final String title;
  final String description;
  final String priority;
  final DateTime? dueDate;
}

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  String _priority = 'Media';
  DateTime? _dueDate;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
      helpText: 'Elige la fecha límite',
    );
    if (picked == null) return;
    setState(() => _dueDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final draft = TaskDraft(
      _title.text.trim(),
      _description.text.trim(),
      _priority,
      dueDate: _dueDate,
    );
    context.pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva tarea')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (value) {
                final title = value?.trim() ?? '';
                if (title.isEmpty) return 'Escribe un título para tu tarea.';
                if (title.length < 3) {
                  return 'El título necesita al menos 3 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
              ),
              maxLines: 3,
              validator: (value) {
                final description = value?.trim() ?? '';
                if (description.length > 200) {
                  return 'La descripción no puede pasar de 200 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Prioridad'),
              items: ['Alta', 'Media', 'Baja']
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => _priority = value ?? 'Media'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.event),
                    label: Text(
                      _dueDate == null
                          ? 'Fecha límite (opcional)'
                          : 'Fecha límite: ${_formatDate(_dueDate!)}',
                    ),
                  ),
                ),
                if (_dueDate != null)
                  IconButton(
                    tooltip: 'Quitar fecha',
                    onPressed: () => setState(() => _dueDate = null),
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _submit, child: const Text('Guardar')),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
