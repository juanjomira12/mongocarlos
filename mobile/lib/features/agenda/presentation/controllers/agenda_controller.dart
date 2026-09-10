import 'package:flutter/foundation.dart';

import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/entities/task_status.dart';

/// Filtro activo en la lista de agenda.
enum AgendaFilter {
  all('Todas'),
  pending('Pendientes'),
  inProgress('En progreso'),
  done('Completadas');

  const AgendaFilter(this.label);

  final String label;

  /// Indica si la tarea pasa el filtro.
  bool matches(Task task) {
    return switch (this) {
      AgendaFilter.all => true,
      AgendaFilter.pending => task.status == TaskStatus.pending,
      AgendaFilter.inProgress => task.status == TaskStatus.inProgress,
      AgendaFilter.done => task.status == TaskStatus.done,
    };
  }
}

/// Estado en memoria de la agenda.
///
/// TODO(fase-2): reemplazar la lista local por `TaskRepository`, que consumira
/// los endpoints CRUD declarados en `ApiConstants.tasks`.
class AgendaController extends ChangeNotifier {
  AgendaController({List<Task>? initialTasks}) {
    _tasks = initialTasks == null ? _demoTasks() : List<Task>.of(initialTasks);
  }

  /// Instancia compartida mientras no exista inyeccion de dependencias real.
  static final AgendaController instance = AgendaController();

  late List<Task> _tasks;
  AgendaFilter _filter = AgendaFilter.all;
  String _search = '';

  AgendaFilter get filter => _filter;
  String get search => _search;

  /// Todas las tareas ordenadas por fecha limite.
  List<Task> get tasks {
    final ordered = List<Task>.of(_tasks)
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return List.unmodifiable(ordered);
  }

  /// Tareas que cumplen el filtro y la busqueda activos.
  List<Task> get visibleTasks {
    final query = _search.trim().toLowerCase();
    return List.unmodifiable(
      tasks.where((task) {
        if (!_filter.matches(task)) return false;
        if (query.isEmpty) return true;
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }),
    );
  }

  int get pendingCount =>
      _tasks.where((task) => task.status != TaskStatus.done).length;

  int get doneCount =>
      _tasks.where((task) => task.status == TaskStatus.done).length;

  void setFilter(AgendaFilter value) {
    if (_filter == value) return;
    _filter = value;
    notifyListeners();
  }

  void setSearch(String value) {
    if (_search == value) return;
    _search = value;
    notifyListeners();
  }

  /// Agrega la tarea generando un identificador temporal local.
  void add(Task task) {
    final id = task.id.isEmpty
        ? DateTime.now().microsecondsSinceEpoch.toString()
        : task.id;
    _tasks.add(task.copyWith(id: id));
    notifyListeners();
  }

  /// Reemplaza la tarea que comparte identificador con [task].
  void update(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
    notifyListeners();
  }

  void remove(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  /// Alterna entre completada y pendiente.
  void toggleDone(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;
    final task = _tasks[index];
    _tasks[index] = task.copyWith(
      status: task.status == TaskStatus.done
          ? TaskStatus.pending
          : TaskStatus.done,
    );
    notifyListeners();
  }

  /// Datos de ejemplo para poder revisar la interfaz sin backend.
  static List<Task> _demoTasks() {
    final today = DateTime.now();
    DateTime day(int offset) =>
        DateTime(today.year, today.month, today.day + offset);

    return [
      Task(
        id: '1',
        title: 'Entregar informe de la Fase 1',
        description: 'Adjuntar capturas de las pantallas de la agenda.',
        dueDate: day(0),
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
      ),
      Task(
        id: '2',
        title: 'Revisar merge del Aprendiz A',
        description: 'Validar el flujo de login antes de integrar a develop.',
        dueDate: day(2),
        priority: TaskPriority.medium,
      ),
      Task(
        id: '3',
        title: 'Preparar modelo de la tabla tareas',
        description: 'Definir columnas para la Fase 2 (Backend & DB).',
        dueDate: day(-1),
        priority: TaskPriority.low,
      ),
      Task(
        id: '4',
        title: 'Configurar ramas GitFlow',
        description: 'main, develop y feature por aprendiz.',
        dueDate: day(-3),
        status: TaskStatus.done,
        priority: TaskPriority.medium,
      ),
    ];
  }
}
