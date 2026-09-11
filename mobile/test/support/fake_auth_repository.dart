import 'package:agenda_app/core/network/api_exception.dart';
import 'package:agenda_app/features/auth/domain/entities/user.dart';
import 'package:agenda_app/features/auth/domain/repositories/auth_repository.dart';

/// Repositorio de prueba: responde sin tocar la red.
///
/// Si se le pasa un [error], todas las operaciones lo lanzan; asi se puede
/// comprobar como reacciona la interfaz cuando la API devuelve un fallo.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.error, User? user})
      : user = user ??
            const User(
              id: '1',
              name: 'Carlos Prueba',
              email: 'carlos@correo.com',
            );

  final ApiException? error;
  final User user;

  bool loggedOut = false;

  User _responder() {
    final failure = error;
    if (failure != null) throw failure;
    return user;
  }

  @override
  Future<User> login({required String email, required String password}) async =>
      _responder();

  @override
  Future<User> register({
    required String nombre,
    required String email,
    required String password,
  }) async =>
      _responder();

  @override
  Future<User> profile() async => _responder();

  @override
  Future<void> forgotPassword(String email) async => _responder();

  @override
  Future<void> logout() async => loggedOut = true;

  @override
  Future<bool> hasSession() async => error == null;
}
