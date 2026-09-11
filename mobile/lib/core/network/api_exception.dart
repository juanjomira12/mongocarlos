/// Error controlado de la API.
///
/// Permite que las pantallas muestren el mensaje que devuelve el backend
/// (por ejemplo "El correo ya esta registrado") en lugar de un error tecnico.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.errors = const []});

  /// Mensaje listo para mostrar al usuario.
  final String message;

  /// Codigo HTTP devuelto por la API, si lo hubo.
  final int? statusCode;

  /// Lista de errores de validacion que devuelve el backend.
  final List<String> errors;

  /// La sesion expiro o el token no es valido.
  bool get isUnauthorized => statusCode == 401;

  /// Texto completo: mensaje principal mas los errores de validacion.
  String get detail => errors.isEmpty ? message : errors.join('\n');

  @override
  String toString() => 'ApiException($statusCode): $message';
}
