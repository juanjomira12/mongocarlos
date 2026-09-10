import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Estado en el que se encuentra una actividad de la agenda.
///
/// La Fase 2 persiste el valor de [apiValue] en la columna `estado` de la
/// tabla de tareas.
enum TaskStatus {
  pending('pendiente', 'Pendiente', Icons.schedule_outlined, AppColors.warning),
  inProgress(
    'en_progreso',
    'En progreso',
    Icons.play_circle_outline,
    AppColors.secondary,
  ),
  done('completada', 'Completada', Icons.check_circle_outline, AppColors.success);

  const TaskStatus(this.apiValue, this.label, this.icon, this.color);

  /// Valor que viaja hacia y desde la API REST.
  final String apiValue;

  /// Texto visible para el usuario.
  final String label;

  final IconData icon;
  final Color color;

  /// Convierte el valor recibido de la API en un [TaskStatus].
  ///
  /// Si el valor es desconocido o nulo se asume [TaskStatus.pending].
  static TaskStatus fromApi(String? value) {
    return TaskStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => TaskStatus.pending,
    );
  }
}
