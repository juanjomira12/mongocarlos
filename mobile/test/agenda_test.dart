import 'package:agenda_app/core/constants/app_theme.dart';
import 'package:agenda_app/features/agenda/domain/entities/task.dart';
import 'package:agenda_app/features/agenda/domain/entities/task_priority.dart';
import 'package:agenda_app/features/agenda/domain/entities/task_status.dart';
import 'package:agenda_app/features/agenda/presentation/controllers/agenda_controller.dart';
import 'package:agenda_app/features/agenda/presentation/pages/agenda_list_page.dart';
import 'package:agenda_app/features/agenda/presentation/pages/task_form_page.dart';
import 'package:agenda_app/features/agenda/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tarea de apoyo para las pruebas.
Task buildTask({
  String id = 't1',
  String title = 'Tarea de prueba',
  TaskStatus status = TaskStatus.pending,
}) {
  return Task(
    id: id,
    title: title,
    description: 'Descripcion de prueba',
    dueDate: DateTime(2026, 3, 12),
    status: status,
    priority: TaskPriority.medium,
  );
}

/// Envuelve una pantalla con el tema de la app para poder testearla aislada.
Widget wrap(Widget child) {
  return MaterialApp(theme: AppTheme.light, home: child);
}

void main() {
  group('AgendaController', () {
    test('agrega una tarea generando identificador', () {
      final controller = AgendaController(initialTasks: const []);

      controller.add(buildTask(id: ''));

      expect(controller.tasks, hasLength(1));
      expect(controller.tasks.first.id, isNotEmpty);
    });

    test('alterna el estado entre pendiente y completada', () {
      final controller = AgendaController(initialTasks: [buildTask()]);

      controller.toggleDone('t1');
      expect(controller.tasks.first.status, TaskStatus.done);

      controller.toggleDone('t1');
      expect(controller.tasks.first.status, TaskStatus.pending);
    });

    test('filtra por estado', () {
      final controller = AgendaController(
        initialTasks: [
          buildTask(id: 'a'),
          buildTask(id: 'b', status: TaskStatus.done),
        ],
      );

      controller.setFilter(AgendaFilter.done);

      expect(controller.visibleTasks, hasLength(1));
      expect(controller.visibleTasks.first.id, 'b');
    });

    test('busca por titulo', () {
      final controller = AgendaController(
        initialTasks: [
          buildTask(id: 'a', title: 'Comprar materiales'),
          buildTask(id: 'b', title: 'Revisar merge'),
        ],
      );

      controller.setSearch('merge');

      expect(controller.visibleTasks, hasLength(1));
      expect(controller.visibleTasks.first.id, 'b');
    });

    test('elimina una tarea', () {
      final controller = AgendaController(initialTasks: [buildTask()]);

      controller.remove('t1');

      expect(controller.tasks, isEmpty);
    });
  });

  group('Task', () {
    test('marca como vencida una tarea pendiente con fecha pasada', () {
      final task = buildTask().copyWith(
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
      );

      expect(task.isOverdue, isTrue);
    });

    test('una tarea completada nunca esta vencida', () {
      final task = buildTask(status: TaskStatus.done).copyWith(
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
      );

      expect(task.isOverdue, isFalse);
    });
  });

  group('AgendaListPage', () {
    testWidgets('muestra las tareas del controlador', (tester) async {
      final controller = AgendaController(
        initialTasks: [buildTask(title: 'Entregar informe')],
      );

      await tester.pumpWidget(wrap(AgendaListPage(controller: controller)));

      expect(find.byType(TaskCard), findsOneWidget);
      expect(find.text('Entregar informe'), findsOneWidget);
    });

    testWidgets('muestra el estado vacio sin tareas', (tester) async {
      final controller = AgendaController(initialTasks: const []);

      await tester.pumpWidget(wrap(AgendaListPage(controller: controller)));

      expect(find.byType(TaskCard), findsNothing);
      expect(find.text('Sin tareas por aqui'), findsOneWidget);
    });

    testWidgets('completa una tarea desde el checkbox', (tester) async {
      final controller = AgendaController(initialTasks: [buildTask()]);

      await tester.pumpWidget(wrap(AgendaListPage(controller: controller)));
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      expect(controller.tasks.first.status, TaskStatus.done);
    });
  });

  group('TaskFormPage', () {
    testWidgets('valida el titulo antes de guardar', (tester) async {
      await tester.pumpWidget(wrap(const TaskFormPage()));

      await tester.enterText(find.byType(TextFormField).first, 'ab');
      await tester.pumpAndSettle();

      expect(
        find.text('El titulo debe tener al menos 4 caracteres'),
        findsOneWidget,
      );
    });

    testWidgets('precarga los datos al editar', (tester) async {
      await tester.pumpWidget(
        wrap(TaskFormPage(task: buildTask(title: 'Revisar merge'))),
      );

      expect(find.text('Editar tarea'), findsOneWidget);
      expect(find.text('Revisar merge'), findsOneWidget);
    });
  });
}
