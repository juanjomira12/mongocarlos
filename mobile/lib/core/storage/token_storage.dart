import 'package:shared_preferences/shared_preferences.dart';

/// Guarda el JWT en el dispositivo para que la sesion siga abierta
/// aunque se cierre la aplicacion.
class TokenStorage {
  const TokenStorage();

  static const String _tokenKey = 'auth_token';

  Future<void> save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Devuelve el token guardado, o `null` si no hay sesion.
  Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Borra el token al cerrar sesion.
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
