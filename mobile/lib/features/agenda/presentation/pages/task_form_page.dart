import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/widgets/auth_submit_button.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/entities/task_status.dart';

/// Formulario de creacion y edicion de una actividad.
///
/// Devuelve la [Task] resultante con `Navigator.pop`; la pantalla de lista se
/// encarga de agregarla o actualizarla.
class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key, this.task});

  /// Tarea a editar. Si es `null` el formulario crea una nueva.
  final Task? task;

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late DateTime _dueDate;
  late TaskStatus _status;
  late TaskPriority _priority;

  bool _isSaving = false;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _dueDate = task?.dueDate ?? DateTime.now();
    _status = task?.status ?? TaskStatus.pending;
    _priority = task?.priority ?? TaskPriority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: AppStrings.taskDueDate,
    );

    if (picked == null) return;
    setState(() => _dueDate = picked);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    // TODO(fase-2): reemplazar por TaskRepository.create()/update() contra la
    // API REST (ApiConstants.tasks).
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final task = Task(
      id: widget.task?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _dueDate,
      status: _status,
      priority: _priority,
    );

    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? AppStrings.taskEditTitle : AppStrings.taskCreateTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      controller: _titleController,
                      label: AppStrings.taskTitleField,
                      hint: 'Ej. Entregar informe de la Fase 1',
                      icon: Icons.title_outlined,
                      textInputAction: TextInputAction.next,
                      validator: Validators.taskTitle,
                    ),
                    const SizedBox(height: 20),
                    _DescriptionField(controller: _descriptionController),
                    const SizedBox(height: 20),
                    _DueDateField(date: _dueDate, onTap: _pickDueDate),
                    const SizedBox(height: 20),
                    _StatusSelector(
                      value: _status,
                      onChanged: (value) => setState(() => _status = value),
                    ),
                    const SizedBox(height: 20),
                    _PrioritySelector(
                      value: _priority,
                      onChanged: (value) => setState(() => _priority = value),
                    ),
                    const SizedBox(height: 28),
                    AuthSubmitButton(
                      label: _isEditing
                          ? AppStrings.taskSaveAction
                          : AppStrings.taskCreateAction,
                      isLoading: _isSaving,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Campo multilinea para la descripcion de la tarea.
class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(AppStrings.taskDescriptionField),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 4,
          maxLength: 240,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            hintText: 'Detalles opcionales de la actividad',
          ),
        ),
      ],
    );
  }
}

/// Selector de fecha limite basado en `showDatePicker`.
class _DueDateField extends StatelessWidget {
  const _DueDateField({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(AppStrings.taskDueDate),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.calendar_today_outlined),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormatter.short(date),
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Segmentos para elegir el estado de la tarea.
class _StatusSelector extends StatelessWidget {
  const _StatusSelector({required this.value, required this.onChanged});

  final TaskStatus value;
  final ValueChanged<TaskStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(AppStrings.taskStatusField),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final status in TaskStatus.values)
              ChoiceChip(
                label: Text(status.label),
                avatar: Icon(status.icon, size: 16, color: status.color),
                selected: status == value,
                onSelected: (_) => onChanged(status),
                showCheckmark: false,
                backgroundColor: AppColors.surface,
                selectedColor: status.color.withValues(alpha: 0.14),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: status == value
                      ? status.color
                      : AppColors.textSecondary,
                ),
                side: BorderSide(
                  color: status == value ? status.color : AppColors.border,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Menu desplegable para elegir la prioridad.
class _PrioritySelector extends StatelessWidget {
  const _PrioritySelector({required this.value, required this.onChanged});

  final TaskPriority value;
  final ValueChanged<TaskPriority> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(AppStrings.taskPriorityField),
        const SizedBox(height: 8),
        DropdownButtonFormField<TaskPriority>(
          initialValue: value,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.flag_outlined),
          ),
          items: [
            for (final priority in TaskPriority.values)
              DropdownMenuItem(
                value: priority,
                child: Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: priority.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(priority.label),
                  ],
                ),
              ),
          ],
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
        ),
      ],
    );
  }
}

/// Etiqueta con el mismo estilo que usa `AuthTextField`.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
