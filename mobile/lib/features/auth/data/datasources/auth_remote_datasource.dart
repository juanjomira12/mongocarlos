import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

/// Llamadas HTTP puras a los endpoints de autenticacion.
///
/// No decide nada: solo envia la peticion y devuelve el JSON de la API.
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final ApiClient _client;

  /// POST /api/auth/register
  Future<Map<String, dynamic>> register({
    required String nombre,
    required String email,
    required String password,
  }) {
    return _client.post(
      ApiConstants.register,
      body: {'nombre': nombre, 'email': email, 'password': password},
    );
  }

  /// POST /api/auth/login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _client.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
    );
  }

  /// GET /api/auth/profile (requiere el JWT)
  Future<Map<String, dynamic>> profile(String token) {
    return _client.get(ApiConstants.profile, token: token);
  }

  /// POST /api/auth/forgot-password
  Future<Map<String, dynamic>> forgotPassword(String email) {
    return _client.post(
      ApiConstants.forgotPassword,
      body: {'email': email},
    );
  }
}
