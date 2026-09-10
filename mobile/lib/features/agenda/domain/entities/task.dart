import 'task_priority.dart';
import 'task_status.dart';

/// Entidad de dominio que representa una actividad de la agenda.
///
/// La Fase 2 mapeara esta entidad contra la tabla `tareas` de la base de datos
/// relacional y contra las respuestas del CRUD declarado en `ApiConstants`.
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.dueDate,
    this.description = '',
    this.status = TaskStatus.pending,
    this.priority = TaskPriority.medium,
  });

  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskStatus status;
  final TaskPriority priority;

  /// `true` cuando la fecha limite ya paso y la tarea sigue sin completarse.
  bool get isOverdue {
    if (status == TaskStatus.done) return false;
    final today = DateTime.now();
    final limit = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final current = DateTime(today.year, today.month, today.day);
    return limit.isBefore(current);
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          other.id == id &&
          other.title == title &&
          other.description == description &&
          other.dueDate == dueDate &&
          other.status == status &&
          other.priority == priority;

  @override
  int get hashCode =>
      Object.hash(id, title, description, dueDate, status, priority);

  @override
  String toString() => 'Task(id: $id, title: $title, status: ${status.apiValue})';
}
