import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Nivel de prioridad de una actividad de la agenda.
enum TaskPriority {
  low('baja', 'Baja', AppColors.success),
  medium('media', 'Media', AppColors.warning),
  high('alta', 'Alta', AppColors.error);

  const TaskPriority(this.apiValue, this.label, this.color);

  /// Valor que viaja hacia y desde la API REST.
  final String apiValue;

  /// Texto visible para el usuario.
  final String label;

  final Color color;

  /// Convierte el valor recibido de la API en un [TaskPriority].
  static TaskPriority fromApi(String? value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.apiValue == value,
      orElse: () => TaskPriority.medium,
    );
  }
}
