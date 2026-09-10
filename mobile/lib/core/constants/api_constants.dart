/// URLs base y endpoints de la API REST.
///
/// La Fase 2 (Backend & DB) implementa estos endpoints; la Fase 1 solo los
/// declara para que el frontend quede listo para conectarse.
class ApiConstants {
  const ApiConstants._();

  /// En Android el emulador expone el localhost del host en 10.0.2.2.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );

  // --- Auth (Aprendiz A) ---
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';

  // --- Agenda / Tareas (Aprendiz B) ---
  static const String tasks = '$baseUrl/tasks';

  static const Duration timeout = Duration(seconds: 20);
}
