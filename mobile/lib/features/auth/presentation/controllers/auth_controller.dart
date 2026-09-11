import 'package:flutter/foundation.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Estado de la sesion del usuario.
///
/// Sigue el mismo patron que `AgendaController`: una instancia compartida
/// mientras el proyecto no use inyeccion de dependencias real.
class AuthController extends ChangeNotifier {
  AuthController({AuthRepository? repository})
      : _repository = repository ?? AuthRepositoryImpl();

  /// Instancia usada por la aplicacion.
  static final AuthController instance = AuthController();

  final AuthRepository _repository;

  User? _user;

  /// Usuario autenticado, o `null` si no hay sesion.
  User? get user => _user;

  Future<User> login({required String email, required String password}) async {
    _user = await _repository.login(email: email, password: password);
    notifyListeners();
    return _user!;
  }

  Future<User> register({
    required String nombre,
    required String email,
    required String password,
  }) async {
    _user = await _repository.register(
      nombre: nombre,
      email: email,
      password: password,
    );
    notifyListeners();
    return _user!;
  }

  /// Recarga los datos del usuario desde la API.
  Future<User> loadProfile() async {
    _user = await _repository.profile();
    notifyListeners();
    return _user!;
  }

  Future<void> forgotPassword(String email) =>
      _repository.forgotPassword(email);

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    notifyListeners();
  }

  Future<bool> hasSession() => _repository.hasSession();
}
