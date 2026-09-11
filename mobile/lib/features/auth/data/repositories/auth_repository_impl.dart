import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Implementacion real de [AuthRepository]: habla con la API y
/// administra el token de la sesion.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    AuthRemoteDataSource? remote,
    this.storage = const TokenStorage(),
  }) : _remote = remote ?? AuthRemoteDataSource(ApiClient());

  final AuthRemoteDataSource _remote;

  /// Almacenamiento del token; se puede sustituir en las pruebas.
  final TokenStorage storage;

  @override
  Future<User> register({
    required String nombre,
    required String email,
    required String password,
  }) async {
    final data = await _remote.register(
      nombre: nombre,
      email: email,
      password: password,
    );
    return _guardarSesion(data);
  }

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final data = await _remote.login(email: email, password: password);
    return _guardarSesion(data);
  }

  @override
  Future<User> profile() async {
    final token = await storage.read();
    if (token == null) {
      throw const ApiException('No hay una sesion activa.', statusCode: 401);
    }

    try {
      final data = await _remote.profile(token);
      return UserModel.fromJson(data['usuario'] as Map<String, dynamic>);
    } on ApiException catch (error) {
      // Token vencido o invalido: se limpia para no dejar una sesion rota.
      if (error.isUnauthorized) await storage.clear();
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _remote.forgotPassword(email);
  }

  @override
  Future<void> logout() => storage.clear();

  @override
  Future<bool> hasSession() async => await storage.read() != null;

  /// Guarda el token que devuelven register y login, y arma el usuario.
  Future<User> _guardarSesion(Map<String, dynamic> data) async {
    final token = data['token'] as String?;
    if (token != null) await storage.save(token);

    return UserModel.fromJson(data['usuario'] as Map<String, dynamic>);
  }
}
