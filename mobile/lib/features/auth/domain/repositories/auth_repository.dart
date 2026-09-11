import '../entities/user.dart';

/// Contrato de autenticacion que usa la capa de presentacion.
///
/// Las pantallas dependen de esta interfaz y no de `http`, de modo que se
/// puede sustituir la implementacion real por una falsa en las pruebas.
abstract class AuthRepository {
  /// Crea la cuenta y deja la sesion iniciada.
  Future<User> register({
    required String nombre,
    required String email,
    required String password,
  });

  /// Verifica las credenciales y guarda el token de la sesion.
  Future<User> login({required String email, required String password});

  /// Datos del usuario autenticado. Requiere sesion activa.
  Future<User> profile();

  /// Solicita el correo de recuperacion de contrasena.
  Future<void> forgotPassword(String email);

  /// Borra el token guardado.
  Future<void> logout();

  /// Indica si hay un token guardado en el dispositivo.
  Future<bool> hasSession();
}
