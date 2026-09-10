import 'package:flutter/material.dart';

import '../../domain/entities/task_priority.dart';

/// Punto de color que indica la prioridad de una tarea.
class PriorityDot extends StatelessWidget {
  const PriorityDot({super.key, required this.priority, this.showLabel = true});

  final TaskPriority priority;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: priority.color,
            shape: BoxShape.circle,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 6),
          Text(
            priority.label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: priority.color,
            ),
          ),
        ],
      ],
    );
  }
}
