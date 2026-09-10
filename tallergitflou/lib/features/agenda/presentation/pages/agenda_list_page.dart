import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/task.dart';
import '../controllers/agenda_controller.dart';
import '../widgets/agenda_empty_state.dart';
import '../widgets/agenda_summary.dart';
import '../widgets/task_card.dart';
import 'task_form_page.dart';

/// Pantalla principal de la agenda: lista, busca y filtra las actividades.
class AgendaListPage extends StatefulWidget {
  const AgendaListPage({super.key, this.controller});

  /// Permite inyectar un controlador propio en pruebas.
  final AgendaController? controller;

  @override
  State<AgendaListPage> createState() => _AgendaListPageState();
}

class _AgendaListPageState extends State<AgendaListPage> {
  final _searchController = TextEditingController();

  AgendaController get _agenda =>
      widget.controller ?? AgendaController.instance;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Abre el formulario y agrega la tarea creada.
  Future<void> _createTask() async {
    final created = await Navigator.of(context).push<Task>(
      MaterialPageRoute(builder: (_) => const TaskFormPage()),
    );
    if (created == null) return;

    _agenda.add(created);
    _showMessage('Tarea creada', AppColors.success);
  }

  /// Abre el formulario en modo edicion.
  Future<void> _editTask(Task task) async {
    final edited = await Navigator.of(context).push<Task>(
      MaterialPageRoute(builder: (_) => TaskFormPage(task: task)),
    );
    if (edited == null) return;

    _agenda.update(edited);
    _showMessage('Tarea actualizada', AppColors.success);
  }

  /// Elimina la tarea permitiendo deshacer desde el snackbar.
  void _deleteTask(Task task) {
    _agenda.remove(task.id);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Se elimino la tarea ${task.title}'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () => _agenda.add(task),
          ),
        ),
      );
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.agendaTitle),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: AppStrings.profileTitle,
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createTask,
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.newTaskAction),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _agenda,
          builder: (context, _) {
            final tasks = _agenda.visibleTasks;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AgendaSummary(
                            pendingCount: _agenda.pendingCount,
                            doneCount: _agenda.doneCount,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _searchController,
                            onChanged: _agenda.setSearch,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: AppStrings.agendaSearchHint,
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _agenda.search.isEmpty
                                  ? null
                                  : IconButton(
                                      tooltip: 'Limpiar',
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        _searchController.clear();
                                        _agenda.setSearch('');
                                      },
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _FilterChips(
                            selected: _agenda.filter,
                            onSelected: _agenda.setFilter,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: tasks.isEmpty
                          ? SingleChildScrollView(
                              child: AgendaEmptyState(
                                title: AppStrings.agendaEmptyTitle,
                                message: _agenda.search.isEmpty
                                    ? AppStrings.agendaEmptyMessage
                                    : 'Ninguna tarea coincide con la busqueda.',
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return TaskCard(
                                  key: ValueKey(task.id),
                                  task: task,
                                  onTap: () => _editTask(task),
                                  onToggleDone: () =>
                                      _agenda.toggleDone(task.id),
                                  onDelete: () => _deleteTask(task),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Fila de chips para filtrar las tareas por estado.
class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onSelected});

  final AgendaFilter selected;
  final ValueChanged<AgendaFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in AgendaFilter.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(filter.label),
                selected: filter == selected,
                onSelected: (_) => onSelected(filter),
                showCheckmark: false,
                backgroundColor: AppColors.surface,
                selectedColor: AppColors.primary.withValues(alpha: 0.14),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: filter == selected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                side: BorderSide(
                  color: filter == selected
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
