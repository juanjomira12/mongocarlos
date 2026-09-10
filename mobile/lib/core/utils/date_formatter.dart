/// Formateo de fechas sin dependencias externas.
///
/// Se evita `intl` para no agregar paquetes a la Fase 1; la Fase 2 puede
/// migrar a `DateFormat` si se requiere localizacion completa.
class DateFormatter {
  const DateFormatter._();

  static const List<String> _months = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];

  /// Devuelve la fecha en formato `12 mar 2026`.
  static String short(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  /// Devuelve `Hoy`, `Manana`, `Ayer` o la fecha corta segun corresponda.
  static String relative(DateTime date, {DateTime? now}) {
    final today = now ?? DateTime.now();
    final difference = DateTime(date.year, date.month, date.day)
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;

    return switch (difference) {
      0 => 'Hoy',
      1 => 'Manana',
      -1 => 'Ayer',
      _ => short(date),
    };
  }

  /// Formato `2026-03-12`, el que espera la API REST.
  static String iso(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
